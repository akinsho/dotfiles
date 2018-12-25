if !has_key(g:plugs, 'nvim-typescript') || exists('g:gui_oni')
  finish
endif

if !exists('g:gui_oni')
  nnoremap gd :TSDef<CR>
  nnoremap <leader>d :TSDef<CR>
  nnoremap <localleader>p :TSDefPreview<CR>
  nnoremap <localleader>r :TSRefs<CR>
  nnoremap <localleader>t :TSType<CR>
  nnoremap <localleader>s :TSGetDocSymbols<CR>
endif

nnoremap <localleader>c :TSEditConfig<CR>
nnoremap <localleader>i :TSImport<CR>
