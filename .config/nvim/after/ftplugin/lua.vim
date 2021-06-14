setlocal textwidth=100
setlocal formatoptions-=o

nnoremap <buffer><silent><leader>so :execute "luafile %"
      \ <bar> :lua vim.notify('Sourced ' . expand('%'))<CR>

let b:surround_{char2nr('F')} = "function \1function: \1() \r end"
let b:surround_{char2nr('i')} = "if \1if: \1 then \r end"
