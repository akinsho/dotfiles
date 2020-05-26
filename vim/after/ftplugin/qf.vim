setlocal nonumber
setlocal norelativenumber
setlocal nowrap
setlocal winfixheight
setlocal colorcolumn=
set nobuflisted " I don't want quickfix buffers to pop up when doing :bn or :bp
if has('nvim')
  highlight link QuickFixLine CursorLine
endif

" Extracted from vim-qf, function to show the current qf entry in the preview window
" https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22
function s:preview_file_under_cursor() abort
  let cur_list = getqflist()
  let cur_line = getline(line('.'))
  let cur_file = fnameescape(substitute(cur_line, '|.*$', '', ''))
  if cur_line =~ '|\d\+'
    let cur_pos  = substitute(cur_line, '^\(.\{-}|\)\(\d\+\)\(.*\)', '\2', '')
    execute "pedit +" . cur_pos . " " . cur_file
  else
    execute "pedit " . cur_file
  endif
endfunction

function! s:smart_close()
  pclose!
  if winnr('$') != 1
    close
  endif
endfunction

nnoremap <silent><buffer> <c-p> <up>
nnoremap <silent><buffer> <c-n> <down>
nnoremap <silent><nowait><buffer> p :call <SID>preview_file_under_cursor()<CR>
nnoremap <silent><nowait><buffer> q :call <SID>smart_close()<CR>
