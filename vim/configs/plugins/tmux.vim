""---------------------------------------------------------------------------//
" TMUX NAVIGATOR {{{
""---------------------------------------------------------------------------//
if exists('$TMUX')
  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
  let g:tmux_navigator_save_on_switch      = 2
endif
"}}}
