if !has_key(g:plugs, 'vim-smartword')
  finish
endif

map w  <Plug>(smartword-w)
map b  <Plug>(smartword-b)
map e  <Plug>(smartword-e)
map ge <Plug>(smartword-ge)

if has_key(g:plugs, 'camelCaseMotion')
  map <Plug>(smartword-basic-w)  <Plug>CamelCaseMotion_w
  map <Plug>(smartword-basic-b)  <Plug>CamelCaseMotion_b
  map <Plug>(smartword-basic-e) <Plug>CamelCaseMotion_e
endif
