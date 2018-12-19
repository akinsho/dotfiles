""---------------------------------------------------------------------------//
"Indent Guide
""-------------------------------------------------------------------------//
let g:indentLine_bufNameExclude = [
      \ 'NERD_tree.*',
      \ 'Startify',
      \ 'terminal',
      \ 'help',
      \ 'magit',
      \ 'peekabo'
      \]
let g:indentLine_bufTypeExclude = ['help', 'terminal', 'nofile']

let g:indentLine_faster         = 1
let g:indentLine_setConceal     = 1
let g:indentLine_setColors      = 1
" the option below shows indent line even on the currently selected line
" let g:indentLine_concealcursor = ''
" let g:indentLine_color_gui = '#535354'
" let g:indentLine_color_gui = '#98C379'
" let g:indentLine_color_term    = 239
" Character options - ┊ ︙
let g:indentLine_char          = '│'
nnoremap <leader>il :IndentLinesToggle<CR>
