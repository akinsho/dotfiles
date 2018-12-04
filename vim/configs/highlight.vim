""---------------------------------------------------------------------------//
" Highlights
""---------------------------------------------------------------------------//
if exists('g:gui_oni')
  finish
endif

" Takes a base - highlight group to extend,
" group - the new group name
" add - the settings to add  to the highlight
function! ExtendHighlight(base, group, add)
  redir => basehi
  sil! exe 'highlight' a:base
  redir END
  let grphi = split(basehi, '\n')[0]
  let grphi = substitute(grphi, '^'.a:base.'\s\+xxx', '', '')
  sil exe 'highlight' a:group grphi a:add
endfunction


function! ApplyUserHighlights() abort
  " Highlight cursor column onwards - kind of cool
  "---------------------------------------------------------------------------//
  let &colorcolumn=join(range(81,999),",")
  set colorcolumn=80
  "---------------------------------------------------------------------------//
  " syntax clear SpellBad
  " syntax clear SpellCap
  " syntax clear SpellLocal
  " syntax clear SpellRare
  " syntax clear Search
  " syntax clear typescriptOpSymbols

  " Highlight over 80 cols in red
  match Error /\%80v.\+/

  " highlight SpellBad  term=underline cterm=italic ctermfg=Red
  " highlight SpellCap  term=underline cterm=italic ctermfg=Blue
  " highlight link SpellLocal SpellCap
  " highlight link SpellRare SpellCap
  highlight Conceal gui=bold
  highlight Todo gui=bold
  highlight Credit gui=bold
  highlight CursorLineNr guifg=yellow gui=bold
  ""---------------------------------------------------------------------------//
  "Nicer JS colours
  ""---------------------------------------------------------------------------//
  highlight jsFuncCall gui=italic
  highlight Comment gui=italic cterm=italic
  highlight xmlAttrib gui=italic,bold cterm=italic,bold ctermfg=121
  highlight jsxAttrib cterm=italic,bold ctermfg=121
  highlight Type    gui=italic,bold cterm=italic,bold
  highlight jsThis ctermfg=224,gui=italic
  highlight jsSuper ctermfg=13
  highlight Include gui=italic cterm=italic
  highlight jsFuncArgs gui=italic cterm=italic ctermfg=217
  highlight jsClassProperty ctermfg=14 cterm=bold,italic term=bold,italic
  highlight jsExportDefault gui=italic,bold cterm=italic ctermfg=179
  highlight htmlArg gui=italic,bold cterm=italic,bold ctermfg=yellow
  highlight Folded  gui=bold,italic cterm=bold
  " guifg=#A2E8F6
  highlight WildMenu guibg=#004D40 guifg=white ctermfg=none ctermbg=none
  if exists('g:gui_oni')
    highlight MatchParen cterm=bold ctermbg=none guifg=#29EF58 guibg=NONE
  else
    highlight MatchParen cterm=bold ctermbg=none guifg=NONE guibg=#29EF58
  endif
  " Highlight VCS conflict markers
  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  if has('nvim')
    highlight TermCursor ctermfg=green guifg=green
  endif
  ""---------------------------------------------------------------------------//
  "Autocomplete menu highlighting
  ""---------------------------------------------------------------------------//
  highlight PmenuSel guibg=#004D40 guifg=white gui=bold

  " make the completion menu a bit more readable
  " highlight PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
  " highlight PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE
  " Color the tildes at the end of the buffer
  " hi link EndOfBuffer VimFgBgAttrib

  "Remove vertical separator
  " highlight VertSplit guibg=bg guifg=bg
  "---------------------------------------------------------------------------//

  "---------------------------------------------------------------------------//
  " Illuminated Word
  "---------------------------------------------------------------------------//
  hi illuminatedWord gui=underline
endfunction


augroup InitHighlights
  au!
  autocmd VimEnter * call ApplyUserHighlights()
  autocmd ColorScheme * call ApplyUserHighlights()
augroup END
