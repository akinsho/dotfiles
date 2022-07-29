local fmt = string.format
local fn = vim.fn
local api = vim.api
local P = as.style.palette
local L = as.style.lsp.colors
local levels = vim.log.levels

local M = {}

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
---Darken a specified hex color
---@param color string
---@param percent number
---@return string
function M.alter_color(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then return 'NONE' end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return fmt('#%02x%02x%02x', r, g, b)
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
--- @return boolean, string
function M.winhighlight_exists(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  for _, target in ipairs({ ... }) do
    if win_hl:match(target) ~= nil then return true, win_hl end
  end
  return false, win_hl
end

---@param group_name string A highlight group name
local function get_hl(group_name)
  local ok, hl = pcall(api.nvim_get_hl_by_name, group_name, true)
  if ok then
    hl.foreground = hl.foreground and '#' .. bit.tohex(hl.foreground, 6)
    hl.background = hl.background and '#' .. bit.tohex(hl.background, 6)
    hl[true] = nil -- BUG: API returns a true key which errors during the merge
    return hl
  end
  return {}
end

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id integer
---@param target string
---@param name string
---@param fallback string
function M.adopt_winhighlight(win_id, target, name, fallback)
  local win_hl_name = name .. win_id
  local _, win_hl = M.winhighlight_exists(win_id, target)
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

---@class HLAttrs
---@field from string
---@field attr 'foreground' | 'fg' | 'background' | 'bg'

---This helper takes a table of highlights and converts any highlights
---specified as `highlight_prop = { from = 'group'}` into the underlying colour
---by querying the highlight property of the from group so it can be used when specifying highlights
---as a shorthand to derive the right color.
---For example:
---```lua
---  M.set({ MatchParen = {foreground = {from = 'ErrorMsg'}}})
---```
---This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
---@param opts table<string, string|boolean|HLAttrs>
local function convert_hl_to_val(opts)
  for name, value in pairs(opts) do
    if type(value) == 'table' and value.from then
      opts[name] = M.get(value.from, vim.F.if_nil(value.attr, name))
      if value.alter then opts[name] = M.alter_color(opts[name], value.alter) end
    end
  end
end

---@param name string
---@param opts table
function M.set(name, opts)
  assert(name and opts, "Both 'name' and 'opts' must be specified")
  local hl = get_hl(opts.inherit or name)
  convert_hl_to_val(opts)
  opts.inherit = nil
  local ok, msg = pcall(api.nvim_set_hl, 0, name, vim.tbl_deep_extend('force', hl, opts))
  if not ok then vim.notify(fmt('Failed to set %s because - %s', name, msg)) end
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param group string
---@param attribute string?
---@param fallback string?
---@return string
function M.get(group, attribute, fallback)
  if not group then
    vim.notify('Cannot get a highlight without specifying a group', levels.ERROR)
    return 'NONE'
  end
  local hl = get_hl(group)
  if not attribute then return hl end
  attribute = ({ fg = 'foreground', bg = 'background' })[attribute] or attribute
  local color = hl[attribute] or fallback
  if not color then
    vim.schedule(
      function() vim.notify(fmt('%s %s does not exist', group, attribute), levels.INFO) end
    )
    return 'NONE'
  end
  -- convert the decimal RGBA value from the hl by name to a 6 character hex + padding if needed
  return color
end

function M.clear_hl(name)
  assert(name, 'name is required to clear a highlight')
  api.nvim_set_hl(0, name, {})
end

---Apply a list of highlights
---@param hls table<string, table<string, boolean|string|HLAttrs>>
function M.all(hls)
  for name, hl in pairs(hls) do
    M.set(name, hl)
  end
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@param hls table<string, table> map of highlights
function M.plugin(name, hls)
  name = name:gsub('^%l', string.upper) -- capitalise the name for autocommand convention sake
  M.all(hls)
  as.augroup(fmt('%sHighlightOverrides', name), {
    {
      event = 'ColorScheme',
      command = function() M.all(hls) end,
    },
  })
end

local function general_overrides()
  local comment_fg = M.get('Comment', 'fg')
  local keyword_fg = M.get('Keyword', 'fg')
  local normal_bg = M.get('Normal', 'bg')
  local msg_area_bg = M.alter_color(normal_bg, -10)

  M.all({
    Dim = { foreground = { from = 'Normal', attr = 'bg', alter = 25 } },
    VertSplit = { background = 'NONE', foreground = { from = 'NonText' } },
    WinSeparator = { background = 'NONE', foreground = { from = 'NonText' } },
    mkdLineBreak = { link = 'NONE' },
    Directory = { inherit = 'Keyword', bold = true },
    URL = { inherit = 'Keyword', underline = true },
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    MsgArea = { background = msg_area_bg },
    MsgSeparator = { foreground = comment_fg, background = msg_area_bg },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    NormalFloat = { inherit = 'Pmenu' },
    FloatBorder = { inherit = 'NormalFloat', foreground = { from = 'NonText' } },
    CodeBlock = { background = { from = 'Normal', alter = 30 } },
    markdownCode = { link = 'CodeBlock' },
    markdownCodeBlock = { link = 'CodeBlock' },
    -----------------------------------------------------------------------------//
    CurSearch = {
      background = { from = 'String', attr = 'fg' },
      foreground = 'white',
      bold = true,
    },
    CursorLineNr = { bold = true },
    CursorLineSign = { link = 'CursorLine' },
    FoldColumn = { background = 'background' },
    TermCursor = { ctermfg = 'green', foreground = 'royalblue' },
    -- Add undercurl to existing spellbad highlight
    SpellBad = { undercurl = true, background = 'NONE', foreground = 'NONE', sp = 'green' },
    SpellRare = { undercurl = true },
    PmenuSbar = { background = P.grey },
    PmenuThumb = { background = { from = 'Comment', attr = 'fg' } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    DiffAdd = { background = '#26332c', foreground = 'NONE' },
    DiffDelete = { background = '#572E33', foreground = '#5c6370' },
    DiffChange = { background = '#273842', foreground = 'NONE' },
    DiffText = { background = '#314753', foreground = 'NONE' },
    diffAdded = { link = 'DiffAdd' },
    diffChanged = { link = 'DiffChange' },
    diffRemoved = { link = 'DiffDelete' },
    diffBDiffer = { link = 'WarningMsg' },
    diffCommon = { link = 'WarningMsg' },
    diffDiffer = { link = 'WarningMsg' },
    diffFile = { link = 'Directory' },
    diffIdentical = { link = 'WarningMsg' },
    diffIndexLine = { link = 'Number' },
    diffIsA = { link = 'WarningMsg' },
    diffNoEOL = { link = 'WarningMsg' },
    diffOnly = { link = 'WarningMsg' },
    -----------------------------------------------------------------------------//
    -- colorscheme overrides
    -----------------------------------------------------------------------------//
    Comment = { italic = true },
    Type = { italic = true, bold = true },
    Include = { italic = true, bold = false },
    QuickFixLine = { inherit = 'PmenuSbar', foreground = 'NONE', italic = true },
    -- Neither the sign column or end of buffer highlights require an explicit background
    -- they should both just use the background that is in the window they are in.
    -- if either are specified this can lead to issues when a winhighlight is set
    SignColumn = { background = 'NONE' },
    EndOfBuffer = { background = 'NONE' },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    TSNamespace = { foreground = P.blue },
    TSKeywordReturn = { italic = true, foreground = keyword_fg },
    TSParameter = { italic = true, bold = true, foreground = 'NONE' },
    TSError = { undercurl = true, sp = 'DarkRed', foreground = 'NONE' },
    -- FIXME: this should be removed once
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3213 is resolved
    yamlTSError = { link = 'None' },
    -- highlight FIXME comments
    commentTSWarning = { background = P.teal, foreground = 'bg', bold = true },
    commentTSDanger = { background = L.hint, foreground = 'bg', bold = true },
    commentTSNote = { background = P.dark_green, foreground = 'bg', bold = true },
    CommentTasksTodo = { link = 'commentTSWarning' },
    CommentTasksFixme = { link = 'commentTSDanger' },
    CommentTasksNote = { link = 'commentTSNote' },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    LspCodeLens = { link = 'NonText' },
    LspReferenceText = { underline = true, background = 'NONE', sp = P.comment_grey },
    LspReferenceRead = { underline = true, background = 'NONE', sp = P.comment_grey },
    -- This represents when a reference is assigned which is more interesting than regular
    -- occurrences so should be highlighted more distinctly
    LspReferenceWrite = {
      underline = true,
      bold = true,
      italic = true,
      background = 'NONE',
      sp = P.whitesmoke,
    },
    DiagnosticHint = { foreground = L.hint },
    DiagnosticError = { foreground = L.error },
    DiagnosticWarning = { foreground = L.warn },
    DiagnosticInfo = { foreground = L.info },
    DiagnosticUnderlineError = {
      underline = false,
      undercurl = true,
      sp = L.error,
      foreground = 'none',
    },
    DiagnosticUnderlineHint = {
      underline = false,
      undercurl = true,
      sp = L.hint,
      foreground = 'none',
    },
    DiagnosticUnderlineWarn = {
      underline = false,
      undercurl = true,
      sp = L.warn,
      foreground = 'none',
    },
    DiagnosticUnderlineInfo = {
      underline = false,
      undercurl = true,
      sp = L.info,
      foreground = 'none',
    },
    DiagnosticVirtualTextInfo = {
      background = { from = 'DiagnosticInfo', attr = 'fg', alter = -70 },
    },
    DiagnosticVirtualTextHint = {
      background = { from = 'DiagnosticHint', attr = 'fg', alter = -70 },
    },
    DiagnosticVirtualTextError = {
      background = { from = 'DiagnosticError', attr = 'fg', alter = -80 },
    },
    DiagnosticVirtualTextWarn = {
      background = { from = 'DiagnosticWarn', attr = 'fg', alter = -80 },
    },
    DiagnosticSignWarn = { link = 'DiagnosticWarn' },
    DiagnosticSignInfo = { link = 'DiagnosticInfo' },
    DiagnosticSignHint = { link = 'DiagnosticHint' },
    DiagnosticSignError = { link = 'DiagnosticError' },
    DiagnosticSignWarnLine = { inherit = 'DiagnosticWarn', bg = { from = 'CursorLine' } },
    DiagnosticSignInfoLine = { inherit = 'DiagnosticInfo', bg = { from = 'CursorLine' } },
    DiagnosticSignHintLine = { inherit = 'DiagnosticHint', bg = { from = 'CursorLine' } },
    DiagnosticSignErrorLine = { inherit = 'DiagnosticError', bg = { from = 'CursorLine' } },
    DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
    DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
    DiagnosticFloatingHint = { link = 'DiagnosticHint' },
    DiagnosticFloatingError = { link = 'DiagnosticError' },
  })
end

local function set_sidebar_highlight()
  local normal_bg = M.get('Normal', 'bg')
  local split_color = M.get('VertSplit', 'fg')
  local dark_bg = M.alter_color(normal_bg, -43)
  local bg_color = M.alter_color(normal_bg, -8)
  local st_color = M.alter_color(M.get('Visual', 'bg'), -20)
  M.all({
    PanelDarkBackground = { bg = dark_bg },
    PanelDarkHeading = { bg = dark_bg, bold = true },
    PanelBackground = { background = bg_color },
    PanelHeading = { background = bg_color, bold = true },
    PanelVertSplit = { foreground = split_color, background = bg_color },
    PanelWinSeparator = { foreground = split_color, background = bg_color },
    PanelStNC = { background = bg_color, foreground = split_color },
    PanelSt = { background = st_color },
  })
end

local sidebar_fts = {
  'packer',
  'flutterToolsOutline',
  'undotree',
  'neo-tree',
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
  if vim.g.colors_name == 'doom-one' then
    M.all({
      TSVariable = { foreground = { from = 'Normal' } },
      CursorLineNr = { foreground = { from = 'Keyword' } },
      LineNr = { background = 'NONE' },
      WhichkeyFloat = { link = 'NormalFloat' },
    })
  end
end

local function user_highlights()
  general_overrides()
  colorscheme_overrides()
  set_sidebar_highlight()
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
if as.plugin_installed('doom-one.nvim') then vim.cmd.colorscheme('doom-one') end

return M
