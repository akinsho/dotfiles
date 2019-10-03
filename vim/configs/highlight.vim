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
  "Nicer JS/TS colours
  ""---------------------------------------------------------------------------//
  " Vim One does not allow directly overriding highlights
  if g:colors_name ==? 'one'
    call one#highlight('Folded', 'db7093', 'none', 'bold')
    call one#highlight('Type', 'e5c07b', 'none', 'italic,bold')
    "Italicise typescript imports and exports
    call one#highlight('typescriptImport', 'c678dd', 'none', 'italic')
    call one#highlight('typescriptExport', '61afef', 'none', 'italic')
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
  endif

  " This only applies to the specific highlight names night owl creates
  if g:colors_name ==? "night-owl"
    highlight link typescriptExport jsImport
    highlight link typescriptImport jsImport
  endif

  call utils#extend_highlight('Comment', 'FoldColumn', 'gui=none')

  if has('nvim')
    highlight TermCursor ctermfg=green guifg=green
    highlight link MsgSeparator Comment
  endif
  ""---------------------------------------------------------------------------//
  "Autocomplete menu highlighting
  ""---------------------------------------------------------------------------//
  " Hide the tildes at the end of the buffer
  let s:normal_background = synIDattr(hlID('Normal'), 'bg#')
  execute 'silent highlight EndOfBuffer guifg=' . s:normal_background

  "Remove vertical separator
  " highlight VertSplit guibg=bg guifg=bg
  "---------------------------------------------------------------------------//
endfunction


augroup InitHighlights
  au!
    autocmd VimEnter * call ApplyUserHighlights()
    autocmd ColorScheme * call ApplyUserHighlights()
augroup END
