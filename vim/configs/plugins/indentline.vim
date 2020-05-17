if !has_key(g:plugs, 'indentLine')
  finish
endif

let g:indentLine_fileTypeExclude = [
      \ 'vimwiki',
      \ 'nerdtree',
      \ 'markdown',
      \ 'json',
      \ 'txt',
      \]

let g:indentLine_bufNameExclude = [
      \ 'Startify',
      \ 'terminal',
      \ 'magit',
      \ 'peekabo',
      \ '*.txt',
      \]

let g:indentLine_bufTypeExclude = ['help', 'terminal', 'nofile', 'vimwiki']

let g:indentLine_faster         = 1
let g:indentLine_setConceal     = 1
let g:indentLine_setColors      = 1
" the option below shows indent line even on the currently selected line
" let g:indentLine_concealcursor = ''

" Character options - '︙', '|' , '¦', '┆', '┊'
let g:indentLine_char_list = ['│']
nnoremap <leader>il :IndentLinesToggle<CR>

" FIXME
" This is a hack around the fact that this plugin is broken
" and does not respect the exclude list above
" see https://github.com/plasticboy/vim-markdown/issues/395#issuecomment-436719952
" and https://github.com/Yggdroot/indentLine/issues/303
augroup IndentLinesDisabled
  autocmd FileType help let b:indentLine_enabled = 0
augroup END
