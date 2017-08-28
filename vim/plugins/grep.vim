nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@

vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    execute "normal! `<v`>y"
  elseif a:type ==# 'char'
    execute "normal! `[v`]y"
  else
    return
  endif
"Use Winnr to check if the cursor has moved it if has restore it
  let winnr = winnr()
  silent execute "grep! " . shellescape(@@) . " ."
  let @@ = saved_unnamed_register
  if winnr() != winnr
    wincmd p
  endif
endfunction
