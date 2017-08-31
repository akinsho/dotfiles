  setl nonumber winfixwidth colorcolumn=
  augroup Quit
    au!
    au FileType help VimLeave :q<CR>
  augroup END
