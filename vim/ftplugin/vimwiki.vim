setlocal nonumber norelativenumber colorcolumn=

if exists(":CloseVimWikis")
  nnoremap <buffer><silent> <leader>wc :CloseVimWikis<CR>
endif

nmap <Leader>tt <Plug>VimwikiToggleListItem
" Restore broken/overriden mapping
nnoremap <silent><S-tab> :bprevious<CR>
nmap <c-tab> <Plug>VimwikiNextLink
