function! utils#tab_zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction

" NOTE: we define this outside of our ftplugin/qf.vim
" since that is loaded on each run of our qf window
" this means that it would be recreated each time if
" not defined separately, so on replacing the quickfix
" we would recreate this function during it's execution
" source: https://vi.stackexchange.com/a/21255
" using range-aware function
function! utils#qf_delete(bufnr) range
  " get current qflist
  let l:qfl = getqflist()
  " no need for filter() and such; just drop the items in range
  call remove(l:qfl, a:firstline - 1, a:lastline - 1)
  " replace items in the current list, do not make a new copy of it;
  " this also preserves the list title
  call setqflist([], 'r', {'items': l:qfl})
  " restore current line
  call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction
