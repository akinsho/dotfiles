if !PluginLoaded("vim-buffet")
  finish
endif

let g:buffet_use_devicons = 1
let g:buffet_separator = ""
let g:buffet_tab_icon = "\uf00a"
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"
let g:buffet_modified_icon = ' ●' "✎ ◇

function! g:BuffetSetCustomColors() abort
  let s:tabline_colors = tabline#get_colors()
  let dark_blue = s:tabline_colors['dark_blue']
  let dark_yellow = s:tabline_colors['dark_yellow']
  let bright_blue = s:tabline_colors['bright_blue']
  let foreground = s:tabline_colors['tabline_foreground']
  let background = s:tabline_colors['tabline_background']
  let selected_background = s:tabline_colors['tabline_selected_background']

  silent! execute 'highlight! BuffetBuffer guifg='.foreground.' guibg='.background.' gui=NONE'
  silent! execute 'highlight! BuffetCurrentBuffer guifg='.bright_blue.' guibg='.selected_background.' gui=bold'
  silent! execute 'highlight! BuffetActiveBuffer guifg='.foreground.' guibg='.selected_background.' gui=bold'
  silent! execute 'highlight! BuffetTab guibg='.dark_blue
  silent! execute 'highlight! BuffetModCurrentBuffer guifg='.dark_yellow.' guibg='.selected_background.' gui=bold'
  silent! execute 'highlight! BuffetModActiveBuffer guifg='.dark_yellow.' guibg='.selected_background.' gui=NONE'
endfunction
