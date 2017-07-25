set guioptions+=aAc
set guioptions-=rL
set guifont=Fira\ Code:h14
set macligatures
"set guifont=FuraCode\ Nerd\ Font:h14
"set macthinstrokes
set macmeta
set ballooneval
let g:balloondelay = 600
autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
nnoremap <localleader>o :CtrlPBuffer<CR>
