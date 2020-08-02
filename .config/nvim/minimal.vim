call plug#begin(stdpath('data') . '/plugged')
" insert buggy plugins here
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'

Plug 'joshdick/onedark.vim' " alternative one dark with a light theme
call plug#end()

" packadd! vim-one

set termguicolors
set background=dark
colorscheme one

" packadd! nvim-bufferline.lua
" lua require'bufferline'.setup{}
