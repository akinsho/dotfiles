setlocal nonumber norelativenumber nolist
setlocal colorcolumn=
setlocal concealcursor=nc

""---------------------------------------------------------------------------//
" Credit: Tweekmonster!
""---------------------------------------------------------------------------//
" if this a vim help file rather than one I'm creating add mappings otherwise do not
if expand('%') =~# '^'.$VIMRUNTIME || &readonly
  autocmd BufWinEnter <buffer> wincmd L | vertical resize 80
  nnoremap <buffer> q :<c-u>q<cr>
  nnoremap <buffer> <CR> <C-]>
  nnoremap <buffer> <BS> <C-T>
  nnoremap <silent><buffer> o /'\l\{2,\}'<CR>
  nnoremap <silent><buffer> O ?'\l\{2,\}'<CR>
  nnoremap <silent><buffer> s /\|\zs\S\+\ze\|<CR>
  nnoremap <silent><buffer> S ?\|\zs\S\+\ze\|<CR>
  finish
else
  setlocal spell spelllang=en_gb
endif

nnoremap <silent><buffer> <leader>r :<c-u>call <sid>right_align()<cr>
nnoremap <silent><buffer> <leader>ml maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a
