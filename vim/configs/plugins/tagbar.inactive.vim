"TAGBAR
""---------------------------------------------------------------------------//
nnoremap <leader>. :TagbarToggle<CR>
let g:tagbar_autoshowtag                = 1
let g:tagbar_autoclose                  = 1
let g:tagbar_show_visibility            = 0
let g:tagbar_autofocus                  = 1
let g:airline#extensions#tagbar#enabled = 0
let g:tagbar_type_typescript = {
      \ 'ctagstype': 'typescript',
      \ 'kinds': [
      \ 'c:classes',
      \ 'n:modules',
      \ 'f:functions',
      \ 'v:variables',
      \ 'v:varlambdas',
      \ 'm:members',
      \ 'i:interfaces',
      \ 'e:enums',
      \ ]
      \ }
"}}}
