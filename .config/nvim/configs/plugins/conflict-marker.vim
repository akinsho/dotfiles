if !PluginLoaded('conflict-marker.vim')
  finish
endif

" disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

function! s:apply_highlights() abort
  highlight ConflictMarkerBegin guibg=#2f7366
  highlight ConflictMarkerOurs guibg=#2e5049
  highlight ConflictMarkerTheirs guibg=#344f69
  highlight ConflictMarkerEnd guibg=#2f628e
endfunction

augroup ConflictMarkerHighlights
  autocmd!
  autocmd VimEnter,ColorScheme * call s:apply_highlights()
augroup END
