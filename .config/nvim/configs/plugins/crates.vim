if !PluginLoaded("vim-crates") || !has('nvim')
  finish
endif


highlight Crates guibg=green guifg=yellow

augroup CratesToggle
  au!
  autocmd BufRead Cargo.toml silent! call crates#toggle()
augroup end
