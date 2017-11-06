setl foldmethod=syntax foldlevelstart=99
setl nofoldenable
setl completeopt-=preview
setl colorcolumn=100
set suffixesadd+=.ts
set suffixesadd+=.tsx

nnoremap gd :TSDef<CR>
nnoremap <leader>d :TSDef<CR>
nnoremap <localleader>p :TSDefPreview<CR>
nnoremap <localleader>r :TSRefs<CR>
nnoremap <localleader>t :TSType<CR>
nnoremap <localleader>c :TSEditConfig<CR>
nnoremap <localleader>i :TSImport<CR>
nnoremap <localleader>s :TSGetDocSymbols<CR>
nnoremap <leader>jr :call akin#JSXEncloseReturn()<CR>
nnoremap vat :call akin#JSXSelectTag()<CR>
