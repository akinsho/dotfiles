if !has_key(g:plugs, 'vim-win')
  finish
endif

map <localleader>w <plug>WinWin
command Win :call win#Win()
