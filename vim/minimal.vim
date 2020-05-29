call plug#begin(stdpath('data') . '/plugged')
" insert buggy plugins here
Plug 'kyazdani42/nvim-tree.lua'

" This is just for prettiness
Plug 'rakr/vim-one'
call plug#end()

set number relativenumber
set list
