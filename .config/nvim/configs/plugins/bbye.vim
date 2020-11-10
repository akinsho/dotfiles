if !PluginLoaded('vim-bbye')
  finish
endif

nnoremap <silent><leader>qq :Bdelete<CR>
nnoremap <silent><leader>qw :Bwipeout<CR>
if has('nvim')
  tnoremap <silent><nowait><C-Q> <C-\><C-n><Cmd>BufWipeout<cr>
endif
