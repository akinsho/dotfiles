""---------------------------------------------------------------------------//
" NEOTERM
""---------------------------------------------------------------------------//
let g:neoterm_size         = '20'
let g:neoterm_automap_keys = ',tt'
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoscroll   = 1
let g:neoterm_autoinsert   = 1
let g:neoterm_fixedsize    = 1
" Git commands
command! -nargs=+ Tg :T git <args>
" Useful maps
" hide/close terminal
nnoremap <silent> <leader><CR> :Ttoggle<CR>
nnoremap <silent> <leader>ta :TtoggleAll<CR>
" clear terminal
nnoremap <silent> <leader>tl :call neoterm#clear()<cr>
nnoremap <silent> <leader>tk :call neoterm#kill()<cr>
