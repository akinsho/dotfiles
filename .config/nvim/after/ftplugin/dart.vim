setlocal foldmethod=manual " Leave folding to Coc

" Open flutter only commands in dart files
nnoremap <silent><leader>cc  :CocList --input=flutter commands<CR>
nnoremap <silent><leader>ce  :CocCommand flutter.emulators<CR>
nnoremap <silent><leader>cdr :CocCommand flutter.hotRestart<CR>
nnoremap <silent><leader>cdl :CocCommand flutter.dev.openDevLog<CR>
nnoremap <silent><leader>co  :CocCommand flutter.toggleOutline<CR>
nnoremap <silent><leader>cr  :CocCommand flutter.run<CR>
nnoremap <silent><leader>cp  :CocCommand flutter.devices<CR>

" this might be loaded outside of normal config e.g. minimal vimrc
" so check that everything is in place for the following block to run
if exists('*PluginLoaded') && PluginLoaded("vim-which-key")
  let g:which_leader_key_map.c.c  = 'flutter: commands'
  let g:which_leader_key_map.c.e  = 'flutter: emulators'
  let g:which_leader_key_map.c.dl = 'flutter: log'
  let g:which_leader_key_map.c.dr = 'flutter: restart'
  let g:which_leader_key_map.c.r  = 'flutter: run'
  let g:which_leader_key_map.c.o  = 'flutter: outline'
  let g:which_leader_key_map.c.p  = 'flutter: phone (devices)'
endif
