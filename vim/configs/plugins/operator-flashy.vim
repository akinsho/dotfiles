if !has_key(g:plugs, "vim-operator-flashy")
  finish
endif
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

let g:operator#flashy#flash_time=400
