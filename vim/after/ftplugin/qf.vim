""---------------------------------------------------------------------------//
" Snippets from vim-qf
" Credits: https://github.com/romainl/vim-qf
""---------------------------------------------------------------------------//
" This allows scripts to execute with vim defaults i.e. not clash
" with changes a user (me) might have made
let s:save_cpo = &cpo
set cpo&vim

setlocal number
setlocal norelativenumber
setlocal wrap
setlocal winfixheight
" we don't want quickfix buffers to pop up when doing :bn or :bp
set nobuflisted

" Add the above commands to a list of commands to undo when switching out of 
" the QF window
let b:undo_ftplugin .= "| setl wrap< rnu< nu< bl<"

if has('nvim')
  highlight clear QuickFixLine
  highlight! QuickFixLine cterm=bold gui=bold guibg=none
endif

if &l:conceallevel == 0
  setlocal conceallevel=2
endif

let s:list = getloclist(0)
let b:is_loc = !empty(s:list)

if !b:is_loc
  let s:list = getqflist()
  if empty(s:list)
    unlet! s:list
    finish
  endif
else
  let b:src_buf = s:list[0].bufnr
endif

" open entry in a new horizontal window
nnoremap <silent><buffer> s <C-w><CR>
" open entry in a new vertical window.
nnoremap <silent><expr> <buffer> v &splitright
      \ ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p"
      \ : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"
" open entry in a new tab.
nnoremap <silent><buffer> t <C-w><CR><C-w>T
" open entry and come back
nnoremap <silent><buffer> o <CR><C-w>p
" preview file
nnoremap <silent><buffer> p  :call utils#preview_file_under_cursor()<CR>
" are we in a location list or a quickfix list?
let b:qf_isLoc = !empty(getloclist(0))

if b:qf_isLoc == 1
  nnoremap <silent> <buffer> O <CR>:lclose<CR>
else
  nnoremap <silent> <buffer> O <CR>:cclose<CR>
endif

" replace all the mappings
let b:undo_ftplugin .= "| execute 'nunmap <buffer> s'"
      \ . "| execute 'nunmap <buffer> v'"
      \ . "| execute 'nunmap <buffer> t'"
      \ . "| execute 'nunmap <buffer> o'"
      \ . "| execute 'nunmap <buffer> O'"
      \ . "| execute 'nunmap <buffer> p'"

if !exists('b:src_buf') && !b:is_loc
  wincmd J
endif

let b:undo_ftplugin .=  "| unlet! b:qf_isLoc"

let &cpo = s:save_cpo
