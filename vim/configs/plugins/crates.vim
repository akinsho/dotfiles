if !has_key(g:plugs, "vim-crates") || !has('nvim')
  finish
endif


highlight link Crates Search

augroup CratesToggle
  au!
  autocmd BufRead,BufNewFile Cargo.toml call crates#toggle()
augroup end
