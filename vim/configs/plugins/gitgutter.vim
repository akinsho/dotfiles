""---------------------------------------------------------------------------//
" Git Gutter
""---------------------------------------------------------------------------//
nnoremap <leader>gg :GitGutterToggle<CR>
let g:gitgutter_sign_added            = '❖'
let g:gitgutter_map_keys              = 0
let g:gitgutter_enabled               = 1
let g:gitgutter_grep_command          = 'ag --nocolor'
let g:gitgutter_sign_modified         = '•'
let g:gitgutter_sign_modified_removed = '±'
let g:gitgutter_sign_removed          = '-'
let g:gitgutter_max_signs             = 400
nnoremap <silent> ]h :GitGutterNextHunk<CR>
nnoremap <silent> [h :GitGutterPrevHunk<CR>
nnoremap <silent> <Leader>hr :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>hp :GitGutterPreviewHunk<CR><c-w>j
nnoremap <silent> <Leader>hs :GitGutterStageHunk<CR>
