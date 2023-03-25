local api, notify, fmt = vim.api, vim.notify, string.format

as.highlight = {}

---@alias ErrorMsg {msg: string}

---@alias HLAttrs {from: string, attr: "fg" | "bg", alter: integer}

---@class HLData
---@field fg string
---@field bg string
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdot boolean

---@class HLArgs
---@field blend integer
---@field fg string | HLAttrs
---@field bg string | HLAttrs
---@field sp string | HLAttrs
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdot boolean
---@field clear boolean
---@field inherit string

local attrs = {
  fg = true,
  bg = true,
  sp = true,
  blend = true,
  bold = true,
  italic = true,
  undercurl = true,
  underline = true,
  underdot = true,
}
---Convert a hex color to RGB
---@param color string
---@return number, number, number
local function hex_to_rgb(color)
  local hex = color:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

local function alter(attr, percent) return math.floor(attr * (100 + percent) / 100) end

---see:
--- 1. https://stackoverflow.com/q/5560248
--- 2. https://stackoverflow.com/a/37797380
---@param color string A hex color
---@param percent integer a negative number darkens and a positive one brightens
---@return string
function as.highlight.alter_color(color, percent)
  assert(color, 'cannot alter a color without specifying a color')
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then return 'NONE' end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return fmt('#%02x%02x%02x', r, g, b)
end

---@param opts {name: string?, link: boolean?}?
---@param ns integer?
---@return HLData
local function get_highlight(opts, ns)
  ns, opts = ns or 0, opts or {}
  opts.link = opts.link or false
  local hl = api.nvim_get_hl(ns, opts)
  hl.fg = hl.fg and '#' .. bit.tohex(hl.fg, 6)
  hl.bg = hl.bg and '#' .. bit.tohex(hl.bg, 6)
  return hl
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param group string
---@param attribute string?
---@param fallback string?
---@return string, ErrorMsg?
---@overload fun(group: string): HLData, ErrorMsg?
function as.highlight.get(group, attribute, fallback)
  assert(group, 'cannot get a highlight without specifying a group name')
  local data = get_highlight({ name = group })
  if not attribute then return data end

  assert(attrs[attribute], ('the attribute passed in is invalid: %s'):format(attribute))
  local color = data[attribute] or fallback
  if not color then
    return 'NONE',
      {
        msg = ('failed to get highlight %s for attribute %s \n%s'):format(
          group,
          attribute,
          debug.traceback()
        ),
      }
  end
  return color
end

--- Sets a neovim highlight with some syntactic sugar. It takes a highlight table and converts
--- any highlights specified as `GroupName = { from = 'group'}` into the underlying colour
--- by querying the highlight property of the from group so it can be used when specifying highlights
--- as a shorthand to derive the right color.
--- For example:
--- ```lua
---   M.set({ MatchParen = {fg = {from = 'ErrorMsg'}}})
--- ```
--- This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
--- NOTE: this function must NOT mutate the options table as these are re-used when the colorscheme
--- is updated
---@param name string
---@param opts HLArgs
---@overload fun(namespace: integer, name: string, opts: HLArgs): ErrorMsg[]?
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

  local clear = opts.clear
  if clear then opts.clear = nil end

  local errs, hl = {}, {}
  if not clear then
    hl = get_highlight({ name = opts.inherit or name })
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
  end

  if not pcall(api.nvim_set_hl, namespace, name, hl) then
    table.insert(errs, {
      msg = fmt('failed to set highlight %s with values %s', name, vim.inspect(hl)),
    })
  end
  if #errs > 0 then return errs end
end

--- Set window local highlights
---@param name string
---@param win_id number
---@param hls HLArgs[]
function as.highlight.set_winhl(name, win_id, hls)
  local namespace = api.nvim_create_namespace(name)
  as.highlight.all(hls, namespace)
  api.nvim_win_set_hl_ns(win_id, namespace)
end

---Apply a list of highlights
---@param hls {[string]: HLArgs}[]
---@param namespace integer?
function as.highlight.all(hls, namespace)
  local errors = as.fold(function(errors, hl)
    local errs = as.highlight.set(namespace or 0, next(hl))
    if errs then vim.list_extend(errors, errs) end
    return errors
  end, hls)
  if #errors > 0 then
    vim.defer_fn(function()
      notify(as.fold(function(acc, err) return acc .. '\n' .. err.msg end, errors, ''), 'error')
    end, 1000)
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
    event = 'ColorScheme',
    command = function()
      -- Defer resetting these highlights to ensure they apply after other overrides
      vim.defer_fn(function() as.highlight.all(opts) end, 1)
    end,
  })
end
