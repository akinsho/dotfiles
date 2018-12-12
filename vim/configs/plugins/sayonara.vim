let g:sayonara_confirm_quit = 1
let g:sayonara_filetypes = {
      \ 'nerdtree': 'NERDTreeClose',
      \ 'undotree': 'echomsg "Closing Undotree" | UndotreeHide',
      \ }

nnoremap <silent> <leader>q  :Sayonara!<CR>
nnoremap <silent> <c-q> :Sayonara<CR>
if has('nvim') | tnoremap <silent><nowait><C-Q> <C-\><C-n><Cmd>Sayonara<cr> | endif
