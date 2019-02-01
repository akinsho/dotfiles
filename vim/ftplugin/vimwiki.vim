setlocal nonumber norelativenumber

if exists(":CloseVimWikis")
  nnoremap <buffer> <leader>wc :CloseVimWikis<CR>
endif
nmap <Leader>tt <Plug>VimwikiToggleListItem
