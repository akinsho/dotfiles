local api, L = vim.api, vim.log.levels
local strwidth, fmt, empty = api.nvim_strwidth, string.format, as.empty

---@alias StringComponent {component: string, length: integer, priority: integer}

local M = {}

local constants = { HL_END = '%*', ALIGN = '%=', END = '%<', CLICK_END = '%X' }
local padding = ' '

M.constants = constants

--- @param hl string
local function wrap(hl)
  assert(hl, 'A highlight name must be specified')
  return '%#' .. hl .. '#'
end

----------------------------------------------------------------------------------------------------
-- COMPONENTS
----------------------------------------------------------------------------------------------------

---@type fun(): StringComponent
M.separator = function() return { component = constants.ALIGN, length = 0, priority = 0 } end
---@type fun(): StringComponent
M.end_marker = function() return { component = constants.END, length = 0, priority = 0 } end

---@param func_name string
---@param id string
---@return string
local function get_click_start(func_name, id)
  if not id then
    vim.schedule(
      function()
        vim.notify_once(
          fmt('An ID is needed to enable click handler %s to work', func_name),
          L.ERROR,
          { title = 'Statusline' }
        )
      end
    )
    return ''
  end
  return '%' .. id .. '@' .. func_name .. '@'
end

--- Creates a spacer statusline component i.e. for padding
--- or to represent an empty component
--- @param size integer?
--- @param opts table<string, any>?
--- @return StringComponent
function M.spacer(size, opts)
  opts = opts or {}
  local filler = opts.filler or ' '
  local priority = opts.priority or 0
  if size and size >= 1 then
    local spacer = string.rep(filler, size)
    return { component = spacer, length = strwidth(spacer), priority = priority }
  end
  return { component = '', length = 0, priority = priority }
end

---@alias Subsection (string|number)[][]

---@param subsection Subsection
---@param bg_hl string
---@param opts {pad_end: boolean}
---@return string, string
local function get_subsection(subsection, bg_hl, opts)
  if not subsection or not vim.tbl_islist(subsection) then return '', '' end
  local section, items = {}, {}
  local index = opts.pad_end and #subsection + 1 or 1
  table.insert(subsection, index, { padding, bg_hl })
  for _, item in ipairs(subsection) do
    local text, hl = unpack(item)
    if not empty(text) then
      if empty(hl) then hl = bg_hl end
      table.insert(items, text)
      table.insert(section, wrap(hl) .. text)
    end
  end
  return table.concat(section), table.concat(items)
end

--- @class ComponentOpts
--- @field priority number
--- @field click string
--- @field suffix Subsection?
--- @field prefix Subsection?
--- @field before string
--- @field after string
--- @field id number
--- @field max_size integer

--- @param item string | number
--- @param hl string
--- @param opts ComponentOpts
--- @return StringComponent
function M.component(item, hl, opts)
  -- do not allow empty values to be shown note 0 is considered empty
  -- since if there is nothing of something I don't need to see it
  if empty(item) then return M.spacer() end
  if not opts then opts = {} end
  if not opts.priority then opts.priority = 10 end
  local before, after = opts.before or '', opts.after or padding
  local prefix_item, prefix = get_subsection(opts.prefix, hl, { pad_end = true })
  local suffix_item, suffix = get_subsection(opts.suffix, hl, { pad_end = false })

  local click_start = opts.click and get_click_start(opts.click, tostring(opts.id)) or ''
  local click_end = opts.click and constants.CLICK_END or ''

  --- handle numeric inputs etc.
  if type(item) ~= 'string' then item = tostring(item) end

  if opts.max_size and item and #item >= opts.max_size then
    -- replace contents of quotes with ellipsis
    local match, count = item:gsub('([\'"]).*%1', '%1…%1')
    item = count > 0 and match or item:sub(1, opts.max_size - 1) .. '…'
  end

  return {
    component = table.concat({
      click_start,
      before,
      prefix_item,
      constants.HL_END,
      hl and wrap(hl) or '',
      item,
      constants.HL_END,
      suffix_item,
      constants.HL_END,
      after,
      click_end,
    }),
    length = strwidth(item .. before .. after .. suffix .. prefix),
    priority = opts.priority,
  }
end

--- @param item string | number
--- @param condition table | string | number | boolean
--- @param hl string
--- @param opts ComponentOpts
function M.component_if(item, condition, hl, opts)
  if not condition then return M.spacer() end
  return M.component(item, hl, opts)
end

--- @class RawComponentOpts
--- @field priority number
--- @field win_id number
--- @field type "statusline" | "tabline" | "winbar"

---Render a component that already has statusline format items and highlights in place
---@param item string
---@param opts RawComponentOpts
---@return table
function M.component_raw(item, opts)
  local priority = opts.priority or 0
  local win_id = opts.win_id or 0
  local container_type = opts.type or 'statusline'
  local ok, data = pcall(api.nvim_eval_statusline, item, {
    use_winbar = container_type == 'winbar',
    use_tabline = container_type == 'tabline',
    winid = win_id,
  })
  if not ok then return { component = '', length = 0, priority = priority } end
  return { component = item, length = data.width, priority = priority }
end

----------------------------------------------------------------------------------------------------
-- RENDER
----------------------------------------------------------------------------------------------------
local function sum_lengths(list)
  return as.fold(function(acc, item) return acc + (item.length or 0) end, list, 0)
end

local function is_lowest(item, lowest)
  -- if there hasn't been a lowest selected so far, then the item is the lowest
  if not lowest or not lowest.length then return true end
  -- if the item doesn't have a priority or a length, it is likely a special character so should never be the lowest
  if not item.priority or not item.length then return false end
  -- if the item has the same priority as the lowest, then if the item has a greater length it should become the lowest
  if item.priority == lowest.priority then return item.length > lowest.length end
  return item.priority > lowest.priority
end

--- Take the lowest priority items out of the statusline if we don't have
--- space for them.
--- TODO: currently this doesn't account for if an item that has a lower priority
--- could be fit in instead
--- @param statusline table
--- @param space number
--- @param length number
local function prioritize(statusline, space, length)
  length = length or sum_lengths(statusline)
  if length <= space then return statusline end
  local lowest, index_to_remove
  for idx, c in ipairs(statusline) do
    if is_lowest(c, lowest) then
      lowest, index_to_remove = c, idx
    end
  end
  table.remove(statusline, index_to_remove)
  return prioritize(statusline, space, length - lowest.length)
end

--- @param statusline StringComponent[]
--- @param available_space number?
--- @return string
function M.display(statusline, available_space)
  local items = available_space and prioritize(statusline, available_space) or statusline
  local components = vim.tbl_map(function(item) return item.component end, items)
  return table.concat(components, '')
end

---Aggregate pieces of the statusline
---@param tbl StringComponent[]
---@return fun(...:ComponentOpts)
function M.append(tbl)
  return function(...)
    for i = 1, select('#', ...) do
      local item = select(i, ...)
      if not item.component or not type(item.component) == 'string' then
        vim.notify('Invalid component: ' .. vim.inspect(item), vim.log.levels.ERROR)
      else
        tbl[#tbl + 1] = item
      end
    end
  end
end

return M
