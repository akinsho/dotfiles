" if exists("b:go_after_did_ftplugin")
"   finish
" endif
"
" let b:go_after_did_ftplugin = 1 " Don't load twice in one buffer
""---------------------------------------------------------------------------//
" GO FILE SETTINGS
""---------------------------------------------------------------------------//
setlocal noexpandtab
setlocal list listchars+=tab:\│\ "(here is a space), this is to show indent line
highlight! default link goErr WarningMsg |
      \ match goErr /\<err\>/
" ---------------------------------------------------
" VIM-GO !!!
" ---------------------------------------------------
nmap <silent><leader>d <Plug>(go-doc)
nmap <silent><localleader>t  <Plug>(go-test)
nmap <silent><localleader>r  <Plug>(go-run)
nmap <silent><localleader>b <Plug>(go-build)
nmap <silent><localleader>i <Plug>(go-info)
" ---------------------------------------------------
" Open Alternate files
" ---------------------------------------------------
nnoremap <silent><leader>a  :A<CR>
nnoremap <silent><leader>A  :A!<CR>
nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>as :AS<CR>
nnoremap <silent><leader>at :AT<CR>

nnoremap <silent><leader>fs :GoFillStruct<CR>
nnoremap <silent><leader>er :GoIfErr<CR>

command! -bang A call go#alternate#Switch(<bang>0, 'edit')
command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
command! -bang AS call go#alternate#Switch(<bang>0, 'split')
command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
