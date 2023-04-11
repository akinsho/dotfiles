if not as then return end
local P = as.ui.palette
local L = as.ui.lsp.colors
local highlight = as.highlight

local function general_overrides()
  highlight.all({
    { Dim = { fg = { from = 'Normal', attr = 'bg', alter = 0.25 } } },
    { VertSplit = { fg = { from = 'Comment' } } },
    { WinSeparator = { fg = { from = 'Comment' } } },
    { mkdLineBreak = { clear = true } },
    { Directory = { inherit = 'Keyword', bold = true } },
    { URL = { inherit = 'Keyword', underline = true } },
    { ErrorMsg = { bg = 'NONE' } },
    { UnderlinedTitle = { bold = true, underline = true } },
    { PickerBorder = { fg = P.grey } },
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    { MsgArea = { bg = { from = 'Normal', alter = -0.1 } } },
    { MsgSeparator = { link = 'MsgArea' } },
    -----------------------------------------------------------------------------//
    -- Floats
    -----------------------------------------------------------------------------//
    { NormalFloat = { bg = { from = 'Normal', alter = -0.15 } } },
    { FloatBorder = { bg = { from = 'Normal', alter = -0.15 }, fg = { from = 'Comment' } } },
    { FloatTitle = { inherit = 'FloatBorder', bold = true, fg = 'white', bg = { from = 'FloatBorder', attr = 'fg' } } },
    { Pmenu = { link = 'NormalFloat' } },
    { PmenuSbar = { link = 'NormalFloat' } },
    -----------------------------------------------------------------------------//
    { CodeBlock = { bg = { from = 'Normal', alter = 0.3 } } },
    { markdownCode = { link = 'CodeBlock' } },
    { markdownCodeBlock = { link = 'CodeBlock' } },
    { CurSearch = { bg = { from = 'String', attr = 'fg' }, fg = 'white', bold = true } },
    { CursorLineNr = { inherit = 'CursorLine', bold = true } },
    { CursorLineSign = { link = 'CursorLine' } },
    { FoldColumn = { bg = 'bg' } },
    { TermCursor = { ctermfg = 'green', fg = 'royalblue' } },
    { SpellBad = { undercurl = true, bg = 'NONE', fg = 'NONE', sp = 'green' } },
    { SpellRare = { undercurl = true } },
    { PmenuSbar = { bg = P.grey } },
    { PmenuThumb = { bg = { from = 'Comment', attr = 'fg' } } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    { DiffAdd = { bg = '#26332c', fg = 'NONE', underline = false } },
    { DiffDelete = { bg = '#572E33', fg = '#5c6370', underline = false } },
    { DiffChange = { bg = '#273842', fg = 'NONE', underline = false } },
    { DiffText = { bg = '#314753', fg = 'NONE' } },
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
    { QuickFixLine = { inherit = 'PmenuSbar', fg = 'NONE', italic = true } },
    -- Neither the sign column or end of buffer highlights require an explicit bg
    -- they should both just use the bg that is in the window they are in.
    -- if either are specified this can lead to issues when a winhighlight is set
    { SignColumn = { bg = 'NONE' } },
    { EndOfBuffer = { bg = 'NONE' } },
    { StatusColSep = { fg = { from = 'WinSeparator' }, bg = { from = 'CursorLine' } } },
    ------------------------------------------------------------------------------//
    --  Semantic tokens
    ------------------------------------------------------------------------------//
    { ['@lsp.type.variable'] = { clear = true } },
    { ['@lsp.type.parameter'] = { italic = true, fg = { from = 'Normal' } } },
    { ['@lsp.typemod.variable.global'] = { bold = true, inherit = '@constant.builtin' } },
    { ['@lsp.typemod.variable.defaultLibrary'] = { italic = true } },
    { ['@lsp.typemod.variable.readonly.typescript'] = { clear = true } },
    { ['@lsp.type.type.lua'] = { clear = true } },
    { ['@lsp.typemod.number.injected'] = { link = '@number' } },
    { ['@lsp.typemod.operator.injected'] = { link = '@operator' } },
    { ['@lsp.typemod.keyword.injected'] = { link = '@keyword' } },
    { ['@lsp.typemod.string.injected'] = { link = '@string' } },
    { ['@lsp.typemod.variable.injected'] = { link = '@variable' } },
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    { ['@keyword.return'] = { italic = true, fg = { from = 'Keyword' } } },
    { ['@type.qualifier'] = { inherit = '@keyword', italic = true } },
    { ['@variable'] = { clear = true } },
    { ['@parameter'] = { italic = true, bold = true, fg = 'NONE' } },
    { ['@error'] = { fg = 'fg', bg = 'NONE' } },
    { ['@text.diff.add'] = { link = 'DiffAdd' } },
    { ['@text.diff.delete'] = { link = 'DiffDelete' } },
    { ['@text.title.markdown'] = { underdouble = true } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    { LspCodeLens = { inherit = 'Comment', bold = true, italic = false } },
    { LspCodeLensSeparator = { bold = false, italic = false } },
    { LspReferenceText = { bg = 'NONE', underline = true, sp = { from = 'Comment', attr = 'fg' } } },
    { LspReferenceRead = { link = 'LspReferenceText' } },
    { LspReferenceWrite = { inherit = 'LspReferenceText', bold = true, italic = true, underline = true } },
    { LspSignatureActiveParameter = { link = 'Visual' } },
    -- Base colours
    { DiagnosticHint = { fg = L.hint } },
    { DiagnosticError = { fg = L.error } },
    { DiagnosticWarning = { fg = L.warn } },
    { DiagnosticInfo = { fg = L.info } },
    -- Underline
    { DiagnosticUnderlineError = { undercurl = true, sp = L.error, fg = 'none' } },
    { DiagnosticUnderlineHint = { undercurl = true, sp = L.hint, fg = 'none' } },
    { DiagnosticUnderlineWarn = { undercurl = true, sp = L.warn, fg = 'none' } },
    { DiagnosticUnderlineInfo = { undercurl = true, sp = L.info, fg = 'none' } },
    -- Virtual Text
    { DiagnosticVirtualTextInfo = { bg = { from = 'DiagnosticInfo', attr = 'fg', alter = -0.7 } } },
    { DiagnosticVirtualTextHint = { bg = { from = 'DiagnosticHint', attr = 'fg', alter = -0.7 } } },
    { DiagnosticVirtualTextWarn = { bg = { from = 'DiagnosticWarn', attr = 'fg', alter = -0.8 } } },
    { DiagnosticVirtualTextError = { bg = { from = 'DiagnosticError', attr = 'fg', alter = -0.8 } } },
    -- Sign column line
    { DiagnosticSignInfoLine = { inherit = 'DiagnosticVirtualTextInfo', fg = 'NONE' } },
    { DiagnosticSignHintLine = { inherit = 'DiagnosticVirtualTextHint', fg = 'NONE' } },
    { DiagnosticSignErrorLine = { inherit = 'DiagnosticVirtualTextError', fg = 'NONE' } },
    { DiagnosticSignWarnLine = { inherit = 'DiagnosticVirtualTextWarn', fg = 'NONE' } },
    -- Sign column signs
    { DiagnosticSignInfo = { fg = { from = 'DiagnosticInfo' } } },
    { DiagnosticSignHint = { fg = { from = 'DiagnosticHint' } } },
    { DiagnosticSignWarn = { bg = { from = 'DiagnosticVirtualTextWarn' }, fg = { from = 'DiagnosticWarn' } } },
    { DiagnosticSignError = { bg = { from = 'DiagnosticVirtualTextError' }, fg = { from = 'DiagnosticError' } } },
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
    { DiagnosticFloatTitle = { inherit = 'FloatTitle', bold = true } },
    { DiagnosticFloatTitleIcon = { inherit = 'FloatTitle', fg = { from = '@character' } } },
  })
end

local function set_sidebar_highlight()
  highlight.all({
    { PanelDarkBackground = { bg = { from = 'Normal', alter = -0.42 } } },
    { PanelDarkHeading = { inherit = 'PanelDarkBackground', bold = true } },
    { PanelBackground = { bg = { from = 'Normal', alter = -0.8 } } },
    { PanelHeading = { inherit = 'PanelBackground', bold = true } },
    { PanelWinSeparator = { inherit = 'PanelBackground', fg = { from = 'WinSeparator' } } },
    { PanelStNC = { link = 'PanelWinSeparator' } },
    { PanelSt = { bg = { from = 'Visual', alter = -0.2 } } },
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
      { ['@namespace'] = { fg = P.blue } },
      { CursorLineNr = { fg = { from = 'Keyword' } } },
      { LineNr = { bg = 'NONE' } },
      { NeoTreeIndentMarker = { link = 'Comment' } },
      { NeoTreeRootName = { bold = true, italic = true, fg = 'LightMagenta' } },
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
      { PmenuSbar = { link = 'NormalFloat' } },
      { PmenuThumb = { bg = 'gray' } },
      { NonText = { fg = { from = 'Comment' } } },
      { LineNr = { bg = 'NONE' } },
      { TabLineSel = { bg = { from = 'SpecialKey', attr = 'fg' } } },
      { VisibleTab = { bg = { from = 'Normal', alter = 0.4 }, bold = true } },
      { ['@variable'] = { fg = { from = 'Normal' } } },
      { ['@constant.comment'] = { inherit = 'Constant', bold = true } },
      { ['@constructor.lua'] = { inherit = 'Type', italic = false, bold = false } },
      { ['@lsp.type.parameter'] = { fg = { from = 'Normal' } } },
      { PanelBackground = { link = 'Normal' } },
      { PanelWinSeparator = { inherit = 'PanelBackground', fg = { from = 'WinSeparator' } } },
      { PanelHeading = { bg = 'bg', bold = true, fg = { from = 'Normal', alter = -0.3 } } },
      { PanelDarkBackground = { bg = { from = 'Normal', alter = -0.25 } } },
      { PanelDarkHeading = { inherit = 'PanelDarkBackground', bold = true } },
    },
  }
  local hls = overrides[vim.g.colors_name]
  if not hls then return end
  highlight.all(hls)
end

local function user_highlights()
  general_overrides()
  set_sidebar_highlight()
  colorscheme_overrides()
end

as.augroup('UserHighlights', {
  event = 'ColorScheme',
  command = function() user_highlights() end,
}, {
  event = 'FileType',
  pattern = sidebar_fts,
  command = function() on_sidebar_enter() end,
})
