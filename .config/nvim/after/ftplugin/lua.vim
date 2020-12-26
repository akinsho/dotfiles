setlocal textwidth=100

nnoremap <buffer><silent><leader>so :execute "luafile ".fnamemodify('%', ':p')
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>
