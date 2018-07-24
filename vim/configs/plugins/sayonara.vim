if has("nvim")
  nnoremap <C-Q> <Cmd>Sayonara!<CR>
  nnoremap <leader>q <Cmd>Sayonara<CR>
else
  nnoremap <C-Q> :Sayonara!<CR>
  nnoremap <leader>q :Sayonara<CR>
endif
