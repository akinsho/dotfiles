if !has_key(g:plugs, "vim-buffet")
  finish
endif

let g:buffet_use_devicons = 1
let g:buffet_separator = ""
let g:buffet_tab_icon = "\uf00a"
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"
let g:buffet_modified_icon = " •" "✎ ◇

function! g:BuffetSetCustomColors() abort
  let s:bright_blue  = '#A2E8F6'
  let s:dark_blue    = '#4e88ff'
  let s:normal_bg = synIDattr(hlID('Normal'), 'bg')
  let s:normal_fg = synIDattr(hlID('Normal'), 'fg')
  let s:comment_fg = synIDattr(hlID('Comment'), 'fg')

  silent! execute 'highlight! BuffetBuffer guifg='.s:comment_fg.' guibg=#1b1e24 gui=None'
  silent! execute 'highlight! BuffetCurrentBuffer guifg='.s:bright_blue.' guibg='.s:normal_bg.' gui=bold'
  silent! execute 'highlight! BuffetTab guibg='.s:dark_blue
endfunction
