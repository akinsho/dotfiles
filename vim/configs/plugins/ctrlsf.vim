"--------------------------------------------
" CTRLSF - CTRL-SHIFT-F
"--------------------------------------------
let g:ctrlsf_winsize      = "50%"
let g:ctrlsf_ignore_dir   = ['bower_components', 'node_modules']
let g:ctrlsf_confirm_save    = 0
let g:ctrlsf_populate_qflist = 1
nmap     <C-F>w <Plug>CtrlSFCwordExec
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>F <Plug>CtrlSFVwordPath
vmap     <C-F>f <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

function! g:CtrlSFAfterMainWindowInit()
  setl wrap nonumber norelativenumber
endfunction
