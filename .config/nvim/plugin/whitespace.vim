augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd VimEnter,ColorScheme * call whitespace#setup()
  autocmd BufWinEnter,InsertLeave * call whitespace#toggle_trailing('n')
  autocmd InsertEnter * call whitespace#toggle_trailing('i')
augroup END

call whitespace#setup()
