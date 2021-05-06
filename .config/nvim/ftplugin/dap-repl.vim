" NOTE: these can also be configured on open of the dap-repl
" but this way it will apply to all dap-repl windows automatically
" Place the REPL below all other windows
wincmd J
" Next resize the window, NOTE: do this *after* moving it
resize 12
setlocal winfixheight
setlocal nobuflisted
" Add autocompletion
lua require('dap.ext.autocompl').attach()
