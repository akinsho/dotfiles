setlocal iskeyword+=:,#
setlocal foldmethod=marker
nnoremap <silent><buffer><leader>so :source % <bar> :lua vim.notify('Sourced ' .. vim.fn.expand('%'))<CR>
