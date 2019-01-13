setlocal nonumber norelativenumber

if exists(":CloseVimWikis")
  nnoremap <leader>wc :CloseVimWikis<CR>
endif
nmap <Leader>tt <Plug>VimwikiToggleListItem
