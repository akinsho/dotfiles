setlocal iskeyword+=:,#
setlocal foldmethod=marker
nnoremap <silent><leader>pi :PlugInstall<CR>
nnoremap <silent><leader>ps :PlugStatus<CR>
nnoremap <silent><leader>pc :PlugClean<CR>
nnoremap <silent><leader>pu :PlugUpdate<CR>
nnoremap <silent><leader>so :source %<CR>
