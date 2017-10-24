""---------------------------------------------------------------------------//
" NERDComment 
""---------------------------------------------------------------------------//
" Commenting
let g:NERDSpaceDelims       = 1
let g:NERDCompactSexyComs   = 1
let g:NERDDefaultAlign      = 'left'
let g:NERDCustomDelimiters  = {
      \ 'jsx': { 'leftAlt': '{/*','rightAlt': '*/}'},
      \ 'javascript.jsx': { 'leftAlt': '{/*','rightAlt': '*/}',
      \ 'left': '//', 'right': ''
      \ },
      \ 'typescript.tsx': { 'leftAlt': '{/*','rightAlt': '*/}',
      \ 'left': '//', 'right': ''
      \ }
      \  }
let g:NERDCommentEmptyLines = 1
"}}}
