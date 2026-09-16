if not as then return end
local P = as.ui.palette
local highlight = as.highlight

--- `alter` scales each colour channel, so the same factor is not symmetric across
--- backgrounds: -0.8 barely shifts a near-black background but turns a near-white
--- one almost black, and any positive factor clamps a light background to white.
--- These magnitudes are therefore chosen per background. The light values aim at
--- solarized's own base2 (#eee8d5) for recessed surfaces and base1 (#93a1a1) for
--- de-emphasised text.
---@return {cursorline: number, dim: number, float: number, panel: number, panel_dark: number, fold: number, code: number}
local function shades()
  if vim.o.background == 'light' then
    return {
      cursorline = -0.06,
      dim = -0.15,
      float = -0.08,
      panel = -0.06,
      panel_dark = -0.12,
      -- Positive, because `fold` shifts a foreground and de-emphasising text means
      -- moving it toward the background: lighter here, darker on a dark background.
      fold = 0.45,
      code = -0.06,
    }
  end
  local contrast = vim.g.high_contrast_theme and 0.75 or 0.25
  return {
    cursorline = contrast,
    dim = contrast,
    float = -0.15,
    panel = -0.8,
    panel_dark = -0.42,
    fold = -0.8,
    code = 0.3,
  }
end

local function general_overrides()
  local shade = shades()
  highlight.all({
    -----------------------------------------------------------------------------//
    -- Native
    -----------------------------------------------------------------------------//
    { VertSplit = { fg = { from = 'Comment' } } },
    { WinSeparator = { fg = { from = 'Comment' } } },
    { CursorLine = { bg = { from = 'Normal', alter = shade.cursorline } } },
    { CursorLineNr = { bg = 'NONE' } },
    { iCursor = { bg = P.dark_blue } },
    { PmenuSbar = { link = 'Normal' } },
    { Folded = { bg = 'NONE', fg = { from = 'Normal', alter = shade.fold } } },
    --------------------------------------------//
    -- Floats
    ---------------------------------------------//
    { NormalFloat = { bg = { from = 'Normal', alter = shade.float } } },
    { FloatBorder = { bg = { from = 'NormalFloat' }, fg = { from = 'Comment' } } },
    { FloatTitle = { bold = true, fg = 'white', bg = { from = 'Comment', attr = 'fg' } } },
    -----------------------------------------------------------------------------//
    -- Created highlights
    -----------------------------------------------------------------------------//
    { Dim = { fg = { from = 'Normal', attr = 'bg', alter = shade.dim } } },
    { PickerBorder = { fg = P.grey, bg = 'bg' } },
    { PickerTitle = { fg = 'white', bg = P.grey, bold = true } },
    { UnderlinedTitle = { bold = true, underline = true } },
    { StatusColSep = { link = 'Dim' } },
    -----------------------------------------------------------------------------//
    { CodeBlock = { bg = { from = 'Normal', alter = shade.code } } },
    { markdownCode = { link = 'CodeBlock' } },
    { markdownCodeBlock = { link = 'CodeBlock' } },
    -----------------------------------------------------------------------------//
    --  Spell
    -----------------------------------------------------------------------------//
    { SpellBad = { undercurl = true, bg = 'NONE', fg = 'NONE', sp = 'green' } },
    { SpellRare = { undercurl = true } },
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    -- { DiffAdd = { bg = '#26332c', fg = 'NONE', underline = false } },
    -- { DiffDelete = { bg = '#572E33', fg = '#5c6370', underline = false } },
    -- { DiffChange = { bg = '#273842', fg = 'NONE', underline = false } },
    -- { DiffText = { bg = '#314753', fg = 'NONE' } },
    -- these highlights are syntax groups that are set in diff.vim
    { diffAdded = { inherit = 'DiffAdd' } },
    { diffChanged = { inherit = 'DiffChange' } },
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
    { Type = { italic = true, bold = true } },
    { Include = { italic = true, bold = false } },
    { QuickFixLine = { inherit = 'CursorLine', fg = 'NONE', italic = true } },
    -- None of the gutter or end of buffer highlights require an explicit bg,
    -- they should all just use the bg that is in the window they are in.
    -- If any are specified this can lead to issues when a winhighlight is set,
    -- and a gutter bg that differs from Normal renders as a band down the side.
    { SignColumn = { bg = 'NONE' } },
    { EndOfBuffer = { bg = 'NONE' } },
    { LineNr = { bg = 'NONE' } },
    { FoldColumn = { bg = 'NONE' } },
    ------------------------------------------------------------------------------//
    --  Semantic tokens
    ------------------------------------------------------------------------------//
    { ['@lsp.type.parameter'] = { italic = true, fg = { from = 'Normal' } } },
    { ['@lsp.typemod.method'] = { link = '@method' } },
    { ['@lsp.typemod.variable.global'] = { bold = true, inherit = '@constant.builtin' } },
    { ['@lsp.typemod.variable.defaultLibrary'] = { italic = true } },
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
    { ['@parameter'] = { italic = true, bold = true, fg = 'NONE' } },
    { ['@error'] = { fg = 'fg', bg = 'NONE' } },
    { ['@text.diff.add'] = { link = 'DiffAdd' } },
    { ['@text.diff.delete'] = { link = 'DiffDelete' } },
    { ['@text.title.markdown'] = { underdouble = true } },
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    { LspReferenceWrite = { inherit = 'LspReferenceText', bold = true, italic = true, underline = true } },
    { LspSignatureActiveParameter = { link = 'Visual' } },
    -- Sign column line
    { DiagnosticSignInfoLine = { inherit = 'DiagnosticVirtualTextInfo', fg = 'NONE' } },
    { DiagnosticSignHintLine = { inherit = 'DiagnosticVirtualTextHint', fg = 'NONE' } },
    { DiagnosticSignErrorLine = { inherit = 'DiagnosticVirtualTextError', fg = 'NONE' } },
    { DiagnosticSignWarnLine = { inherit = 'DiagnosticVirtualTextWarn', fg = 'NONE' } },
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
  local shade = shades()
  highlight.all({
    { PanelDarkBackground = { bg = { from = 'Normal', alter = shade.panel_dark } } },
    { PanelDarkHeading = { inherit = 'PanelDarkBackground', bold = true } },
    { PanelBackground = { bg = { from = 'Normal', alter = shade.panel } } },
    { PanelHeading = { inherit = 'PanelBackground', bold = true } },
    { PanelWinSeparator = { inherit = 'PanelBackground', fg = { from = 'WinSeparator' } } },
    { PanelStNC = { link = 'PanelWinSeparator' } },
    { PanelSt = { bg = { from = 'Visual', alter = -0.2 } } },
  })
end

local sidebar_fts = {
  'Avante',
  'AvanteInput',
  'undotree',
  'Outline',
  'neotest-summary',
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
    ['solarized'] = {
      { Constant = { bold = true } },
      { NonText = { fg = { from = 'Comment' } } },
      { TabLineSel = { fg = { from = 'SpecialKey' } } },
      -- Solarized leans on background tints rather than many distinct hues, so
      -- headings need an explicit border to read as separate surfaces.
      { PanelHeading = { inherit = 'PanelBackground', bold = true, underline = true } },
      { PanelWinSeparator = { inherit = 'PanelBackground', fg = { from = 'WinSeparator' } } },
    },
    ['github_dark_default'] = {
      { TabLineSel = { link = 'Todo' } },
      { WinSeparator = { link = 'WhiteSpace' } },
      { PanelHeading = { bg = { from = 'Normal', alter = 0.8 } } },
    },
  }
  local hls = overrides[vim.g.colors_name]
  if hls then highlight.all(hls) end
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
