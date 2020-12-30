nnoremap <silent> <leader>v :Vista!!<CR>

if !v:lua.plugin_loaded("vista.vim")
  finish
endif

let g:vista_disable_statusline = 1
let g:vista_echo_cursor_strategy = "floating_win"

if v:lua.plugin_loaded("coc.nvim")
  let g:vista_default_executive = "coc"
endif

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_sidebar_keepalt = 1
