if !PluginLoaded('vim-tmux-navigator')
  finish
endif
let g:tmux_navigator_no_mappings = 1

""---------------------------------------------------------------------------//
" TMUX NAVIGATOR
""---------------------------------------------------------------------------//
nnoremap <silent> <C-H> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
nnoremap <silent> <C-K> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateRight<cr>
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_save_on_switch      = 2
