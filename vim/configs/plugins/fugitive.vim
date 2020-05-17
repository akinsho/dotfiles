""---------------------------------------------------------------------------//
" FUGITIVE
""---------------------------------------------------------------------------//
" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>dg :diffget<CR>
nnoremap <silent> <leader>dp :diffput<CR>
"Fugitive bindings
nnoremap <silent><leader>gs :Gstatus<CR>
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
nnoremap <silent><leader>go :Git checkout<Space>
"Open current file on github.com
nnoremap <silent><leader>gb :GBrowse<CR>
"Make it work in Visual mode to open with highlighted linenumbers
vnoremap <silent><leader>gb :GBrowse<CR>

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


augroup vimrc_fugitive
  autocmd!
  autocmd FileType gitcommit call s:setup()
augroup END
