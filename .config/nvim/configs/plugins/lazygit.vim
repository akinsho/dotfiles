if !PluginLoaded('lazygit.nvim')
  finish
endif

nnoremap <silent> <leader>lg :LazyGit<CR>
let g:lazygit_floating_window_winblend = 2
