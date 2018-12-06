" Bookmark shortcut
nnoremap <silent> <c-b> :Bookmark<CR>
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1


let b:undo_ftplugin = ""
if !exists("g:no_plugin_maps") && !exists("g:no_nerdtree_maps")
  nmap <buffer> <silent> <Esc> :NERDTreeClose<CR>
  nmap <buffer> <silent> <CR> <CR>
  let b:undo_ftplugin = "silent! iunmap! <buffer> <Esc>"
endif
" vim:set sts=2 sw=2:
