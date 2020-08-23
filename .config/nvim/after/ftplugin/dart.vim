setlocal foldmethod=manual " Leave folding to Coc

" Open flutter only commands in dart files
nnoremap <silent><localleader>dc  :CocList --input=flutter commands<CR>
nnoremap <silent><localleader>de  :CocCommand flutter.emulators<CR>
nnoremap <silent><localleader>dl  :CocCommand flutter.dev.openDevLog<CR>
nnoremap <silent><localleader>do  :CocCommand flutter.toggleOutline<CR>
nnoremap <silent><localleader>drn  :CocCommand flutter.run<CR>
nnoremap <silent><localleader>drs  :CocCommand flutter.hotRestart<CR>
nnoremap <silent><localleader>dd  :CocCommand flutter.devices<CR>

" this might be loaded outside of normal config e.g. minimal vimrc
" so check that everything is in place for the following block to run
if exists('*PluginLoaded') && PluginLoaded("vim-which-key")
  let g:which_localleader_key_map.d = { 'name': '+dart' }
  let g:which_localleader_key_map.d.c  = 'flutter: commands'
  let g:which_localleader_key_map.d.e  = 'flutter: emulators'
  let g:which_localleader_key_map.d.l = 'flutter: log'
  let g:which_localleader_key_map.d.r = {
        \ 'n': 'run',
        \ 's': 'restart'
        \}
  let g:which_localleader_key_map.d.o  = 'flutter: outline'
  let g:which_localleader_key_map.d.d  = 'flutter: phone (devices)'
endif
