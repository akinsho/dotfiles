setlocal nonumber norelativenumber colorcolumn=

if exists(":CloseVimWikis")
  nnoremap <buffer><silent> <leader>wc :CloseVimWikis<CR>
endif

" Restore broken/overriden mapping
nnoremap <silent><S-tab> :bprevious<CR>
nnoremap <silent><tab> :bnext<CR>

nmap } <Plug>VimwikiPrevLink
nmap { <Plug>VimwikiNextLink
nmap <Leader>tt <Plug>VimwikiToggleListItem
