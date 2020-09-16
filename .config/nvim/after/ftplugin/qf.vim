" Resources and inspiration
" 1. https://github.com/ronakg/quickr-preview.vim/blob/357229d656c0340b096a16920e82cff703f1fe93/after/ftplugin/qf.vim#L215
" 2. https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22

" Autosize quickfix to match its minimum content
" https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
function! s:adjust_height(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" force quickfix to open beneath all other splits
wincmd J

call s:adjust_height(1, 10)
setlocal nonumber
setlocal norelativenumber
setlocal nowrap
setlocal winfixheight
setlocal colorcolumn=
set nobuflisted " quickfix buffers should notpop up when doing :bn or :bp
if has('nvim')
  highlight! link QuickFixLine CursorLine
endif

function s:preview_matches(lnum) abort
  set eventignore+=all
  " Go to preview window
  keepjumps wincmd P
  " highlight the line
  execute 'match Search /\%'.a:lnum.'l^\s*\zs.\{-}\ze\s*$/'
  " go back to the quickfix
  keepjumps wincmd p
  keepjumps wincmd J
  set eventignore-=all
endfunction

function s:preview_file_under_cursor() abort
  let cur_list = getqflist()
  " get the qf entry for the current line which includes the line number
  " and the buffer number. Using those open the preview window to the specific
  " position
  let entry = cur_list[line('.') - 1]
  execute "pedit +" . entry.lnum . " " . bufname(entry.bufnr)
  call s:preview_matches(entry.lnum)
  call s:adjust_height(1, 10)
endfunction

function! s:smart_close()
  pclose!
  if winnr('$') != 1
    close
  endif
endfunction

" Remove the current line from the qflist
" https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
nnoremap <buffer> <silent> dd
      \ <Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r')<CR>
nnoremap <silent><buffer> <c-p> <up><bar>:call <SID>preview_file_under_cursor()<CR>
nnoremap <silent><buffer> <c-n> <down><bar>:call <SID>preview_file_under_cursor()<CR>
nnoremap <silent><nowait><buffer> p :call <SID>preview_file_under_cursor()<CR>
nnoremap <silent><nowait><buffer> P :pclose<CR>
nnoremap <silent><nowait><buffer> q :call <SID>smart_close()<CR>
