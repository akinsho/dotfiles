local fmt = string.format
local fn = vim.fn
local api = vim.api
local P = as.style.palette
local L = as.style.lsp.colors

local M = {}

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
function M.get(group, attribute, fallback)
  assert(group, 'cannot get a highlight without specifying a group name')
  local data = get_highlight(group)
  if not attribute then return data end
  local attr = ({ fg = 'foreground', bg = 'background' })[attribute] or attribute
  local color = data[attr] or fallback
  if color then return color end
  local msg = fmt("%s's %s does not exist", group, attr)
  vim.schedule(function() vim.notify(msg, 'error') end)
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
---@param name string
---@param opts HighlightKeys
function M.set(name, opts)
  assert(name and opts, "Both 'name' and 'opts' must be specified")
  assert(type(name) == 'string', fmt("Name must be a string but got '%s'", name))
  assert(type(opts) == 'table', fmt("Opts must be a table but got '%s'", vim.inspect(opts)))

  local hl = get_highlight(opts.inherit or name)
  opts.inherit = nil

  for attr, value in pairs(opts) do
    if type(value) == 'table' and value.from then
      opts[attr] = M.get(value.from, value.attr or attr)
      if value.alter then opts[attr] = M.alter_color(opts[attr], value.alter) end
    end
  end

  local ok, msg = pcall(api.nvim_set_hl, 0, name, vim.tbl_extend('force', hl, opts))
  if not ok then vim.notify(fmt('Failed to set %s because - %s', name, msg)) end
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
--- @return boolean, string
function M.has_win_highlight(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  for _, target in ipairs({ ... }) do
    if win_hl:match(target) ~= nil then return true, win_hl end
  end
  return false, win_hl
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id integer
---@param target string
---@param name string
---@param fallback string
function M.adopt_win_highlight(win_id, target, name, fallback)
  local win_hl_name = name .. win_id
  local _, win_hl = M.has_win_highlight(win_id, target)
  local hl_exists = fn.hlexists(win_hl_name) > 0
  if hl_exists then return win_hl_name end
  local parts = vim.split(win_hl, ',')
  local found = as.find(parts, function(part) return part:match(target) end)
  if not found then return fallback end
  local hl_group = vim.split(found, ':')[2]
  local bg = M.get(hl_group, 'bg')
  M.set(win_hl_name, { background = bg, inherit = fallback })
  return win_hl_name
end

function M.clear(name)
  assert(name, 'name is required to clear a highlight')
  api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, HighlightKeys>
function M.all(hls)
  as.foreach(function(hl) M.set(next(hl)) end, hls)
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@param opts table<string, table> map of highlights
function M.plugin(name, opts)
  -- Options can be specified by theme name so check if they have been or there is a general
  -- definition otherwise use the opts as is
  local theme = opts.theme
  if theme then
    local res, seen = {}, {}
    for _, hl in ipairs(vim.list_extend(theme[vim.g.colors_name] or {}, theme['*'] or {})) do
      local n = next(hl)
      if not seen[n] then res[#res + 1] = hl end
      seen[n] = true
    end
    opts = res
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
    { VertSplit = { background = 'NONE', foreground = { from = 'NonText' } } },
    { WinSeparator = { background = 'NONE', foreground = { from = 'NonText' } } },
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
    { TSError = { undercurl = true, sp = 'DarkRed', foreground = 'NONE' } },
    -- FIXME: this should be removed once
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3213 is resolved
    { yamlTSError = { link = 'None' } },
    -- highlight FIXME comments
    { commentTSWarning = { background = P.teal, foreground = 'bg', bold = true } },
    { commentTSDanger = { background = L.hint, foreground = 'bg', bold = true } },
    { commentTSNote = { background = P.dark_green, foreground = 'bg', bold = true } },
    { CommentTasksTodo = { link = 'commentTSWarning' } },
    { CommentTasksFixme = { link = 'commentTSDanger' } },
    { CommentTasksNote = { link = 'commentTSNote' } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    { LspCodeLens = { inherit = 'Comment', bold = true, italic = false } },
    {
      LspReferenceText = {
        underline = false,
        background = '#2D2F3B',
      },
    },
    {
      LspReferenceRead = {
        underline = false,
        background = '#2D2F3B',
      },
    },
    -- This represents when a reference is assigned which is more interesting than regular
    -- occurrences so should be highlighted more distinctly
    {
      LspReferenceWrite = {
        bold = true,
        italic = true,
        background = '#2D2F3B',
      },
    },
    { DiagnosticHint = { foreground = L.hint } },
    { DiagnosticError = { foreground = L.error } },
    { DiagnosticWarning = { foreground = L.warn } },
    { DiagnosticInfo = { foreground = L.info } },
    { DiagnosticUnderlineError = { undercurl = true, sp = L.error, foreground = 'none' } },
    { DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, foreground = 'none' } },
    { DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, foreground = 'none' } },
    { DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, foreground = 'none' } },
    {
      DiagnosticVirtualTextInfo = {
        background = { from = 'DiagnosticInfo', attr = 'fg', alter = -70 },
      },
    },
    {
      DiagnosticVirtualTextHint = {
        background = { from = 'DiagnosticHint', attr = 'fg', alter = -70 },
      },
    },
    {
      DiagnosticVirtualTextError = {
        background = { from = 'DiagnosticError', attr = 'fg', alter = -80 },
      },
    },
    {
      DiagnosticVirtualTextWarn = {
        background = { from = 'DiagnosticWarn', attr = 'fg', alter = -80 },
      },
    },
    { DiagnosticSignWarn = { link = 'DiagnosticWarn' } },
    { DiagnosticSignInfo = { link = 'DiagnosticInfo' } },
    { DiagnosticSignHint = { link = 'DiagnosticHint' } },
    { DiagnosticSignError = { link = 'DiagnosticError' } },
    { DiagnosticSignWarnLine = { inherit = 'DiagnosticWarn', bg = { from = 'CursorLine' } } },
    { DiagnosticSignInfoLine = { inherit = 'DiagnosticInfo', bg = { from = 'CursorLine' } } },
    { DiagnosticSignHintLine = { inherit = 'DiagnosticHint', bg = { from = 'CursorLine' } } },
    { DiagnosticSignErrorLine = { inherit = 'DiagnosticError', bg = { from = 'CursorLine' } } },
    { DiagnosticFloatingWarn = { link = 'DiagnosticWarn' } },
    { DiagnosticFloatingInfo = { link = 'DiagnosticInfo' } },
    { DiagnosticFloatingHint = { link = 'DiagnosticHint' } },
    { DiagnosticFloatingError = { link = 'DiagnosticError' } },
  })
end

local function set_sidebar_highlight()
  M.all({
    { PanelDarkBackground = { bg = { from = 'Normal', alter = -43 } } },
    { PanelDarkHeading = { inherit = 'PanelDarkBackground', bold = true } },
    { PanelBackground = { background = { from = 'Normal', alter = -8 } } },
    { PanelHeading = { inherit = 'PanelBackground', bold = true } },
    {
      PanelWinSeparator = { inherit = 'PanelBackground', foreground = { from = 'WinSeparator' } },
    },
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
  vim.wo.winhighlight = table.concat({
    'Normal:PanelBackground',
    'EndOfBuffer:PanelBackground',
    'StatusLine:PanelSt',
    'StatusLineNC:PanelStNC',
    'SignColumn:PanelBackground',
    'VertSplit:PanelVertSplit',
    'WinSeparator:PanelWinSeparator',
  }, ',')
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
      { Normal = { fg = '#C1C1C1' } }, -- TODO: Upstream normal foreground color
      { Constant = { bold = true } },
      { WinSeparator = { foreground = '#4b4c53' } },
      { NonText = { fg = { from = 'Comment' } } },
      { LineNr = { background = 'NONE' } },
      { TabLineSel = { foreground = { from = 'SpecialKey' } } },
      { commentTSConstant = { inherit = 'Constant', bold = true } },
      { luaTSConstructor = { inherit = 'Type', italic = false, bold = false } },
      { PanelBackground = { link = 'Normal' } },
      { PanelDarkBackground = { background = { from = 'Normal', alter = -20 } } },
      { PanelHeading = { inherit = 'Normal', bold = true } },
      {
        PanelWinSeparator = { inherit = 'PanelBackground', foreground = { from = 'WinSeparator' } },
      },
      -- TODO: set ColorColumn instead as this normally links to that
      { Headline = { background = { from = 'Normal', alter = 20 } } },
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
local ok, msg = pcall(vim.cmd.colorscheme, 'horizon')
if not ok then
  vim.schedule(function() vim.notify(fmt('Theme failed to load because: %s', msg), 'error') end)
end

return M
