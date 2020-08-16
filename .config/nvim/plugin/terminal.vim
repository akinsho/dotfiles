" Plugin file for terminal.vim
" see: autoload/terminal.vim for more details

let g:terminal_rootmarkers = ['.git', '.svn', '.hg']

augroup ToggleTerminal
  autocmd!
  autocmd BufEnter term://*toggleterm#* call terminal#check_last_window()
  autocmd TermOpen term://*toggleterm#* call terminal#restore_terminal()
  autocmd TermEnter term://*toggleterm#* call s:setup_toggle_term_maps()
augroup END

command! -count ToggleTerm lua require'toggleterm'.toggle(<count>, 12)

function s:setup_toggle_term_maps() abort
  tnoremap <silent><c-\> <C-\><C-n>:exe v:count1 . "ToggleTerm"<CR>
endfunction

nnoremap <silent><c-\> :exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-\> <Esc>:exe v:count1 . "ToggleTerm"<CR>

command! TermGitPush call terminal#exec("git push", 12)
command! TermGitPushF call terminal#exec("git push -f", 12)
