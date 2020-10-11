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
set nobuflisted " quickfix buffers should not pop up when doing :bn or :bp

if has('nvim')
  highlight! link QuickFixLine CursorLine
endif

"--------------------------------------------------------------------------------
" Helper functions
"--------------------------------------------------------------------------------
" Remove the current line from the qflist
" https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
function! s:delete_qf_entry() abort
  call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r')
endfunction

" Setup plugin for auto previewing quickfix content
call quickfix_preview#setup({ 'preview_height': 8 })
"--------------------------------------------------------------------------------
" Mappings
"--------------------------------------------------------------------------------

nnoremap <buffer> H :colder<CR>
nnoremap <buffer> L :cnewer<CR>

nnoremap <silent><buffer><nowait> p :pclose!<CR>
nnoremap <silent><nowait><buffer> q :call <SID>smart_close()<CR>
nnoremap <buffer> <silent> dd :call <SID>s:delete_qf_entry()<CR>

" Resources and inspiration
" 1. https://github.com/ronakg/quickr-preview.vim/blob/357229d656c0340b096a16920e82cff703f1fe93/after/ftplugin/qf.vim#L215
" 2. https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22
