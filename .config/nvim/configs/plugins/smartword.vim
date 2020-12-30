if !v:lua.plugin_loaded('vim-smartword')
  finish
endif

map w  <Plug>(smartword-w)
map b  <Plug>(smartword-b)
map e  <Plug>(smartword-e)
map ge <Plug>(smartword-ge)

if !v:lua.plugin_loaded('CamelCaseMotion')
  map <Plug>(smartword-basic-w)  <Plug>CamelCaseMotion_w
  map <Plug>(smartword-basic-b)  <Plug>CamelCaseMotion_b
  map <Plug>(smartword-basic-e) <Plug>CamelCaseMotion_e
endif
