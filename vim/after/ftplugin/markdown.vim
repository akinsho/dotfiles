setlocal spell spelllang=en_gb "Detect .md files as mark down
setlocal expandtab

onoremap <buffer>ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
onoremap <buffer>ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
onoremap <buffer>aa :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>
onoremap <buffer>ia :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>
nnoremap <buffer><silent> gy :Goyo<CR>
if PluginLoaded("markdown-preview.nvim")
  nmap <localleader>p <Plug>MarkdownPreviewToggle
endif

nnoremap <leader>t :s/\(\s*\)\[ \]/\1\[x\]/<cr>
nnoremap <leader>T :s/\(\s*\)\[x\]/\1\[ \]/<cr>
