if !has_key(g:plugs, 'vim-cheat40')
  finish
endif

nnoremap <silent><leader>? :<c-u>Cheat40<CR>
