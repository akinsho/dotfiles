" setlocal colorcolumn=99
setlocal iskeyword+=:,#
setlocal tags=$HOME/.config/nvim/tags
setlocal foldmethod=marker
setlocal foldlevelstart=0
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>ps :PlugStatus<CR>
nnoremap <leader>pc :PlugClean<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>so :source %<CR>
set foldopen=all " Open folds when you move over them
set foldclose=all " Close folds when you leave them
