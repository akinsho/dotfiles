" it gets this wrong
let b:sleuth_automatic = 0
setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2

setlocal spell spelllang=en_gb
setlocal colorcolumn=
setlocal concealcursor=
setlocal nonumber norelativenumber

highlight VimwikiDelText gui=strikethrough guifg=#5c6370 guibg=background
highlight link VimwikiCheckBoxDone VimwikiDelText

" Restore broken/overriden mapping
nnoremap <silent><S-tab> :bprevious<CR>
nnoremap <silent><tab> :bnext<CR>

nmap <buffer> } <Plug>VimwikiPrevLink
nmap <buffer> { <Plug>VimwikiNextLink
nmap <buffer> <Leader>tt <Plug>VimwikiToggleListItem
