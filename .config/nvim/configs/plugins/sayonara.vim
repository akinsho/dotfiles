let g:sayonara_confirm_quit = 1

let g:sayonara_filetypes = {
      \ 'nerdtree': 'NERDTreeClose',
      \ 'undotree': 'echomsg "Closing Undotree" | UndotreeHide',
      \ 'coc-explorer': 'CocCommand explorer'
      \ }

nnoremap <leader>q :Sayonara<cr>
nnoremap <leader>Q :Sayonara!<cr>
if has('nvim') | tnoremap <silent><nowait><C-Q> <C-\><C-n><Cmd>Sayonara<cr> | endif
