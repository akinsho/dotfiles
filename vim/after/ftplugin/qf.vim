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
setlocal colorcolumn=
" we don't want quickfix buffers to pop up when doing :bn or :bp
set nobuflisted

if has('nvim')
  highlight clear QuickFixLine
  highlight! QuickFixLine cterm=bold gui=bold guibg=none
endif
let &cpo = s:save_cpo
