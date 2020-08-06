call plug#begin(stdpath('data') . '/plugged')
Plug 'Akin909/nvim-bufferline.lua'
Plug 'rakr/vim-one' " alternative one dark with a light theme
call plug#end()

set background=dark
colorscheme one

lua require'bufferline'.setup()
