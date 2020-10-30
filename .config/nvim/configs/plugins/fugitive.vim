""---------------------------------------------------------------------------//
" FUGITIVE
""---------------------------------------------------------------------------//
function s:create_new_branch() abort
  " TODO add a new line at the end of the input
  " consider highlighting for bonus point
  let branch = input("Enter new branch name: ")
  if strlen(branch)
    redraw " clear the input message we just added
    execute 'Git checkout -b ' . branch
  endif
endfunction

function! s:setup() abort
  nnoremap <expr><buffer> } filter([search('\%(\_^#\?\s*\_$\)\\|\%$', 'W'), line('$')], 'v:val')[0].'G'
  nnoremap <expr><buffer> { max([1, search('\%(\_^#\?\s*\_$\)\\|\%^', 'bW')]).'G'

  if expand('%') =~# 'COMMIT_EDITMSG'
    setlocal spell
    " delete the commit message storing it in "g, and go back to Gstatus
    nnoremap <silent><buffer> Q gg"gd/#<cr>:let @/=''<cr>:<c-u>wq<cr>:Gstatus<cr>:call histdel('search', -1)<cr>
    " Restore register "g
    nnoremap <silent><buffer> <leader>u gg"gP
  endif
endfunction

command! -nargs=0 Gcm :G checkout master
command! -nargs=1 Gcb :G checkout -b <q-args>

" Open list of changed files and diff them with [q ]q in the quickfix list
" https://github.com/tpope/vim-fugitive/issues/132
command! DiffHistory call s:view_git_history()

function! s:view_git_history() abort
  Git difftool --name-only ! !^@
  call s:diff_current_quickfix_entry()
  " Bind <CR> for current quickfix window to properly set up diff split layout after selecting an item
  " There's probably a better way to map this without changing the window
  copen
  nnoremap <buffer> <CR> <CR><BAR>:call <sid>diff_current_quickfix_entry()<CR>
  wincmd p
endfunction

function s:diff_current_quickfix_entry() abort
  " Cleanup windows
  for window in getwininfo()
    if window.winnr !=? winnr() && bufname(window.bufnr) =~? '^fugitive:'
      exe 'bdelete' window.bufnr
    endif
  endfor
  cc
  " Ignore the cursor moved autocommand which will trigger a preview
  call s:add_mappings()
  let qf = getqflist({'context': 0, 'idx': 0})
  if get(qf, 'idx') && type(get(qf, 'context')) == type({}) && type(get(qf.context, 'items')) == type([])
    let diff = get(qf.context.items[qf.idx - 1], 'diff', [])
    echom string(reverse(range(len(diff))))
    for i in reverse(range(len(diff)))
      exe (i ? 'leftabove' : 'rightbelow') 'vert diffsplit' fnameescape(diff[i].filename)
      call s:add_mappings()
    endfor
  endif
endfunction

function! s:add_mappings() abort
  nnoremap <buffer>]q :cnext <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer>[q :cprevious <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  " Reset quickfix height. Sometimes it messes up after selecting another item
  11copen
  wincmd p
endfunction

"Fugitive bindings
nnoremap <silent><localleader>gs  :Git<CR>
"Stages the current file
nnoremap <silent><localleader>gw  :Gwrite<CR>
"Revert current file to last checked in version
nnoremap <silent><localleader>gre :Gread<CR>
"Remove the current file and the corresponding buffer
nnoremap <silent><localleader>grm :GRemove<CR>
" See in a side window who is responsible for lines of code
" can also set the date=relative but this breaks rendering
" and shortcuts
nnoremap <silent><localleader>gbl :Git blame --date=short<CR>
" Blame specific visual range
vnoremap <silent><localleader>gbl :Gblame --date=short<CR>
nnoremap <silent><localleader>gd  :Gdiffsplit<CR>
nnoremap <silent><localleader>gdt :G difftool<CR>
nnoremap <silent><localleader>gda :G difftool -y<CR>
nnoremap <silent><localleader>gc  :Git commit<CR>
nnoremap <silent><localleader>gcl  :Gclog!<CR>
nnoremap <silent><localleader>gcm :Gcm<CR>
nnoremap <silent><localleader>gn  :call <SID>create_new_branch()<CR>
nnoremap <silent><localleader>gm  :Git mergetool<CR>
" command is not silent as this obscures the preceding command
" also not the use of <c-z> the wildcharm character to trigger completion
nnoremap <localleader>go :Git checkout<space><C-Z>

augroup vimrc_fugitive
  autocmd!
  autocmd FileType gitcommit call s:setup()
augroup END
