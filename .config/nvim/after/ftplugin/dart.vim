setlocal foldmethod=manual " Leave folding to Coc

" Open flutter only commands in dart files
nnoremap <silent> <leader>dc  :CocList --input=flutter commands<CR>
nnoremap <silent> <leader>de  :CocCommand flutter.emulators<CR>
nnoremap <silent> <leader>dl  :CocCommand flutter.dev.openDevLog<CR>
nnoremap <silent> <leader>do  :CocCommand flutter.toggleOutline<CR>
nnoremap <silent> <leader>drn  :CocCommand flutter.run<CR>
nnoremap <silent> <leader>drs  :CocCommand flutter.dev.hotRestart<CR>
nnoremap <silent> <leader>dd  :CocCommand flutter.devices<CR>

let g:which_leader_key_map.d = { 'name': '+dart' }
let g:which_leader_key_map.d.c  = 'flutter: commands'
let g:which_leader_key_map.d.e  = 'flutter: emulators'
let g:which_leader_key_map.d.l = 'flutter: dev log'
let g:which_leader_key_map.d.r = {
      \ 'name': '+dev-server',
      \ 'n': 'run',
      \ 's': 'restart'
      \}
let g:which_leader_key_map.d.o  = 'flutter: outline'
let g:which_leader_key_map.d.d  = 'flutter: devices'
