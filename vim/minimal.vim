call plug#begin(stdpath('data') . '/plugged')
" insert buggy plugins here
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'

call plug#end()

set number relativenumber
set list

augroup CocAutocommands
  autocmd!
  autocmd FileType go let b:coc_root_patterns = ['Makefile']
augroup END
