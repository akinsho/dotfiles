local api, notify, fmt, augroup = vim.api, vim.notify, string.format, as.augroup

---@alias HLAttrs {from: string, attr: "fg" | "bg", alter: integer}

---@class HLData
---@field fg string
---@field bg string
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdotted boolean
---@field underdashed boolean
---@field underdouble boolean
---@field strikethrough boolean
---@field reverse boolean
---@field nocombine boolean
---@field link string
---@field default boolean

---@class HLArgs
---@field blend integer?
---@field fg (string | HLAttrs)?
---@field bg (string | HLAttrs)?
---@field sp (string | HLAttrs)?
---@field bold boolean?
---@field italic boolean?
---@field undercurl boolean?
---@field underline boolean?
---@field underdotted boolean?
---@field underdashed boolean?
---@field underdouble boolean?
---@field strikethrough boolean?
---@field reverse boolean?
---@field nocombine boolean?
---@field link string?
---@field default boolean?
---@field clear boolean?
---@field inherit string?

local attrs = {
  fg = true,
  bg = true,
  sp = true,
  blend = true,
  bold = true,
  italic = true,
  standout = true,
  underline = true,
  undercurl = true,
  underdouble = true,
  underdotted = true,
  underdashed = true,
  strikethrough = true,
  reverse = true,
  nocombine = true,
  link = true,
  default = true,
}

---@private
---@param opts {name: string?, link: boolean?}?
---@param ns integer?
---@return HLData
local function get_hl_as_hex(opts, ns)
  ns, opts = ns or 0, opts or {}
  opts.link = opts.link ~= nil and opts.link or false
  local hl = api.nvim_get_hl(ns, opts)
  hl.fg = hl.fg and ('#%06x'):format(hl.fg)
  hl.bg = hl.bg and ('#%06x'):format(hl.bg)
  return hl
end

--- Change the brightness of a color, negative numbers darken and positive ones brighten
---see:
--- 1. https://stackoverflow.com/q/5560248
--- 2. https://stackoverflow.com/a/37797380
---@param color string A hex color
---@param percent float a negative number darkens and a positive one brightens
---@return string
local function tint(color, percent)
  assert(color and percent, 'cannot alter a color without specifying a color and percentage')
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6), 16)
  if not r or not g or not b then return 'NONE' end
  local blend = function(component)
    component = math.floor(component * (1 + percent))
    return math.min(math.max(component, 0), 255)
  end
  return fmt('#%02x%02x%02x', blend(r), blend(g), blend(b))
end

local err_warn = vim.schedule_wrap(function(group, attribute)
  notify(fmt('failed to get highlight %s for attribute %s\n%s', group, attribute, debug.traceback()), 'ERROR', {
    title = fmt('Highlight - get(%s)', group),
  }) -- stylua: ignore
end)

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param group string
---@param attribute string?
---@param fallback string?
---@return string
---@overload fun(group: string): HLData
local function get(group, attribute, fallback)
  assert(group, 'cannot get a highlight without specifying a group name')
  local data = get_hl_as_hex({ name = group })
  if not attribute then return data end

  assert(attrs[attribute], ('the attribute passed in is invalid: %s'):format(attribute))
  local color = data[attribute] or fallback
  if not color then
    if vim.v.vim_did_enter == 0 then
      api.nvim_create_autocmd('User', {
        pattern = 'LazyDone',
        once = true,
        callback = function() err_warn(group, attribute) end,
      })
    else
      vim.schedule(function() err_warn(group, attribute) end)
    end
    return 'NONE'
  end
  return color
end

---@param hl string | HLAttrs
---@param attr string
---@return HLData
local function resolve_from_attribute(hl, attr)
  if type(hl) ~= 'table' or not hl.from then return hl end
  local colour = get(hl.from, hl.attr or attr)
  if hl.alter then colour = tint(colour, hl.alter) end
  return colour
end

--- Sets a neovim highlight with some syntactic sugar. It takes a highlight table and converts
--- any highlights specified as `GroupName = {fg = { from = 'group'}}` into the underlying colour
--- by querying the highlight property of the from group so it can be used when specifying highlights
--- as a shorthand to derive the right colour.
--- For example:
--- ```lua
---   M.set({ MatchParen = {fg = {from = 'ErrorMsg'}}})
--- ```
--- This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
--- NOTE: this function must NOT mutate the options table as these are re-used when the colorscheme is updated
---
---@param name string
---@param opts HLArgs
---@overload fun(ns: integer, name: string, opts: HLArgs)
local function set(ns, name, opts)
  if type(ns) == 'string' and type(name) == 'table' then
    opts, name, ns = name, ns, 0
  end

  vim.validate({ opts = { opts, 'table' }, name = { name, 'string' }, ns = { ns, 'number' } })

  local hl = opts.clear and {} or get_hl_as_hex({ name = opts.inherit or name })
  for attribute, hl_data in pairs(opts) do
    local new_data = resolve_from_attribute(hl_data, attribute)
    if attrs[attribute] then hl[attribute] = new_data end
  end

  as.pcall(fmt('setting highlight "%s"', name), api.nvim_set_hl, ns, name, hl)
end

---Apply a list of highlights
---@param hls {[string]: HLArgs}[]
---@param namespace integer?
local function all(hls, namespace)
  vim.iter(hls):each(function(hl) set(namespace or 0, next(hl)) end)
end

--- Set window local highlights
---@param name string
---@param win_id number
---@param hls HLArgs[]
local function set_winhl(name, win_id, hls)
  local namespace = api.nvim_create_namespace(name)
  all(hls, namespace)
  api.nvim_win_set_hl_ns(win_id, namespace)
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
--- Takes the overrides for each theme and merges the lists, avoiding duplicates and ensuring
--- priority is given to specific themes rather than the fallback
---@param theme {  [string]: HLArgs[] }
---@return HLArgs[]
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
---@param opts HLArgs[] | { theme: table<string, HLArgs[]> }
local function plugin(name, opts)
  -- Options can be specified by theme name so check if they have been or there is a general
  -- definition otherwise use the opts as is
  if opts.theme then
    opts = add_theme_overrides(opts.theme)
    if not next(opts) then return end
  end
  vim.schedule(function() all(opts) end)
  augroup(fmt('%sHighlightOverrides', name:gsub('^%l', string.upper)), {
    event = 'ColorScheme',
    command = function()
      vim.schedule(function() all(opts) end)
    end,
  })
end

as.highlight = {
  get = get,
  set = set,
  all = all,
  tint = tint,
  plugin = plugin,
  set_winhl = set_winhl,
}
