nnoremap <buffer><silent><leader>so :execute "luafile ".fnamemodify('%', ':p') <bar> :call VimrcMessage('Sourced ' . expand('%'), 'Title')<CR>
