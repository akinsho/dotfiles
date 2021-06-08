" Autosize quickfix to match its minimum content
" https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
function! s:adjust_height(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" force quickfix to open beneath all other splits
wincmd J

setlocal nowrap
setlocal signcolumn=yes
setlocal colorcolumn=
set nobuflisted " quickfix buffers should not pop up when doing :bn or :bp
call s:adjust_height(1, 10)
setlocal winfixheight

highlight! link QuickFixLine CursorLine
"--------------------------------------------------------------------------------
" Helper functions
"--------------------------------------------------------------------------------
nnoremap <silent><buffer>dd :call utils#qf_delete(bufnr())<CR>
vnoremap <silent><buffer>d  :call utils#qf_delete(bufnr())<CR>
"--------------------------------------------------------------------------------
" Mappings
"--------------------------------------------------------------------------------

nnoremap <buffer> H :colder<CR>
nnoremap <buffer> L :cnewer<CR>

nnoremap <silent><buffer><nowait> P :pclose!<CR>
nnoremap <silent><buffer><nowait> p :lua require('as.quickfix').toggle()<CR>

" Resources and inspiration
" 1. https://github.com/ronakg/quickr-preview.vim/blob/357229d656c0340b096a16920e82cff703f1fe93/after/ftplugin/qf.vim#L215
" 2. https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22
