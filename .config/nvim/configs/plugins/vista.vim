if !PluginLoaded("vista.vim")
  finish
endif

let g:vista_disable_statusline = 1
let g:vista_vimwiki_executive = "markdown"
" FIXME raise issue because 'floating_win' option causes cursor to misbehave
let g:vista_echo_cursor_strategy = "floating_win"

if PluginLoaded("coc.nvim")
  let g:vista_default_executive = "coc"
endif

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_sidebar_keepalt = 1

nnoremap <silent> <leader>v :Vista!!<CR>
