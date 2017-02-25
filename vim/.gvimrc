let g:webdevicons_enable = 0

if has('gui_running')
  colorscheme sialoquent
  set guifont=Roboto\ Mono\ Light\ for\ Powerline:h14
  let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
  highlight GitGutterAdd guifg = '#A3E28B'
  let g:gitgutter_sign_modified = '•'
  let g:gitgutter_sign_added = '❖'
endif
