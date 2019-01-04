function! s:get_buffer_list()
  redir => l:buflist
  silent! ls!
  redir END
  return l:buflist
endfunction

function! ToggleList(bufname, pfx)
  let l:buflist = s:get_buffer_list()
  for l:bufnum in map(filter(split(l:buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(l:bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx ==# 'l' && len(getloclist(0)) ==# 0
      echohl ErrorMsg
      echo 'Location List is Empty.'
      return
  endif
  let l:winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != l:winnr
    wincmd p
  endif
endfunction


nnoremap <silent> <leader>ls :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <silent> <leader>li :call ToggleList("Location List", 'l')<CR>
