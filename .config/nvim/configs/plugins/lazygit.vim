if !PluginLoaded('lazygit.nvim')
  finish
endif

nnoremap <silent> <leader>lg :LazyGit<CR>
