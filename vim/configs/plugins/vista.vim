if !has_key(g:plugs, "vista.vim")
  finish
endif

let g:vista_echo_cursor_strategy = "floating_win"

if has_key(g:plugs, "coc.nvim")
  let g:vista_default_executive = "coc"
endif
