" Plugin file for terminal.vim
" see: autoload/terminal.vim for more details

let g:terminal_rootmarkers = ['.git', '.svn', '.hg']

augroup ToggleTerminal
  autocmd!
  autocmd BufEnter term://*toggleterm#* call terminal#check_last_window()
  autocmd TermOpen term://*toggleterm#* lua require'toggle_term'.on_term_open()
  autocmd TermEnter term://*toggleterm#* call s:setup_toggle_term_maps()
augroup END

command! -count ToggleTerm lua require'toggle_term'.toggle(<count>, 12)

function s:setup_toggle_term_maps() abort
  tnoremap <silent><c-\> <C-\><C-n>:exe v:count1 . "ToggleTerm"<CR>
endfunction
" v:count1 defaults the count to 1 but if a count is passed in uses that instead
" <c-u> allows passing along the count
nnoremap <silent><c-\> :<c-u>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-\> <Esc>:<c-u>exe v:count1 . "ToggleTerm"<CR>

command! TermGitPush call terminal#exec("git push", 12)
command! TermGitPushF call terminal#exec("git push -f", 12)
