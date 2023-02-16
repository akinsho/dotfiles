local api, notify, fmt = vim.api, vim.notify, string.format

as.highlight = { win_hl = {} }

---@alias ErrorMsg {msg: string}

---@class HighlightAttributes
---@field from string
---@field attr 'foreground' | 'fg' | 'background' | 'bg'
---@field alter integer

---@class HighlightKeys
---@field blend integer
---@field foreground string | HighlightAttributes
---@field background string | HighlightAttributes
---@field fg string | HighlightAttributes
---@field bg string | HighlightAttributes
---@field sp string | HighlightAttributes
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdot boolean

---@class NvimHighlightData
---@field foreground string
---@field background string
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdot boolean

---Convert a hex color to RGB
---@param color string
---@return number
---@return number
---@return number
local function hex_to_rgb(color)
  local hex = color:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent) return math.floor(attr * (100 + percent) / 100) end

---@source https://stackoverflow.com/q/5560248
---see: https://stackoverflow.com/a/37797380
---@param color string A hex color
---@param percent integer a negative number darkens and a positive one brightens
---@return string
function as.highlight.alter_color(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then return 'NONE' end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return fmt('#%02x%02x%02x', r, g, b)
end

---@param group_name string A highlight group name
local function get_highlight(group_name)
  local ok, hl = pcall(api.nvim_get_hl_by_name, group_name, true)
  if not ok then return {} end
  hl.foreground = hl.foreground and '#' .. bit.tohex(hl.foreground, 6)
  hl.background = hl.background and '#' .. bit.tohex(hl.background, 6)
  hl[true] = nil -- BUG: API returns a true key which errors during the merge
  return hl
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param group string
---@param attribute string?
---@param fallback string?
---@return string, ErrorMsg?
---@overload fun(group: string): NvimHighlightData, ErrorMsg?
function as.highlight.get(group, attribute, fallback)
  assert(group, 'cannot get a highlight without specifying a group name')
  local data = get_highlight(group)
  if not attribute then return data end
  local attr = ({ fg = 'foreground', bg = 'background' })[attribute] or attribute
  local color = data[attr] or fallback
  if color then return color end
  return 'NONE', { msg = fmt('failed to get highlight %s for attribute %s', group, attribute) }
end

--- Sets a neovim highlight with some syntactic sugar. It takes a highlight table and converts
--- any highlights specified as `GroupName = { from = 'group'}` into the underlying colour
--- by querying the highlight property of the from group so it can be used when specifying highlights
--- as a shorthand to derive the right color.
--- For example:
--- ```lua
---   M.set({ MatchParen = {foreground = {from = 'ErrorMsg'}}})
--- ```
--- This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
--- NOTE: this function must NOT mutate the options table as these are re-used when the colorscheme
--- is updated
---@param name string
---@param opts HighlightKeys
---@overload fun(namespace: integer, name: string, opts: HighlightKeys): ErrorMsg[]?
---@return ErrorMsg[]?
function as.highlight.set(namespace, name, opts)
  if type(namespace) == 'string' and type(name) == 'table' then
    opts, name, namespace = name, namespace, 0
  end

  vim.validate({
    opts = { opts, 'table' },
    name = { name, 'string' },
    namespace = { namespace, 'number' },
  })

  local hl = get_highlight(opts.inherit or name)
  local errs = {}

  for attr, value in pairs(opts) do
    if type(value) == 'table' and value.from then
      local new_attr, err = as.highlight.get(value.from, value.attr or attr)
      if value.alter then new_attr = as.highlight.alter_color(new_attr, value.alter) end
      if err then table.insert(errs, err) end
      hl[attr] = new_attr
    elseif attr ~= 'inherit' then
      hl[attr] = value
    end
  end

  if not pcall(api.nvim_set_hl, namespace, name, hl) then
    table.insert(errs, { msg = fmt('failed to set highlight %s with values %s', name, hl) })
  end
  if #errs > 0 then return errs end
end

--- Set window local highlights
---@param name string
---@param win_id number
---@param hls HighlightKeys[]
function as.highlight.set_winhl(name, win_id, hls)
  local namespace = api.nvim_create_namespace(name)
  as.highlight.all(hls, namespace)
  api.nvim_win_set_hl_ns(win_id, namespace)
end

function as.highlight.clear(name)
  assert(name, 'name is required to clear a highlight')
  api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, HighlightKeys>
---@param namespace integer?
function as.highlight.all(hls, namespace)
  local errors = as.fold(function(errors, hl)
    local curr_errors = as.highlight.set(namespace or 0, next(hl))
    if curr_errors then vim.list_extend(errors, curr_errors) end
    return errors
  end, hls)
  if #errors > 0 then
    notify(as.fold(function(acc, err) return acc .. '\n' .. err.msg end, errors, ''), 'error')
  end
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
--- Takes the overrides for each theme and merges the lists, avoiding duplicates and ensuring
--- priority is given to specific themes rather than the fallback
---@param theme table<string, table<string, string>>
---@return table<string, string>
local function add_theme_overrides(theme)
  local res, seen = {}, {}
  local list = vim.list_extend(theme[vim.g.colors_name] or {}, theme['*'] or {})
  for _, hl in ipairs(list) do
    local n = next(hl)
    if not seen[n] then res[#res + 1] = hl end
    seen[n] = true
  end
  return res
end
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@param opts table<string, table> map of highlights
function as.highlight.plugin(name, opts)
  -- Options can be specified by theme name so check if they have been or there is a general
  -- definition otherwise use the opts as is
  if opts.theme then
    opts = add_theme_overrides(opts.theme)
    if not next(opts) then return end
  end
  -- capitalise the name for autocommand convention sake
  name = name:gsub('^%l', string.upper)
  as.highlight.all(opts)
  as.augroup(fmt('%sHighlightOverrides', name), {
    {
      event = 'ColorScheme',
      command = function()
        -- Defer resetting these highlights to ensure they apply after other overrides
        vim.defer_fn(function() as.highlight.all(opts) end, 1)
      end,
    },
  })
end
