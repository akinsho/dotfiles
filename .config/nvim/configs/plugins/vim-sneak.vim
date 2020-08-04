if !PluginLoaded('vim-sneak')
  finish
endif

" Highlighting sneak and it's label is a little complicated
" The plugin creates a colorscheme autocommand that
" checks for the existence of these highlight groups
" it is best to leave this as is as they are picked up on colorscheme loading
highlight Sneak guifg=red guibg=background
highlight SneakLabel gui=italic,bold,underline guifg=red guibg=background
highlight SneakLabelMask guifg=red guibg=background

let g:sneak#label      = 1
let g:sneak#s_next     = 0
let g:sneak#use_ic_scs = 1

" 1-character enhanced 'f'
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
" visual-mode
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
" operator-pending-mode
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" 1-character enhanced 't'
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
" visual-mode
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
" operator-pending-mode
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
