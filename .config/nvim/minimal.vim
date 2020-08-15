call plug#begin(stdpath('data') . '/plugged')
" insert buggy plugin
Plug 'rakr/vim-one'
call plug#end()

set background=dark
set termguicolors
colorscheme one
