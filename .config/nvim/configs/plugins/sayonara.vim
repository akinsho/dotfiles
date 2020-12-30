if !v:lua.plugin_loaded('vim-sayonara')
  finish
endif

let g:sayonara_confirm_quit = 1

let g:sayonara_filetypes = {
      \ 'nerdtree': 'NERDTreeClose',
      \ 'undotree': 'echomsg "Closing Undotree" | UndotreeHide',
      \ 'coc-explorer': 'CocCommand explorer'
      \ }

nnoremap <silent><leader>qq :Sayonara!<cr>
nnoremap <silent><leader>qw :Sayonara<cr>
if has('nvim') | tnoremap <silent><nowait><C-Q> <C-\><C-n><Cmd>Sayonara<cr> | endif
