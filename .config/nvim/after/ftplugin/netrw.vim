"===================================================================================
" NETRW
"===================================================================================
let g:netrw_liststyle    = 3
let g:netrw_banner       = 0
let g:netrw_browse_split = 0
let g:netrw_winsize      = 25
let g:netrw_altv         = 1
let g:netrw_fastbrowse   = 0

setlocal bufhidden=wipe

augroup netrw
  autocmd!
  autocmd FileType netrw nnoremap <buffer> q :q<CR>
  autocmd FileType netrw nnoremap <buffer> l <CR>
  autocmd FileType netrw nnoremap <buffer> h <CR>
  autocmd FileType netrw nnoremap <buffer> o <CR>
augroup END
