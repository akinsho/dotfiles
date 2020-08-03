call plug#begin(stdpath('data') . '/plugged')
" insert buggy plugins here
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'raker/vim-one' " alternative one dark with a light theme
call plug#end()

set termguicolors
set background=dark
colorscheme one
