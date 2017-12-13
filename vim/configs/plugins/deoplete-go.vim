""---------------------------------------------------------------------------//
" Deoplete Go
""---------------------------------------------------------------------------//
" if g:gui_neovim_running
"   let g:deoplete#sources#go#gocode_binary= '~/Desktop/Coding/Go/bin/gocode'
" else
" endif
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#use_cache     = 1
let g:deoplete#sources#go#pointer       = 1
let g:deoplete#sources#go#sort_class = [
      \ 'package',
      \ 'func',
      \ 'type',
      \ 'var',
      \ 'const',
      \ 'ultisnips'
      \ ]
"}}}
