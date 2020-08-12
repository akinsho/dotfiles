setlocal iskeyword+=:,#
setlocal foldmethod=marker
nnoremap <silent><leader>so :source % <bar> :call utils#info_message('Sourced ' . expand('%'))<CR>
