if !has_key(g:plugs, 'vim-promiscuous')
  finish
endif

nnoremap <localleader>pr :Promiscuous<CR>
nnoremap <localleader>pb :Promiscuous -<CR>
