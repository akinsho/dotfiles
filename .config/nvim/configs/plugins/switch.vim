let g:switch_custom_definitions =
    \ [
    \   {
    \     '\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>': '\=toupper(submatch(1)) . submatch(2)',
    \     '\<\(\u\l\+\)\(\u\l\+\)\+\>': "\\=tolower(substitute(submatch(0), '\\(\\l\\)\\(\\u\\)', '\\1_\\2', 'g'))",
    \     '\<\(\l\+\)\(_\l\+\)\+\>': '\U\0',
    \     '\<\(\u\+\)\(_\u\+\)\+\>': "\\=tolower(substitute(submatch(0), '_', '-', 'g'))",
    \     '\<\(\l\+\)\(-\l\+\)\+\>': "\\=substitute(submatch(0), '-\\(\\l\\)', '\\u\\1', 'g')",
    \   }
    \ ]

augroup SwitchFiletypes
  autocmd!
  " - [ ] → - [x] → - [-] → loops back to - [ ]
  " + [ ] → + [x] → + [-] → loops back to + [ ]
  " * [ ] → * [x] → * [-] → loops back to * [ ]
  " 1. [ ] → 1. [x] → 1. [-] → loops back to 1. [ ]
  autocmd FileType markdown let b:switch_custom_definitions =
    \ [
    \   { '\v^(\s*[*+-] )?\[ \]': '\1[x]',
    \     '\v^(\s*[*+-] )?\[x\]': '\1[-]',
    \     '\v^(\s*[*+-] )?\[-\]': '\1[ ]',
    \   },
    \   { '\v^(\s*\d+\. )?\[ \]': '\1[x]',
    \     '\v^(\s*\d+\. )?\[x\]': '\1[-]',
    \     '\v^(\s*\d+\. )?\[-\]': '\1[ ]',
    \   },
    \ ]
augroup END
