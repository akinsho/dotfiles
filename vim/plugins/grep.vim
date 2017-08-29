nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@

vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
  let l:saved_unnamed_register = @@

  if a:type ==# 'v'
    execute 'normal! `<v`>y'
  elseif a:type ==# 'char'
    execute 'normal! `[v`]y'
  else
    return
  endif
"Use Winnr to check if the cursor has moved it if has restore it
  let l:winnr = winnr()
  silent execute 'grep! ' . shellescape(@@) . ' .'
  let @@ = l:saved_unnamed_register
  if winnr() != l:winnr
    wincmd p
  endif
endfunction
