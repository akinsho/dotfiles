setlocal textwidth=100
setlocal formatoptions-=o

nnoremap <buffer><silent><leader>so :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>

let b:surround_{char2nr('F')} = "function \1function: \1() \r end"
let b:surround_{char2nr('i')} = "if \1if: \1 then \r end"
lua << EOF
if R then R('as.ftplugin.lua') end
EOF
