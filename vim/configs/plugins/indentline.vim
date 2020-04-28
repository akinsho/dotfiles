""---------------------------------------------------------------------------//
"Indent Guide
""-------------------------------------------------------------------------//
let g:indentLine_fileTypeExclude = [
      \ 'vimwiki',
      \ 'nerdtree',
      \ 'markdown',
      \ 'json',
      \ 'help'
      \]

let g:indentLine_bufNameExclude = [
      \ 'Startify',
      \ 'terminal',
      \ 'magit',
      \ 'peekabo',
      \]
let g:indentLine_bufTypeExclude = ['help', 'terminal', 'nofile']

let g:indentLine_faster         = 1
let g:indentLine_setConceal     = 1
let g:indentLine_setColors      = 1
" the option below shows indent line even on the currently selected line
" let g:indentLine_concealcursor = ''

" Character options - ┊ ︙|
" let g:indentLine_char          = '│'
let g:indentLine_char_list = ['│', '¦', '┆', '┊']
nnoremap <leader>il :IndentLinesToggle<CR>
