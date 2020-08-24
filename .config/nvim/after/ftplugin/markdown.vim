setlocal spell spelllang=en_gb

" relates to a bug: https://github.com/sheerun/vim-polyglot/issues/290
" https://github.com/tpope/vim-sleuth/issues/43#issuecomment-447207279
let b:sleuth_automatic = 0

onoremap <buffer>ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
onoremap <buffer>ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
onoremap <buffer>aa :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>
onoremap <buffer>ia :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>
nnoremap <buffer><silent> gy :Goyo<CR>

if exists('*PluginLoaded') && PluginLoaded("markdown-preview.nvim")
  nmap <buffer> <localleader>p <Plug>MarkdownPreviewToggle
endif
