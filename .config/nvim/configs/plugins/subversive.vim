if !PluginLoaded('vim-subversive')
  finish
endif
" s for substitute
nmap <leader>s <plug>(SubversiveSubstitute)
nmap <leader>ss <plug>(SubversiveSubstituteLine)
nmap <leader>S <plug>(SubversiveSubstituteToEndOfLine)
