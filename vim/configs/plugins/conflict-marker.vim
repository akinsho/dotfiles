" disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

augroup ConflictMarkerHighlights
  autocmd!
  autocmd ColorScheme * highlight ConflictMarkerBegin guibg=#2f7366
  autocmd ColorScheme * highlight ConflictMarkerOurs guibg=#2e5049
  autocmd ColorScheme * highlight ConflictMarkerTheirs guibg=#344f69
  autocmd ColorScheme * highlight ConflictMarkerEnd guibg=#2f628e
augroup END
