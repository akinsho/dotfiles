" Snippets from vim-qf
" Credits: https://github.com/romainl/vim-qf
setlocal number
setlocal norelativenumber
setlocal nolist
setlocal wrap
if has('nvim')
  highlight QuickFixLine gui=bold
endif
" setlocal winminheight=1 winheight=8 winfixheight
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
nnoremap <buffer><CR> <CR><C-w>p
" open entry in a new vertical window.
nnoremap <silent><expr> <buffer> v &splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"
" open entry in a new tab.
nnoremap <silent><buffer> t <C-w><CR><C-w>T
" open entry and come back
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

function! AdjustWindowHeight(minheight, maxheight)
  let l:l = 1
  let l:n_lines = 0
  let l:w_width = winwidth(0)
  while l:l <= line('$')
    " number to float for division
    let l:l_len = strlen(getline(l:l)) + 0.0
    let l:line_width = l:l_len/l:w_width
    let l:n_lines += float2nr(ceil(l:line_width))
    let l:l += 1
  endw
  exe max([min([l:n_lines, a:maxheight]), a:minheight]) . 'wincmd _'
endfunction

augroup QFCommands
  au!
  autocmd * <buffer> wincmd J
  autocmd * <buffer><silent> call AdjustWindowHeight(8, 8)
augroup END

let &cpoptions = s:save_cpo
