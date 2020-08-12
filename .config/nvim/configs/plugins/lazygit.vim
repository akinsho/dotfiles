" allow this mapping so the plugin can be lazy loaded
nnoremap <silent> <leader>lg :LazyGit<CR>

if !PluginLoaded('lazygit.nvim')
  finish
endif
let g:lazygit_floating_window_winblend = 2
