" Plugin file for terminal.vim
" see: autoload/terminal.vim for more details

let g:terminal_rootmarkers = ['.git', '.svn', '.hg']

augroup ToggleTerminal
  autocmd!
  autocmd BufEnter term://*toggleterm call terminal#check_last_window()
  autocmd TermOpen term://*toggleterm call terminal#restore_terminal()
  autocmd TermEnter term://*toggleterm call s:setup_toggle_term_maps()
augroup END

function s:setup_toggle_term_maps() abort
  tnoremap <silent><c-\> <C-\><C-n>:call terminal#toggle(10)<CR>
endfunction

nnoremap <silent><c-\> :call terminal#toggle(10)<CR>
inoremap <silent><c-\> <Esc>:call terminal#toggle(10)<CR>
nnoremap <silent><localleader>gp :call terminal#exec("git push", 12)<CR>
nnoremap <silent><localleader>gpf :call terminal#exec("git push -f")<CR>
nnoremap <silent><localleader>ht :call terminal#exec("htop", 40)<CR>
