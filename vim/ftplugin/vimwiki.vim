setlocal nonumber norelativenumber colorcolumn=

if exists(":CloseVimWikis")
  nnoremap <buffer><silent> <leader>wc :CloseVimWikis<CR>
endif
nmap <Leader>tt <Plug>VimwikiToggleListItem
