let g:sayonara_confirm_quit = 0
let g:sayonara_filetypes = {
      \ 'nerdtree': 'NERDTreeClose',
      \ 'undotree': 'echomsg "Closing Undotree" | UndotreeHide',
      \ 'coc-explorer': 'CocCommand explorer'
      \ }

nnoremap <silent> <leader>q  :Sayonara!<CR>
nnoremap <silent> <c-q> :Sayonara<CR>
if has('nvim') | tnoremap <silent><nowait><C-Q> <C-\><C-n><Cmd>Sayonara<cr> | endif
