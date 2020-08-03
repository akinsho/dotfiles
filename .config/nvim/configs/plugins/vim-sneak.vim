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
