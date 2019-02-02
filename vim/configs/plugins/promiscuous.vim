if !has_key(g:plugs, 'promiscuous.vim')
  finish
endif

nnoremap <localleader>pr :Promiscuous<CR>
nnoremap <localleader>pb :Promiscuous -<CR>
