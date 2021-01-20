setlocal textwidth=100

nnoremap <buffer><silent><leader>so :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>
