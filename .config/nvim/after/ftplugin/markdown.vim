setlocal spell spelllang=en_gb
" no distractions in markdown files
setlocal nonumber norelativenumber

onoremap <buffer>ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
onoremap <buffer>ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
onoremap <buffer>aa :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>
onoremap <buffer>ia :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>

if v:lua.as.plugin_loaded("markdown-preview.nvim")
  nmap <buffer> <localleader>p <Plug>MarkdownPreviewToggle
endif

if v:lua.as.plugin_loaded("nvim-cmp")
lua << EOF
local cmp = require('cmp')
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
    { name = 'dictionary' },
    { name = 'spell' },
    { name = 'emoji' },
  }, {
    { name = 'buffer' },
  }),
})
EOF
endif
