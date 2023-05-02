----------------------------------------------------------------------------------------------------
--  FORMAT STRINGS
----------------------------------------------------------------------------------------------------
-- This is essentially a small library (for me) for working with vim format strings for things
-- like the tabline, statusline, winbar and statuscolumn. Since there are so many things that work
-- this way one small library to create these strings is useful.

local api, L = vim.api, vim.log.levels
local strwidth, fmt, falsy = api.nvim_strwidth, string.format, as.falsy

---@class StringComponent
---@field component string
---@field length integer,
---@field priority integer

local M = {}

local CLICK_END = '%X'
local padding = ' '

----------------------------------------------------------------------------------------------------
-- COMPONENTS
----------------------------------------------------------------------------------------------------

---@return StringComponent
local separator = { component = '%=', length = 0, priority = 0 }

---@param func_name string
---@param id string
---@return string
local function get_click_start(func_name, id)
  if not id then
    vim.schedule(function()
      local msg = fmt('An ID is needed to enable click handler %s to work', func_name)
      vim.notify_once(msg, L.ERROR, { title = 'Statusline' })
    end)
    return ''
  end
  return ('%%%d@%s@'):format(id, func_name)
end

--- Creates a spacer statusline component i.e. for padding
--- or to represent an empty component
--- @param size integer?
--- @param opts table<string, any>?
--- @return ComponentOpts?
function M.spacer(size, opts)
  opts = opts or {}
  local filler = opts.filler or ' '
  local priority = opts.priority or 0
  if not size or size < 1 then return end
  local spacer = string.rep(filler, size)
  return { { { spacer } }, priority = priority, before = '', after = '' }
end

--- truncate with an ellipsis or if surrounded by quotes, replace contents of quotes with ellipsis
--- @param str string
--- @param max_size integer
--- @return string
local function truncate_str(str, max_size)
  if not max_size or strwidth(str) < max_size then return str end
  local match, count = str:gsub('([\'"]).*%1', '%1…%1')
  return count > 0 and match or str:sub(1, max_size - 1) .. '…'
end

---@alias Chunks {[1]: string | number, [2]: string, max_size: integer?}[]

---@param chunks Chunks
---@return string
local function chunks_to_string(chunks)
  if not chunks or not vim.tbl_islist(chunks) then return '' end
  local strings = vim
    .iter(chunks)
    :map(function(item)
      local text, hl = unpack(item)
      if falsy(text) then return end
      if type(text) ~= 'string' then text = tostring(text) end
      if item.max_size then text = truncate_str(text, item.max_size) end
      text = text:gsub('%%', '%%%1')
      return not falsy(hl) and ('%%#%s#%s%%*'):format(hl, text) or text
    end)
    :totable()
  return table.concat(strings)
end

--- @class ComponentOpts
--- @field [1] Chunks
--- @field priority number
--- @field click string
--- @field before string
--- @field after string
--- @field id number
--- @field max_size integer
--- @field cond boolean | number | table | string,

--- @param opts ComponentOpts
--- @return StringComponent?
local function component(opts)
  assert(opts, 'component options are required')
  if opts.cond ~= nil and falsy(opts.cond) then return end

  local item = opts[1]
  if not vim.tbl_islist(item) then
    error(fmt('component options are required but got %s instead', vim.inspect(item)))
  end

  if not opts.priority then opts.priority = 10 end
  local before, after = opts.before or '', opts.after or padding

  local item_str = chunks_to_string(item)
  if strwidth(item_str) == 0 then return end

  local click_start = opts.click and get_click_start(opts.click, tostring(opts.id)) or ''
  local click_end = opts.click and CLICK_END or ''
  local component_str = table.concat({ click_start, before, item_str, after, click_end })
  return {
    component = component_str,
    length = api.nvim_eval_statusline(component_str, { maxwidth = 0 }).width,
    priority = opts.priority,
  }
end

----------------------------------------------------------------------------------------------------
-- RENDER
----------------------------------------------------------------------------------------------------

--- Sort components by size and priority use a stack for the components and remove the next most important
--- TODO: also tracking what we remove in a separate list ordered by size and priority
--- and trying to re-add them in that order if there is space
---
---@param components StringComponent[]
---@param available_space integer
local function order_by_priority(components, available_space)
  ---@type {[1]: StringComponent[], [2]: integer}
  local ordered_tuples = vim.iter(ipairs(components)):map(function(idx, item) return { idx, item } end):totable()

  table.sort(ordered_tuples, function(a_item, b_item)
    local a, b = a_item[2], b_item[2]
    if not a.priority then return a.priority < b.priority end
    if not b.priority then return a.priority > b.priority end
    if not a.priority and not b.priority then return 0 end
    if a.priority == b.priority then return a.length < b.length end
    return a.priority > b.priority
  end)

  ---@type {[integer]: StringComponent[]}
  local result, size, is_too_big = {}, 0, false
  while available_space and not is_too_big and #ordered_tuples > 0 do
    for i = #ordered_tuples, 1, -1 do
      local index, item = ordered_tuples[i][1], ordered_tuples[i][2]
      local next_size = size + item.length
      is_too_big = next_size > available_space
      if is_too_big then break end
      size = next_size
      result[index], ordered_tuples[i] = item, nil
    end
  end
  return vim.iter(pairs(result)):fold('', function(acc, _, item) return acc .. (item and item.component or '') end)
end

--- Take a list of sections e.g. `{{c_1, c_2}, {c_5}, {c_3, c_4}}` and returns a list of components
--- and convert them to a list of components e.g. `{c_1, c_2, sep, c_5, sep, c_3, c_4}`
---@param sections ComponentOpts[][]
local function flatten_sections(sections)
  return vim.iter(ipairs(sections)):fold({ items = {}, size = 0 }, function(acc, count, section)
    if #section == 0 then
      table.insert(acc.items, separator)
      return acc
    end
    vim.iter(ipairs(section)):each(function(index, args)
      if not args then return end
      local ok, cmp = as.pcall(fmt('creating component'), component, args)
      if not ok then return end
      table.insert(acc.items, cmp)
      acc.size = acc.size + (cmp and cmp.length or 0)
      if #section == index and count ~= #sections then table.insert(acc.items, separator) end
    end)
    return acc
  end)
end

--- @param sections ComponentOpts[][]
--- @param available_space number?
--- @return string
function M.display(sections, available_space)
  local res = flatten_sections(sections)
  if not available_space or res.size < available_space then
    return vim.iter(res.items):fold('', function(acc, item) return acc .. item.component end)
  end
  return order_by_priority(res.items, available_space)
end

--- A helper class that allow collecting `...StringComponent`
--- into sections that can then be added to each other
--- i.e.
--- ```lua
--- section1:new(1, 2, 3) + section2:new(4, 5, 6) + section3(7, 8, 9)
--- {1, 2, 3, 4, 5, 6, 7, 8, 9} -- <--
--- ```
---@class Section
---@field __add fun(l:Section, r:Section): StringComponent[]
---@field __index Section
---@field new fun(...:StringComponent[]): Section
local section = {}
function section:new(...)
  local o = { ... }
  self.__index = self
  self.__add = function(l, r)
    local rt = { unpack(l) }
    for _, v in ipairs(r) do
      rt[#rt + 1] = v
    end
    return rt
  end
  return setmetatable(o, self)
end
M.section = section

return M
