setlocal nolist nonumber norelativenumber
"the queen's English..
setlocal spell spelllang=en_gb
" Disable showing tabs locally
setlocal listchars=tab:\ \ ,
" Set color column at maximum commit summary length
setlocal colorcolumn=50,72

lua << EOF
if as.plugin_loaded('nvim-cmp') then
  require('cmp').setup.buffer {
    experimental = {
      ghost_text = false,
    },
  }
end
EOF
