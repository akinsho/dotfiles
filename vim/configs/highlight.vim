""---------------------------------------------------------------------------//
" Highlights {{{
""---------------------------------------------------------------------------//
" Highlight cursor column onwards - kind of cool
""---------------------------------------------------------------------------//
" let &colorcolumn=join(range(81,999),",")
" set colorcolumn=80
""---------------------------------------------------------------------------//
syntax clear SpellBad
syntax clear SpellCap
syntax clear SpellLocal
syntax clear SpellRare
syntax clear Search

highlight SpellBad  term=underline cterm=italic ctermfg=Red
highlight SpellCap  term=underline cterm=italic ctermfg=Blue
highlight! link SpellLocal SpellCap
highlight! link SpellRare SpellCap
" Clearing conceal messes up indent guide lines
" highlight clear Conceal "Sets no highlighting for conceal
highlight Conceal gui=bold
""---------------------------------------------------------------------------//
"few nicer JS colours
""---------------------------------------------------------------------------//
" highlight jsFuncCall gui=italic ctermfg=cyan
highlight xmlAttrib gui=italic,bold cterm=italic,bold ctermfg=121
highlight jsxAttrib cterm=italic,bold ctermfg=121
highlight jsThis ctermfg=224
highlight jsSuper ctermfg=13
highlight Include gui=italic cterm=italic
highlight jsFuncArgs gui=italic cterm=italic ctermfg=217
highlight jsClassProperty ctermfg=14 cterm=bold,italic term=bold,italic
highlight jsExportDefault gui=italic,bold cterm=italic ctermfg=179
highlight Type gui=italic,bold cterm=italic
highlight htmlArg gui=italic,bold cterm=italic,bold ctermfg=yellow
highlight Comment gui=italic cterm=italic
highlight Type    gui=italic,bold cterm=italic,bold
highlight Folded  gui=bold cterm=bold guifg=#A2E8F6
highlight WildMenu guibg=#004D40 guifg=white ctermfg=none ctermbg=none
highlight MatchParen cterm=bold ctermbg=none guifg=#29EF58 guibg=NONE
""---------------------------------------------------------------------------//
" Startify Highlighting
""---------------------------------------------------------------------------//
hi StartifyBracket  guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyFile     guifg=#eeeeee ctermfg=255 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyFooter   guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyHeader   guifg=#E7B563 ctermfg=114 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyNumber   guifg=#f8f8f2 ctermfg=215 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifyPath     guifg=#8a8a8a ctermfg=245 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySection  guifg=#E7B563 ctermfg=114 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySelect   guifg=#5fdfff ctermfg=81 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySlash    guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi StartifySpecial  guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
if has('nvim')
  highlight TermCursor ctermfg=green guifg=green
endif
""---------------------------------------------------------------------------//
"Autocomplete menu highlighting
""---------------------------------------------------------------------------//
"make the completion menu a bit more readable
" highlight PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
" highlight PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE
highlight PmenuSel guibg=#004D40 guifg=white gui=bold
highlight BufTabLineCurrent gui=bold guibg=#E7B563 guifg=black

highlight QuickFixLine guibg=#8A95A7 gui=underline
"Color the tildes at the end of the buffer
" hi link EndOfBuffer VimFgBgAttrib
" highlight VertSplit guibg=bg guifg=bg
" highlight Identifier gui=italic,bold
"}}}
""---------------------------------------------------------------------------//
