set guioptions+=aAc
set guioptions-=rL
set macligatures
set guifont=Hasklig\ Light:h15
"set guifont=Hasklug\  Nerd\ Font:h14
"set guifont=FuraCode\ Nerd\ Font:h14
set macthinstrokes
set macmeta
set linespace=3
set ballooneval
let g:balloondelay = 600
"autocmd FileType typescript setlocal balloonexpr=tsuquyomi#balloonexpr()
nnoremap <localleader>o :CtrlPBuffer<CR>
let g:gitgutter_enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_alt_sep = ''
