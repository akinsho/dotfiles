local fmt = string.format
local api = vim.api
local P = as.style.palette
local L = as.style.lsp.colors

local M = {
  win_hl = {},
}

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
---@see: https://stackoverflow.com/a/37797380
---@param color string A hex color
---@param percent integer a negative number darkens and a positive one brightens
---@return string
function M.alter_color(color, percent)
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
---@return string
---@overload fun(group: string): NvimHighlightData
function M.get(group, attribute, fallback)
  assert(group, 'cannot get a highlight without specifying a group name')
  local data = get_highlight(group)
  if not attribute then return data end
  local attr = ({ fg = 'foreground', bg = 'background' })[attribute] or attribute
  local color = data[attr] or fallback
  if color then return color end
  vim.schedule(function() vim.notify(fmt("%s's %s does not exist", group, attr), 'error') end)
  return 'NONE'
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
---  NOTE: this function must NOT mutate the options table as these are re-used when the colorscheme
--- is updated
---@param name string
---@param opts HighlightKeys
---@overload fun(namespace: integer, name: string, opts: HighlightKeys)
function M.set(namespace, name, opts)
  if type(namespace) == 'string' and type(name) == 'table' then
    opts, name, namespace = name, namespace, 0
  end

  vim.validate({
    opts = { opts, 'table' },
    name = { name, 'string' },
    namespace = { namespace, 'number' },
  })

  local hl = get_highlight(opts.inherit or name)

  for attr, value in pairs(opts) do
    if type(value) == 'table' and value.from then
      hl[attr] = M.get(value.from, value.attr or attr)
      if value.alter then hl[attr] = M.alter_color(hl[attr], value.alter) end
    elseif attr ~= 'inherit' then
      hl[attr] = value
    end
  end

  as.wrap_err(fmt('failed to set %s because', name), api.nvim_set_hl, namespace, name, hl)
end

--- Set window local highlights
---@param name string
---@param win_id number
---@param hls HighlightKeys[]
function M.win_hl.set(name, win_id, hls)
  local namespace = api.nvim_create_namespace(name)
  M.all(hls, namespace)
  api.nvim_win_set_hl_ns(win_id, namespace)
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- FIXME: setting a window highlight with `nvim_win_set_hl_ns` will cause this check to fail as
--- a winhighlight is not set and the win namespace cannot be detected
--- @param win_id integer
--- @vararg string
--- @return boolean, string
function M.win_hl.exists(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  for _, target in ipairs({ ... }) do
    if win_hl:match(target) then return true, win_hl end
  end
  return false, win_hl
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id integer
---@param target string
---@param name string
---@param fallback string
function M.win_hl.adopt(win_id, target, name, fallback)
  local win_hl_name = name .. win_id
  local _, win_hl = M.win_hl.exists(win_id, target)

  if pcall(api.nvim_get_hl_by_name, win_hl_name, true) then return win_hl_name end

  local hl = as.find(function(part) return part:match(target) end, vim.split(win_hl, ','))
  if not hl then return fallback end

  local hl_group = vim.split(hl, ':')[2]
  M.set(win_hl_name, { inherit = fallback, background = { from = hl_group, attr = 'bg' } })
  return win_hl_name
end

function M.clear(name)
  assert(name, 'name is required to clear a highlight')
  api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, HighlightKeys>
---@param namespace integer?
function M.all(hls, namespace)
  as.foreach(function(hl) M.set(namespace or 0, next(hl)) end, hls)
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
function M.plugin(name, opts)
  -- Options can be specified by theme name so check if they have been or there is a general
  -- definition otherwise use the opts as is
  if opts.theme then
    opts = add_theme_overrides(opts.theme)
    if not next(opts) then return end
  end
  -- capitalise the name for autocommand convention sake
  name = name:gsub('^%l', string.upper)
  M.all(opts)
  as.augroup(fmt('%sHighlightOverrides', name), {
    {
      event = 'ColorScheme',
      command = function()
        -- Defer resetting these highlights to ensure they apply after other overrides
        vim.defer_fn(function() M.all(opts) end, 1)
      end,
    },
  })
end

local function general_overrides()
  M.all({
    { Dim = { foreground = { from = 'Normal', attr = 'bg', alter = 25 } } },
    { VertSplit = { fg = { from = 'Comment' } } },
    { WinSeparator = { fg = { from = 'Comment' } } },
    { mkdLineBreak = { link = 'NONE' } },
    { Directory = { inherit = 'Keyword', bold = true } },
    { URL = { inherit = 'Keyword', underline = true } },
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    { MsgArea = { background = { from = 'Normal', alter = -10 } } },
    { MsgSeparator = { link = 'MsgArea' } },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    { NormalFloat = { bg = { from = 'Normal', alter = -15 } } },
    { FloatBorder = { bg = { from = 'Normal', alter = -15 }, fg = { from = 'Comment' } } },
    { Pmenu = { link = 'NormalFloat' } },
    -----------------------------------------------------------------------------//
    { CodeBlock = { background = { from = 'Normal', alter = 30 } } },
    { markdownCode = { link = 'CodeBlock' } },
    { markdownCodeBlock = { link = 'CodeBlock' } },
    {
      CurSearch = {
        background = { from = 'String', attr = 'fg' },
        foreground = 'white',
        bold = true,
      },
    },
    { CursorLineNr = { inherit = 'CursorLine', bold = true } },
    { CursorLineSign = { link = 'CursorLine' } },
    { FoldColumn = { background = 'bg' } },
    { TermCursor = { ctermfg = 'green', foreground = 'royalblue' } },
    -- Add undercurl to existing spellbad highlight
    { SpellBad = { undercurl = true, background = 'NONE', foreground = 'NONE', sp = 'green' } },
    { SpellRare = { undercurl = true } },
    { PmenuSbar = { background = P.grey } },
    { PmenuThumb = { background = { from = 'Comment', attr = 'fg' } } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    { DiffAdd = { background = '#26332c', foreground = 'NONE', underline = false } },
    { DiffDelete = { background = '#572E33', foreground = '#5c6370', underline = false } },
    { DiffChange = { background = '#273842', foreground = 'NONE', underline = false } },
    { DiffText = { background = '#314753', foreground = 'NONE' } },
    { diffAdded = { link = 'DiffAdd' } },
    { diffChanged = { link = 'DiffChange' } },
    { diffRemoved = { link = 'DiffDelete' } },
    { diffBDiffer = { link = 'WarningMsg' } },
    { diffCommon = { link = 'WarningMsg' } },
    { diffDiffer = { link = 'WarningMsg' } },
    { diffFile = { link = 'Directory' } },
    { diffIdentical = { link = 'WarningMsg' } },
    { diffIndexLine = { link = 'Number' } },
    { diffIsA = { link = 'WarningMsg' } },
    { diffNoEOL = { link = 'WarningMsg' } },
    { diffOnly = { link = 'WarningMsg' } },
    -----------------------------------------------------------------------------//
    -- colorscheme overrides
    -----------------------------------------------------------------------------//
    { Comment = { italic = true } },
    { Type = { italic = true, bold = true } },
    { Include = { italic = true, bold = false } },
    { QuickFixLine = { inherit = 'PmenuSbar', foreground = 'NONE', italic = true } },
    -- Neither the sign column or end of buffer highlights require an explicit background
    -- they should both just use the background that is in the window they are in.
    -- if either are specified this can lead to issues when a winhighlight is set
    { SignColumn = { background = 'NONE' } },
    { EndOfBuffer = { background = 'NONE' } },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    { TSKeywordReturn = { italic = true, foreground = { from = 'Keyword' } } },
    { TSParameter = { italic = true, bold = true, foreground = 'NONE' } },
    { TSError = { foreground = 'fg', background = 'NONE' } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    { LspCodeLens = { inherit = 'Comment', bold = true, italic = false } },
    { LspCodeLensSeparator = { bold = false, italic = false } },
    {
      LspReferenceText = {
        underline = true,
        background = 'NONE',
        special = { from = 'Comment', attr = 'fg' },
      },
    },
    {
      LspReferenceRead = {
        underline = true,
        background = 'NONE',
        special = { from = 'Comment', attr = 'fg' },
      },
    },
    -- This represents when a reference is assigned which is more interesting than regular
    -- occurrences so should be highlighted more distinctly
    {
      LspReferenceWrite = {
        bold = true,
        italic = true,
        background = 'NONE',
        underline = true,
        special = { from = 'Comment', attr = 'fg' },
      },
    },
    -- Base colours
    { DiagnosticHint = { foreground = L.hint } },
    { DiagnosticError = { foreground = L.error } },
    { DiagnosticWarning = { foreground = L.warn } },
    { DiagnosticInfo = { foreground = L.info } },
    -- Underline
    { DiagnosticUnderlineError = { undercurl = true, sp = L.error, foreground = 'none' } },
    { DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, foreground = 'none' } },
    { DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, foreground = 'none' } },
    { DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, foreground = 'none' } },
    -- Virtual Text
    { DiagnosticVirtualTextInfo = { bg = { from = 'DiagnosticInfo', attr = 'fg', alter = -70 } } },
    { DiagnosticVirtualTextHint = { bg = { from = 'DiagnosticHint', attr = 'fg', alter = -70 } } },
    { DiagnosticVirtualTextWarn = { bg = { from = 'DiagnosticWarn', attr = 'fg', alter = -80 } } },
    {
      DiagnosticVirtualTextError = { bg = { from = 'DiagnosticError', attr = 'fg', alter = -80 } },
    },
    -- Sign column line
    { DiagnosticSignInfoLine = { inherit = 'DiagnosticVirtualTextInfo', fg = 'NONE' } },
    { DiagnosticSignHintLine = { inherit = 'DiagnosticVirtualTextHint', fg = 'NONE' } },
    { DiagnosticSignErrorLine = { inherit = 'DiagnosticVirtualTextError', fg = 'NONE' } },
    { DiagnosticSignWarnLine = { inherit = 'DiagnosticVirtualTextWarn', fg = 'NONE' } },
    -- Sign column signs
    {
      DiagnosticSignWarn = {
        bg = { from = 'DiagnosticVirtualTextWarn' },
        fg = { from = 'DiagnosticWarn' },
      },
    },
    {
      DiagnosticSignInfo = {
        bg = { from = 'DiagnosticVirtualTextInfo' },
        fg = { from = 'DiagnosticInfo' },
      },
    },
    {
      DiagnosticSignHint = {
        bg = { from = 'DiagnosticVirtualTextHint' },
        fg = { from = 'DiagnosticHint' },
      },
    },
    {
      DiagnosticSignError = {
        bg = { from = 'DiagnosticVirtualTextError' },
        fg = { from = 'DiagnosticError' },
      },
    },
    -- Sign column line number
    { DiagnosticSignWarnNr = { link = 'DiagnosticSignWarn' } },
    { DiagnosticSignInfoNr = { link = 'DiagnosticSignInfo' } },
    { DiagnosticSignHintNr = { link = 'DiagnosticSignHint' } },
    { DiagnosticSignErrorNr = { link = 'DiagnosticSignError' } },
    -- Sign column cursor line number
    { DiagnosticSignWarnCursorNr = { inherit = 'DiagnosticSignWarn', bold = true } },
    { DiagnosticSignInfoCursorNr = { inherit = 'DiagnosticSignInfo', bold = true } },
    { DiagnosticSignHintCursorNr = { inherit = 'DiagnosticSignHint', bold = true } },
    { DiagnosticSignErrorCursorNr = { inherit = 'DiagnosticSignError', bold = true } },
    -- Floating windows
    { DiagnosticFloatingWarn = { link = 'DiagnosticWarn' } },
    { DiagnosticFloatingInfo = { link = 'DiagnosticInfo' } },
    { DiagnosticFloatingHint = { link = 'DiagnosticHint' } },
    { DiagnosticFloatingError = { link = 'DiagnosticError' } },
  })
end

local function set_sidebar_highlight()
  M.all({
    { PanelDarkBackground = { bg = { from = 'Normal', alter = -42 } } },
    { PanelDarkHeading = { inherit = 'PanelDarkBackground', bold = true } },
    { PanelBackground = { background = { from = 'Normal', alter = -8 } } },
    { PanelHeading = { inherit = 'PanelBackground', bold = true } },
    { PanelWinSeparator = { inherit = 'PanelBackground', fg = { from = 'WinSeparator' } } },
    { PanelStNC = { link = 'PanelWinSeparator' } },
    { PanelSt = { background = { from = 'Visual', alter = -20 } } },
  })
end

local sidebar_fts = {
  'packer',
  'flutterToolsOutline',
  'undotree',
  'Outline',
  'dbui',
  'neotest-summary',
  'pr',
}

local function on_sidebar_enter()
  vim.opt_local.winhighlight:append({
    Normal = 'PanelBackground',
    EndOfBuffer = 'PanelBackground',
    StatusLine = 'PanelSt',
    StatusLineNC = 'PanelStNC',
    SignColumn = 'PanelBackground',
    VertSplit = 'PanelVertSplit',
    WinSeparator = 'PanelWinSeparator',
  })
end

local function colorscheme_overrides()
  local overrides = {
    ['doom-one'] = {
      { TSNamespace = { foreground = P.blue } },
      { TSVariable = { foreground = { from = 'Normal' } } },
      { CursorLineNr = { foreground = { from = 'Keyword' } } },
      { LineNr = { background = 'NONE' } },
      { NeoTreeIndentMarker = { link = 'Comment' } },
      { NeoTreeRootName = { bold = true, italic = true, foreground = 'LightMagenta' } },
    },
    ['horizon'] = {
      -----------------------------------------------------------------------------------------------
      --- TODO: upstream these highlights to horizon.nvim
      -----------------------------------------------------------------------------------------------
      { Normal = { fg = '#C1C1C1' } },
      -----------------------------------------------------------------------------------------------
      { NormalNC = { inherit = 'Normal' } },
      { WinSeparator = { fg = '#353647' } },
      { Constant = { bold = true } },
      { NonText = { fg = { from = 'Comment' } } },
      { LineNr = { background = 'NONE' } },
      { TabLineSel = { background = { from = 'SpecialKey', attr = 'fg' } } },
      { VisibleTab = { background = { from = 'Normal', alter = 40 }, bold = true } },
      { commentTSConstant = { inherit = 'Constant', bold = true } },
      { luaTSConstructor = { inherit = 'Type', italic = false, bold = false } },
      { PanelBackground = { link = 'Normal' } },
      { PanelWinSeparator = { inherit = 'PanelBackground', fg = { from = 'WinSeparator' } } },
      { PanelHeading = { bg = 'bg', bold = true, fg = { from = 'Normal', alter = -30 } } },
      { PanelDarkBackground = { background = { from = 'Normal', alter = -25 } } },
      { PanelDarkHeading = { inherit = 'PanelDarkBackground', bold = true } },
    },
  }
  local hls = overrides[vim.g.colors_name]
  if not hls then return end

  M.all(hls)
end

local function user_highlights()
  general_overrides()
  set_sidebar_highlight()
  colorscheme_overrides()
end

as.augroup('UserHighlights', {
  {
    event = 'ColorScheme',
    command = function() user_highlights() end,
  },
  {
    event = 'FileType',
    pattern = sidebar_fts,
    command = function() on_sidebar_enter() end,
  },
})

-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
as.wrap_err('theme failed to load because', vim.cmd.colorscheme, 'horizon')

return M
