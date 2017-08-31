setlocal number
setlocal norelativenumber
setlocal nolist
" we don't want quickfix buffers to pop up when doing :bn or :bp
set nobuflisted
" quit Vim if the last window is a quickfix window
" are we in a location list or a quickfix list?
let b:qf_isLoc = !empty(getloclist(0))

augroup Quit
  " autocmd qf BufEnter <buffer> if winnr('$') < 2 | q | endif
augroup END

" open entry in a new horizontal window
nnoremap <silent> <buffer> s <C-w><CR>

" open entry in a new vertical window.
nnoremap <silent> <expr> <buffer> v &splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"

" open entry in a new tab.
nnoremap <silent> <buffer> t <C-w><CR><C-w>T

" open entry and come back
nnoremap <silent> <buffer> o <CR><C-w>p

if b:qf_isLoc == 1
  nnoremap <silent> <buffer> O <CR>:lclose<CR>
else
  nnoremap <silent> <buffer> O <CR>:cclose<CR>
endif
