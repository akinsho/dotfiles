if !has_key(g:plugs, 'vim-tmux-navigator')
  finish
endif
""---------------------------------------------------------------------------//
" TMUX NAVIGATOR
""---------------------------------------------------------------------------//
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_save_on_switch      = 2
