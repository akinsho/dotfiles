" Snippets from vim-qf
" Credits: https://github.com/romainl/vim-qf
setlocal number
setlocal norelativenumber
setlocal nolist
setlocal nospell
setlocal colorcolumn=
setlocal wrap
setlocal winfixheight

if has('nvim')
  highlight clear QuickFixLine
  highlight QuickFixLine cterm=underline,bold gui=underline,bold guibg=none
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

let s:size = min([15, max([5, len(s:list)])])
execute 'resize' s:size
let &winheight = s:size
unlet! s:size

" we don't want quickfix buffers to pop up when doing :bn or :bp
set nobuflisted

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin = 'setl fo< com< ofu<'

" open entry in a new horizontal window
nnoremap <silent><buffer> s <C-w><CR>
" open entry in a new vertical window.
nnoremap <silent><expr> <buffer> v &splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"
" open entry in a new tab.
nnoremap <silent><buffer> t <C-w><CR><C-w>T
" open entry and come back
unmap! p
unmap! o
nnoremap <silent><buffer> o <CR><C-w>p
nnoremap <silent><buffer> p  :call <SID>preview_file()<CR>

" are we in a location list or a quickfix list?
let b:qf_isLoc = !empty(getloclist(0))
if b:qf_isLoc == 1
  nnoremap <silent> <buffer> O <CR>:lclose<CR>
else
  nnoremap <silent> <buffer> O <CR>:cclose<CR>
endif

function! s:preview_file()
  let l:winwidth = &columns
  let l:cur_list = b:qf_isLoc == 1 ? getloclist('.') : getqflist()
  let l:cur_line = getline(line('.'))
  let l:cur_file = fnameescape(substitute(l:cur_line, '|.*$', '', ''))
  if l:cur_line =~# '|\d\+'
    let l:cur_pos  = substitute(l:cur_line, '^\(.\{-}|\)\(\d\+\)\(.*\)', '\2', '')
    execute 'vertical pedit! +'.l:cur_pos.' '.l:cur_file
  else
    execute 'vertical pedit! '.l:cur_file
  endif
  wincmd P
  execute 'vert resize '.(l:winwidth / 2)
  wincmd p
endfunction

if !exists('b:src_buf') && !b:is_loc
  wincmd J
endif

let &cpoptions = s:save_cpo

nnoremap <silent><buffer> <cr> :call <sid>select()<cr>
