setlocal foldmethod=manual " Leave folding to Coc

" Open flutter only commands in dart files
nnoremap <silent> <leader>dc  :CocList --input=flutter commands<CR>
nnoremap <silent> <leader>de  :CocCommand flutter.emulators<CR>
nnoremap <silent> <leader>dl  :CocCommand flutter.dev.openDevLog<CR>
nnoremap <silent> <leader>dq  :CocCommand flutter.dev.quit<CR>
nnoremap <silent> <leader>do  :CocCommand flutter.toggleOutline<CR>
nnoremap <silent> <leader>drn :CocCommand flutter.run<CR>
nnoremap <silent> <leader>drs :CocCommand flutter.dev.hotRestart<CR>
nnoremap <silent> <leader>dd  :CocCommand flutter.devices<CR>

if exists('g:which_leader_key_map')
  let g:which_leader_key_map.d = {
        \ 'name': '+dart',
        \ 'c': 'flutter: commands',
        \ 'd': 'flutter: devices',
        \ 'e': 'flutter: emulators',
        \ 'l': 'flutter: dev log',
        \ 'o': 'flutter: outline',
        \ 'q': 'flutter: quit',
        \ 'r': {
        \   'name': '+dev-server',
        \   'n': 'run',
        \   's': 'restart'
        \  },
        \ }
endif
