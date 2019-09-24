""---------------------------------------------------------------------------//
" Git Gutter
""---------------------------------------------------------------------------//
nnoremap <leader>gg :GitGutterToggle<CR>
let g:gitgutter_sign_added = ''
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_modified = ''
let g:gitgutter_sign_modified_removed = ''
let g:gitgutter_terminal_reports_focus = 0
let g:gitgutter_sign_allow_clobber = 0
if has('nvim-0.3.2')
  let g:gitgutter_highlight_linenrs = 1
endif
" let g:gitgutter_sign_priority = 1
" let g:gitgutter_sign_added            = '❖'
" let g:gitgutter_sign_modified         = '•'
" let g:gitgutter_sign_modified_removed = '±'
" let g:gitgutter_sign_removed          = '-'

let g:gitgutter_map_keys              = 0
let g:gitgutter_enabled               = 1
let g:gitgutter_grep_command          = 'ag --nocolor'

nnoremap <silent> ]h :GitGutterNextHunk<CR>
nnoremap <silent> [h :GitGutterPrevHunk<CR>
nnoremap <silent> <Leader>hr :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>hu :GitGutterUndoHunk<CR>
nnoremap <silent> <Leader>hp :GitGutterPreviewHunk<CR><c-w>j
nnoremap <silent> <Leader>hs :GitGutterStageHunk<CR>
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
