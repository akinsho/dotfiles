if !PluginLoaded('vim-test')
  finish
endif

if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "vimterminal"
endif
let test#neovim#term_position = "vert botright"

nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>ts :TestSuite<CR>
