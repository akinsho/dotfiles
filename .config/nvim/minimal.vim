call plug#begin(stdpath('data') . '/plugged')
" insert buggy plugins here
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'mhinz/vim-startify'

Plug 'rakr/vim-one' " alternative one dark with a light theme
call plug#end()

colorscheme one
