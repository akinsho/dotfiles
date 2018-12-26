""---------------------------------------------------------------------------//
" NEOTERM
""---------------------------------------------------------------------------//
let g:neoterm_size            = '12'
let g:neoterm_automap_keys    = ',tt'
let g:neoterm_default_mod     = 'botright'
let g:neoterm_autoscroll      = 1
let g:neoterm_autoinsert      = 1
let g:neoterm_autojump        = 0
let g:neoterm_keep_term_open  = 0
let g:neoterm_fixedsize       = 1
" Git commands
command! -nargs=+ Tg :T git <args>
" Useful maps
" hide/close terminal
if has('nvim')
  tnoremap <silent> <leader><CR> <Cmd>Ttoggle<CR>
endif
nnoremap <silent> <leader><CR> :Ttoggle<CR>
nnoremap <silent> <leader>ta :TtoggleAll<CR>
" Map a command to the automap keys
nnoremap <silent> <leader>tm :Tmap<space>
" clear terminal
nnoremap <silent> <leader>tl :Tclear<cr>
" kill process in terminal
nnoremap <silent> <leader>tk :Tkill<cr>
