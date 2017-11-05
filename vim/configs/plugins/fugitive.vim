""---------------------------------------------------------------------------//
" FUGITIVE
""---------------------------------------------------------------------------//
" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> <leader>dg :diffget<CR>
nnoremap <silent> <leader>dp :diffput<CR>
"Fugitive bindings
nnoremap <leader>gs :Gstatus<CR>
"Stages the current file
nnoremap <leader>gw :Gwrite<CR>
"Rename the current file and the corresponding buffer
nnoremap <leader>gm :Gmove<Space>
"Revert current file to last checked in version
nnoremap <leader>gre :Gread<CR>
"Remove the current file and the corresponding buffer
nnoremap <leader>grm :Gremove<CR>
"See in a side window who is responsible for lines of code
nnoremap <leader>gbl :Gblame<CR>
"Opens the index - i.e. git saved version of a file
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>ggp :Ggrep<Space>
nnoremap <leader>gbr :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gL :Glog<BAR>:bot copen<CR>
"Open current file on github.com
nnoremap <leader>gb :Gbrowse<CR>
"Make it work in Visual mode to open with highlighted linenumbers
vnoremap <leader>gb :Gbrowse<CR>

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
