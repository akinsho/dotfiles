local fmt = string.format
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

local function alter(attr, percent)
  return math.floor(attr * (100 + percent) / 100)
end

---@source https://stackoverflow.com/q/5560248
---@see: https://stackoverflow.com/a/37797380
---Darken a specified hex color
---@param color string
---@param percent number
---@return string
function M.alter_color(color, percent)
  local r, g, b = hex_to_rgb(color)
  if not r or not g or not b then
    return 'NONE'
  end
  r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
  r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
  return fmt('#%02x%02x%02x', r, g, b)
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
function M.has_win_highlight(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  for _, target in ipairs { ... } do
    if win_hl:match(target) ~= nil then
      return true, win_hl
    end
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
---@param win_id number
---@param target string
---@param name string
---@param default string
function M.adopt_winhighlight(win_id, target, name, default)
  name = name .. win_id
  local _, win_hl = M.has_win_highlight(win_id, target)
  local hl_exists = vim.fn.hlexists(name) > 0
  if not hl_exists then
    local parts = vim.split(win_hl, ',')
    local found = as.find(parts, function(part)
      return part:match(target)
    end)
    if found then
      local hl_group = vim.split(found, ':')[2]
      local bg = M.get_hl(hl_group, 'bg')
      M.set_hl(name, { background = bg, inherit = default })
    end
  end
  return name
end

---@param name string
---@param opts table
function M.set_hl(name, opts)
  assert(name and opts, "Both 'name' and 'opts' must be specified")
  local hl = get_hl(opts.inherit or name)
  opts.inherit = nil
  local ok, msg = pcall(api.nvim_set_hl, 0, name, vim.tbl_deep_extend('force', hl, opts))
  if not ok then
    vim.notify(fmt('Failed to set %s because: %s', name, msg))
  end
end

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---in the right format
---@param grp string
---@param attr string
---@param fallback string
---@return string
function M.get_hl(grp, attr, fallback)
  if not grp then
    vim.notify('Cannot get a highlight without specifying a group', levels.ERROR)
    return 'NONE'
  end
  local hl = get_hl(grp)
  attr = ({ fg = 'foreground', bg = 'background' })[attr] or attr
  local color = hl[attr] or fallback
  if not color then
    vim.schedule(function()
      vim.notify(fmt('%s %s does not exist', grp, attr), levels.INFO)
    end)
    return 'NONE'
  end
  -- convert the decimal RGBA value from the hl by name to a 6 character hex + padding if needed
  return color
end

function M.clear_hl(name)
  if not name then
    return
  end
  vim.cmd(fmt('highlight clear %s', name))
end

---Apply a list of highlights
---@param hls table[]
function M.all(hls)
  for _, hl in ipairs(hls) do
    M.set_hl(unpack(hl))
  end
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@vararg table list of highlights
function M.plugin(name, ...)
  name = name:gsub('^%l', string.upper) -- capitalise the name for autocommand convention sake
  local hls = { ... }
  M.all(hls)
  as.augroup(fmt('%sHighlightOverrides', name), {
    {
      event = 'ColorScheme',
      command = function()
        M.all(hls)
      end,
    },
  })
end

local function general_overrides()
  local comment_fg = M.get_hl('Comment', 'fg')
  local keyword_fg = M.get_hl('Keyword', 'fg')
  local search_bg = M.get_hl('Search', 'bg')
  local msg_area_bg = M.alter_color(M.get_hl('Normal', 'bg'), -10)
  local hint_line = M.alter_color(L.hint, -80)
  local error_line = M.alter_color(L.error, -80)
  local warn_line = M.alter_color(L.warn, -80)
  M.all {
    { 'mkdLineBreak', { link = 'NONE' } },
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    { 'MsgArea', { background = msg_area_bg } },
    { 'MsgSeparator', { foreground = comment_fg, background = msg_area_bg } },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    { 'NormalFloat', { link = 'Normal' } },
    --- Highlight group for light coloured floats
    { 'GreyFloat', { background = P.grey } },
    { 'GreyFloatBorder', { foreground = P.grey } },
    -----------------------------------------------------------------------------//
    { 'CursorLineNr', { bold = true } },
    { 'FoldColumn', { background = 'background' } },
    { 'Folded', { foreground = comment_fg, background = 'NONE', italic = true } },
    { 'TermCursor', { ctermfg = 'green', foreground = 'royalblue' } },
    {
      'IncSearch',
      {
        background = 'NONE',
        foreground = 'LightGreen',
        italic = true,
        bold = true,
        underline = true,
      },
    },
    -- Add undercurl to existing spellbad highlight
    { 'SpellBad', { undercurl = true, background = 'NONE', foreground = 'NONE', sp = 'green' } },
    { 'SpellRare', { undercurl = true } },
    { 'PmenuSbar', { background = P.grey } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    { 'DiffAdd', { background = '#26332c', foreground = 'NONE' } },
    { 'DiffDelete', { background = '#572E33', foreground = '#5c6370' } },
    { 'DiffChange', { background = '#273842', foreground = 'NONE' } },
    { 'DiffText', { background = '#314753', foreground = 'NONE' } },
    { 'diffAdded', { link = 'DiffAdd' } },
    { 'diffChanged', { link = 'DiffChange' } },
    { 'diffRemoved', { link = 'DiffDelete' } },
    { 'diffBDiffer', { link = 'WarningMsg' } },
    { 'diffCommon', { link = 'WarningMsg' } },
    { 'diffDiffer', { link = 'WarningMsg' } },
    { 'diffFile', { link = 'Directory' } },
    { 'diffIdentical', { link = 'WarningMsg' } },
    { 'diffIndexLine', { link = 'Number' } },
    { 'diffIsA', { link = 'WarningMsg' } },
    { 'diffNoEOL', { link = 'WarningMsg' } },
    { 'diffOnly', { link = 'WarningMsg' } },
    -----------------------------------------------------------------------------//
    -- colorscheme overrides
    -----------------------------------------------------------------------------//
    { 'Comment', { italic = true } },
    { 'Type', { italic = true, bold = true } },
    { 'Include', { italic = true, bold = false } },
    { 'Folded', { bold = true, italic = true } },
    { 'QuickFixLine', { background = search_bg } },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    { 'TSKeywordReturn', { italic = true, foreground = keyword_fg } },
    { 'TSParameter', { italic = true, bold = true, foreground = 'NONE' } },
    { 'TSError', { undercurl = true, sp = error_line, foreground = 'NONE' } },
    -- highlight FIXME comments
    { 'commentTSWarning', { background = P.light_red, foreground = 'fg', bold = true } },
    { 'commentTSDanger', { background = L.hint, foreground = '#1B2229', bold = true } },
    { 'commentTSNote', { background = L.info, foreground = '#1B2229', bold = true } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    -- avoid the urge to be "clever" and try and programmatically set these because
    -- 1. the name are slightly different (more than just the prefix) i.e. Warn -> Warning
    -- 2. Some plugins have not migrated so having both highlight groups is valuable
    { 'LspReferenceText', { underline = true } },
    { 'LspReferenceRead', { underline = true } },
    { 'DiagnosticHint', { foreground = L.hint } },
    { 'DiagnosticError', { foreground = L.error } },
    { 'DiagnosticWarning', { foreground = L.warn } },
    { 'DiagnosticInfo', { foreground = L.info } },
    { 'DiagnosticUnderlineError', { undercurl = true, sp = L.error, foreground = 'none' } },
    { 'DiagnosticUnderlineHint', { undercurl = true, sp = L.hint, foreground = 'none' } },
    { 'DiagnosticUnderlineWarn', { undercurl = true, sp = L.warn, foreground = 'none' } },
    { 'DiagnosticUnderlineInfo', { undercurl = true, sp = L.info, foreground = 'none' } },
    { 'DiagnosticSignHintLine', { background = hint_line } },
    { 'DiagnosticSignErrorLine', { background = error_line } },
    { 'DiagnosticSignWarnLine', { background = warn_line } },
    { 'DiagnosticSignWarn', { link = 'DiagnosticWarn' } },
    { 'DiagnosticSignInfo', { link = 'DiagnosticInfo' } },
    { 'DiagnosticSignHint', { link = 'DiagnosticHint' } },
    { 'DiagnosticSignError', { link = 'DiagnosticError' } },
    { 'DiagnosticFloatingWarn', { link = 'DiagnosticWarn' } },
    { 'DiagnosticFloatingInfo', { link = 'DiagnosticInfo' } },
    { 'DiagnosticFloatingHint', { link = 'DiagnosticHint' } },
    { 'DiagnosticFloatingError', { link = 'DiagnosticError' } },
  }
end

local function set_sidebar_highlight()
  local normal_bg = M.get_hl('Normal', 'bg')
  local split_color = M.get_hl('VertSplit', 'fg')
  local bg_color = M.alter_color(normal_bg, -8)
  local st_color = M.alter_color(M.get_hl('Visual', 'bg'), -20)
  local hls = {
    { 'PanelBackground', { background = bg_color } },
    { 'PanelHeading', { background = bg_color, bold = true } },
    { 'PanelVertSplit', { foreground = split_color, background = bg_color } },
    { 'PanelStNC', { background = bg_color, foreground = split_color } },
    { 'PanelSt', { background = st_color } },
  }
  for _, grp in ipairs(hls) do
    M.set_hl(unpack(grp))
  end
end

local sidebar_fts = {
  'packer',
  'dap-repl',
  'flutterToolsOutline',
  'undotree',
  'dapui_*',
}

local function on_sidebar_enter()
  vim.wo.winhighlight = table.concat({
    'Normal:PanelBackground',
    'EndOfBuffer:PanelBackground',
    'StatusLine:PanelSt',
    'StatusLineNC:PanelStNC',
    'SignColumn:PanelBackground',
    'VertSplit:PanelVertSplit',
  }, ',')
end

local function colorscheme_overrides()
  if vim.g.colors_name == 'doom-one' then
    local keyword_fg = M.get_hl('Keyword', 'fg')
    M.all {
      { 'CursorLineNr', { foreground = keyword_fg } },
      -- TODO: the default bold makes ... not use ligatures a better fix would be to add ligatures to my font
      -- {"Constant", {gui = "NONE"}},
    }
  elseif vim.g.colors_name == 'onedark' then
    local comment_fg = M.get_hl('Comment', 'fg')
    M.all {
      { 'Todo', { foreground = 'red', bold = true } },
      {
        'Substitute',
        { foreground = comment_fg, background = 'NONE', strikethrough = true, bold = true },
      },
      { 'LspDiagnosticsFloatingWarning', { background = 'NONE' } },
      { 'LspDiagnosticsFloatingError', { background = 'NONE' } },
      { 'LspDiagnosticsFloatingHint', { background = 'NONE' } },
      { 'LspDiagnosticsFloatingInformation', { background = 'NONE' } },
    }
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
    command = function()
      user_highlights()
    end,
  },
  {
    event = 'FileType',
    pattern = sidebar_fts,
    command = function()
      on_sidebar_enter()
    end,
  },
})

-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
if as.plugin_installed 'doom-one.nvim' then
  vim.cmd 'colorscheme doom-one'
end

return M
