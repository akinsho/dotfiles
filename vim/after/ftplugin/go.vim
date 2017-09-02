setlocal iskeyword+="
setlocal noexpandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal listchars+=tab:\ \ 
" ---------------------------------------------------
" VIM-GO !!!
" ---------------------------------------------------
nmap <leader>t  <Plug>(go-test)
nmap <Leader>d <Plug>(go-doc)
nmap <leader>r  <Plug>(go-run)
nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
nmap <Leader>i <Plug>(go-info)
" ---------------------------------------------------
" Open Alternate files 
" ---------------------------------------------------
nnoremap <leader>a  :A<CR>
nnoremap <leader>av :AV<CR>
nnoremap <leader>as :AS<CR>
nnoremap <leader>at :AT<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

command! -bang A call go#alternate#Switch(<bang>0, 'edit')
command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
command! -bang AS call go#alternate#Switch(<bang>0, 'split')
command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
