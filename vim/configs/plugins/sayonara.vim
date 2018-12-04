let g:sayonara_confirm_quit = 1
let g:sayonara_filetypes = {
      \ 'nerdtree': 'NERDTreeClose',
      \ 'undotree': 'echomsg "Closing Undotree" | UndotreeHide',
      \ }

nnoremap <silent> <leader>Q  :Sayonara!<CR>
nnoremap <silent> <leader>q :Sayonara<CR>
