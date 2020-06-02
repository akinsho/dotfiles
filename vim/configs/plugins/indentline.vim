if !has_key(g:plugs, 'indentLine')
  finish
endif

let g:indentLine_fileTypeExclude = ['vimwiki', 'markdown', 'json', 'txt']
let g:indentLine_bufNameExclude  = ['Startify', 'terminal', 'peekabo']
let g:indentLine_bufTypeExclude  = ['help', 'terminal', 'nofile', 'vimwiki']
let g:indentLine_faster         = 1
let g:indentLine_setConceal     = 1
let g:indentLine_setColors      = 1
" the option below shows indent line even on the currently selected line
" let g:indentLine_concealcursor = ''

" Character options - '︙', '|' , '¦', '┆', '┊'
let g:indentLine_char_list = ['│']
nnoremap <leader>il :IndentLinesToggle<CR>
