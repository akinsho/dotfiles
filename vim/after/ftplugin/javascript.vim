setl completeopt-=preview
setlocal nofoldenable  foldtext=JavascriptFold()
setlocal foldlevelstart=99 foldmethod=syntax
set suffixesadd+=.js,.jsx

nnoremap <leader>jr :call akin#JSXEncloseReturn()<CR>
nnoremap vat :call akin#JSXSelectTag()<CR>
nnoremap gd :TSDef<CR>

function! JavascriptFold()
  let line = ' ' . substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldchar = matchstr(&fillchars, 'fold:\')
  let foldtextstart = strpart('✦' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength - 7) . foldtextend . ' '
endfunction
