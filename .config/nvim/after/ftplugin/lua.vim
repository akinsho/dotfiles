setlocal textwidth=100
setlocal formatoptions-=o

nnoremap <buffer><silent><leader>so :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>
