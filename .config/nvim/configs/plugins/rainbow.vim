let g:rainbow_active = 1

" enable only for dart
let g:rainbow_conf = {
      \ 'separately': {
      \ '*': 0,
      \ 'dart': {
      \   'operators': '',
      \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold']
      \   },
      \ }
      \}
