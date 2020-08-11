if !PluginLoaded("nerdtree.vim")
  finish
endif
" Bookmark shortcut
nnoremap <silent> <c-b> :Bookmark<CR>

let b:undo_ftplugin = ""
if !exists("g:no_plugin_maps") && !exists("g:no_nerdtree_maps")
  nmap <buffer> <silent> <Esc> :NERDTreeClose<CR>
  let b:undo_ftplugin = "silent! iunmap! <buffer> <Esc>"
endif
