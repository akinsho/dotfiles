if !v:lua.plugin_loaded('vim-subversive')
  finish
endif
" s for substitute
nmap <leader>s <plug>(SubversiveSubstitute)
nmap <leader>ss <plug>(SubversiveSubstituteLine)
nmap <leader>S <plug>(SubversiveSubstituteToEndOfLine)


nmap <leader><leader>s <plug>(SubversiveSubstituteRange)
xmap <leader><leader>s <plug>(SubversiveSubstituteRange)
