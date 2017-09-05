setlocal concealcursor=nvic
setl completeopt-=preview
setlocal foldenable  foldtext=FoldText()
setlocal foldlevelstart=99

" Javascript {{{
function! FoldText()
  let l:line = ' ' . substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let l:lines_count = v:foldend - v:foldstart + 1
  let l:lines_count_text = '(' . ( l:lines_count ) . ')'
  let l:foldchar = matchstr(&fillchars, 'fold:\')
  let l:foldtextstart = strpart('✦' . repeat(l:foldchar, v:foldlevel*2) . l:line, 0, (winwidth(0)*2)/3)
  let l:foldtextend = l:lines_count_text . repeat(' ', 2 )
  let l:foldtextlength = strlen(substitute(l:foldtextstart . l:foldtextend, '.', 'x', 'g')) + &foldcolumn
  return l:foldtextstart . repeat(' ', winwidth(0)-l:foldtextlength) . l:foldtextend . ' '
endfunction
" }}}
