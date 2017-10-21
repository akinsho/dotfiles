setl softtabstop=4 tabstop=4 shiftwidth=4 foldmethod=indent foldlevelstart=99
setl nofoldenable
setl completeopt-=preview
setl colorcolumn=100
setl omnifunc=tern#Complete


if has('nvim')
  nnoremap gd :TSDef<CR>
  nnoremap <leader>d :TSDef<CR>
  nnoremap <localleader>p :TSDefPreview<CR>
  nnoremap <localleader>r :TSRefs<CR>
  nnoremap <localleader>t :TSType<CR>
  nnoremap <localleader>c :TSEditConfig<CR>
  nnoremap <localleader>i :TSImport<CR>
  nnoremap <localleader>s :TSGetDocSymbols<CR>
endif
