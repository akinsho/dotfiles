if !PluginLoaded('vim-sneak')
  finish
endif

let g:sneak#label      = 1
let g:sneak#s_next     = 0
let g:sneak#use_ic_scs = 1

" replace , which is my leader
" map gS <Plug>Sneak_,
" f that triggers label mode
" nnoremap <silent> f :<C-U>call sneak#wrap('', 1, 0, 1, 1)<CR>

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
