if !PluginLoaded('indentLine')
  finish
endif

let s:gui_color = synIDattr(hlID('Comment'), 'fg')

let g:indentLine_fileTypeExclude = ['vimwiki', 'markdown', 'json', 'txt']
let g:indentLine_bufNameExclude  = ['Startify', 'terminal', 'peekabo']
let g:indentLine_bufTypeExclude  = ['help', 'terminal', 'nofile', 'vimwiki']
let g:indentLine_faster          = 1
let g:indentLine_setConceal      = 1
" I specifically set the colours here as the conceal highlight's default does sets
" the foreground colour to the same as the background so it adds "patches" to the cursor line
let g:indentLine_setColors       = 1
let g:indentLine_char            = '│'
let g:indentLine_color_gui       = s:gui_color

nnoremap <leader>il :IndentLinesToggle<CR>
