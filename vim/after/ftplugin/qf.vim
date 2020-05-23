setlocal nonumber
setlocal norelativenumber
setlocal nowrap
setlocal winfixheight
setlocal colorcolumn=
set nobuflisted " I don't want quickfix buffers to pop up when doing :bn or :bp
if has('nvim')
  highlight link QuickFixLine CursorLine
endif
