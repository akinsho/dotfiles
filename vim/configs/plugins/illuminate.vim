if !has_key(g:plugs, 'vim-illuminate') 
  finish
endif

" hi illuminatedWord ctermbg=236 guibg=#2d2c5d
let g:Illuminate_ftblacklist = ['nerdtree', 'gitcommit', 'terminal', 'neoterm']
"---------------------------------------------------------------------------//
" Illuminated Word
"---------------------------------------------------------------------------//
hi illuminatedWord gui=underline
