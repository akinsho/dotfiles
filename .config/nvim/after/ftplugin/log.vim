" wrapping is expensive don't do it for huge log files
if line("$") > 10000 || expand('%:t') == 'lsp.log'
  setlocal nowrap
else
  setlocal wrap
endif


setlocal colorcolumn=
setlocal nolist
setlocal nonumber norelativenumber
setlocal signcolumn=yes:2
