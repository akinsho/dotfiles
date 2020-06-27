""---------------------------------------------------------------------------//
" FUGITIVE
""---------------------------------------------------------------------------//
" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>dg :diffget<CR>
nnoremap <silent> <leader>dp :diffput<CR>
"Fugitive bindings
nnoremap <silent><leader>gs :Git<CR>
"Stages the current file
nnoremap <silent><leader>gw :Gwrite<CR>
"Rename the current file and the corresponding buffer
nnoremap <silent><leader>gm :Gmove<Space>
"Revert current file to last checked in version
nnoremap <silent><leader>gre :Gread<CR>
"Remove the current file and the corresponding buffer
nnoremap <silent><leader>grm :GRemove<CR>
"See in a side window who is responsible for lines of code
nnoremap <silent><leader>gbl :Git blame<CR>
"Opens the index - i.e. git saved version of a file
nnoremap <silent><leader>ge :Gedit<CR>
nnoremap <silent><leader>gd :Gdiffsplit<CR>
nnoremap <silent><leader>gc :Git commit<CR>
nnoremap <silent><leader>gt :Git commit -v -q %:p<CR>
nnoremap <silent><leader>gl :Git pull<CR>
nnoremap <silent><leader>gp :Git push<CR>
nnoremap <silent><leader>gpf :Git push -f<CR>
nnoremap <silent><leader>go :Git checkout<space>
nnoremap <silent><leader>gcm :Gcm<CR>
nnoremap <silent><leader>gb :call CreateNewBranch()<CR>

function CreateNewBranch() abort
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

augroup vimrc_fugitive
  autocmd!
  autocmd FileType gitcommit call s:setup()
augroup END
