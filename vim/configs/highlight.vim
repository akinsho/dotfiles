""---------------------------------------------------------------------------//
" Highlights
""---------------------------------------------------------------------------//
if exists('g:gui_oni')
  finish
endif

function! ApplyUserHighlights() abort
  " Highlight cursor column onwards - kind of cool
  "---------------------------------------------------------------------------//
  " let &colorcolumn=join(range(81,999),",")
  " set colorcolumn=80
  " highlight link ColorColumn CursorLine
  "---------------------------------------------------------------------------//
  " Highlight over 80 cols in red - moot now because -> prettier
  " Note: Match commands interact and this command prevents the command below from working

  " Highlight VCS conflict markers
  " match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

  highlight link SpellLocal SpellCap
  highlight link SpellRare SpellCap

  highlight link DiffChange Search

  if has('nvim-0.3.2')
    " Add undercurl to existing spellbad highlight
    call utils#extend_highlight('SpellBad', 'SpellBad', 'gui=undercurl cterm=undercurl')
  endif

  highlight Conceal gui=bold
  highlight Todo gui=bold
  highlight Credit gui=bold
  highlight CursorLineNr guifg=yellow gui=bold
  ""---------------------------------------------------------------------------//
  " JavascriptS/TypeScript highlights
  ""---------------------------------------------------------------------------//
  " Vim One does not allow directly overriding highlights
  if g:colors_name ==? 'one'
    call one#highlight('Folded', 'db7093', 'none', 'bold')
    call one#highlight('Type', 'e5c07b', 'none', 'italic,bold')
    "Italicise imports
    call one#highlight('jsImport', '61afef', 'none', 'italic')
    call one#highlight('jsExport', '61afef', 'none', 'italic')
    call one#highlight('typescriptImport', 'c678dd', 'none', 'italic')
    call one#highlight('typescriptExport', '61afef', 'none', 'italic')
    call one#highlight('TabLineFill', 'abb2bf', '282c34', 'none')
    call one#highlight('TabLine', 'abb2bf', '282c34', 'none')
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
  else
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

  "Remove vertical separator
  " highlight VertSplit guibg=bg guifg=bg
  "---------------------------------------------------------------------------//
endfunction


augroup InitHighlights
  au!
  autocmd VimEnter * call ApplyUserHighlights()
  autocmd ColorScheme * call ApplyUserHighlights()
augroup END
