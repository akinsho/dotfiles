""---------------------------------------------------------------------------//
" DEOPLETE TERNJS
""---------------------------------------------------------------------------//
  let g:deoplete#sources#ternjs#types            = 1
  let g:deoplete#sources#ternjs#docs             = 1
  let g:deoplete#sources#ternjs#case_insensitive = 1
  "Add extra filetypes
  let g:deoplete#sources#ternjs#filetypes = [
        \ 'ts',
        \ 'tsx',
        \ 'typescript.tsx',
        \ 'typescript',
        \ 'javascript',
        \ 'jsx',
        \ 'javascript.jsx',
        \ ]
