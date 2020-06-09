""---------------------------------------------------------------------------//
" Highlights
""---------------------------------------------------------------------------//
function! ApplyUserHighlights() abort
  "---------------------------------------------------------------------------//
  "Set the color column to highlight one column after the 'textwidth'
  set colorcolumn=+1
  "---------------------------------------------------------------------------//
  " Highlight over 80 cols in red - moot now because -> prettier
  " Note: Match commands interact and this command prevents the command below from working

  if !has_key(g:plugs, 'conflict-marker.vim')
    " Highlight VCS conflict markers
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  endif

  if has('nvim-0.3.2')
    " Add undercurl to existing spellbad highlight
    call utils#extend_highlight('SpellBad', 'SpellBad', 'gui=undercurl cterm=undercurl')
  endif

  highlight Todo gui=bold
  highlight Credit gui=bold
  highlight CursorLineNr guifg=yellow gui=bold
  ""---------------------------------------------------------------------------//
  " Custom highlights
  ""---------------------------------------------------------------------------//
  if g:colors_name ==? 'one'
    call one#highlight('Folded', '5c6370', 'none', 'italic,bold')
    call one#highlight('Type', 'e5c07b', 'none', 'italic,bold')
    " Italicise imports
    call one#highlight('Include', '61afef', 'none', 'italic')
    call one#highlight('jsImport', '61afef', 'none', 'italic')
    call one#highlight('jsExport', '61afef', 'none', 'italic')
    call one#highlight('typescriptImport', 'c678dd', 'none', 'italic')
    call one#highlight('typescriptExport', '61afef', 'none', 'italic')
    call one#highlight('vimCommentTitle', 'c678dd', 'none', 'bold,italic')
  elseif g:colors_name ==? 'onedark'
    " Bold (+/- italicised) types
    call onedark#extend_highlight('Title', { 'gui': 'bold' })
    call onedark#extend_highlight('Type', { 'gui': 'italic,bold' })
    call onedark#extend_highlight('Folded', { 'gui': 'italic,bold' })
    call onedark#extend_highlight('htmlArg', { 'gui': 'italic,bold' })
    " Italicised imports
    call onedark#extend_highlight('Include', { 'gui': 'italic' })
    call onedark#extend_highlight('jsImport', { 'gui': 'italic' })
    call onedark#extend_highlight('jsExport', { 'gui': 'italic' })
    call onedark#extend_highlight('jsExportDefault', { 'gui': 'italic,bold' })
    " Italices func calls
    call onedark#extend_highlight('jsFuncCall', { 'gui': 'italic' })

    call onedark#extend_highlight('TabLineSel', { 'bg': { 'gui': '#61AFEF'} })
  elseif g:colors_name ==? 'vim-monokai-tasty'
    highlight clear SignColumn
    highlight GitGutterAdd guifg=green
    highlight GitGutterChange guifg=yellow
    highlight GitGutterDelete guifg=red
    " Italicise imports and exports without breaking their base highlights
    call utils#extend_highlight('Special', 'SpecialItalic', 'gui=italic')
    highlight link typescriptImport SpecialItalic
    highlight link typescriptExport SpecialItalic
    highlight link jsxAttrib SpecialItalic
    highlight tsxAttrib gui=italic,bold
  else " No specific colorscheme with overrides then do it manually
    highlight jsFuncCall gui=italic
    highlight Comment gui=italic cterm=italic
    highlight xmlAttrib gui=italic,bold cterm=italic,bold ctermfg=121
    highlight jsxAttrib cterm=italic,bold ctermfg=121
    highlight Type    gui=italic,bold cterm=italic,bold
    highlight jsThis ctermfg=224,gui=italic
    highlight Include gui=italic cterm=italic
    highlight jsFuncArgs gui=italic cterm=italic ctermfg=217
    highlight jsClassProperty ctermfg=14 cterm=bold,italic term=bold,italic
    highlight jsExportDefault gui=italic,bold cterm=italic ctermfg=179
    highlight htmlArg gui=italic,bold cterm=italic,bold ctermfg=yellow
    highlight Folded  gui=bold,italic cterm=bold
    highlight link typescriptExport jsImport
    highlight link typescriptImport jsImport
  endif

  call utils#extend_highlight('Comment', 'FoldColumn', 'gui=none')

  if has('nvim')
    highlight TermCursor ctermfg=green guifg=green
    highlight link MsgSeparator Comment
  endif
  "---------------------------------------------------------------------------//
endfunction


augroup InitHighlights
  au!
  autocmd VimEnter * call ApplyUserHighlights()
  autocmd ColorScheme * call ApplyUserHighlights()
augroup END
