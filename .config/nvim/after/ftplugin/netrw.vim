"===================================================================================
" NETRW
"===================================================================================
let g:netrw_liststyle    = 3
let g:netrw_banner       = 0
let g:netrw_browse_split = 0
let g:netrw_winsize      = 25
let g:netrw_altv         = 1
augroup netrw
  autocmd!
  autocmd FileType netrw nnoremap <buffer> q :q<CR>
  autocmd FileType netrw nnoremap <buffer> l <CR>
  autocmd FileType netrw nnoremap <buffer> h <CR>
augroup END
