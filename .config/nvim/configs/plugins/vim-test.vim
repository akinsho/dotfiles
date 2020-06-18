if !has_key(g:plugs, 'vim-test')
  finish
endif

if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "vimterminal"
endif
let test#neovim#term_position = "vert botright"

nnoremap <silent> <localleader>t :TestFile<CR>
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> t<C-w> :TestNearest --watch<CR>
nnoremap <silent> t<C-s> :TestSuite<CR>
nnoremap <silent> t<C-l> :TestLast<CR>
nnoremap <silent> t<C-g> :TestVisit<CR>
