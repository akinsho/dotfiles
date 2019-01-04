if !has_key(g:plugs, 'vim-js-file-import')
  finish
endif
" Map import to <leader> in normal mode
nmap <leader>im <Plug>(JsFileImport)
" Map import to <leader> in visual mode
xmap <leader>im <Plug>(JsFileImport)
