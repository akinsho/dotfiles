if !PluginLoaded('vim-easymotion')
  finish
endif
""---------------------------------------------------------------------------//
"EasyMotion mappings
""---------------------------------------------------------------------------//
let g:EasyMotion_do_mapping       = 0
let g:EasyMotion_startofline      = 0
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_use_smartsign_us = 1
omap t <Plug>(easymotion-bd-tl)
omap T <Plug>(easymotion-bd-tl)
omap f <Plug>(easymotion-bd-f)

" nmap s <Plug>(easymotion-s)
" Jump to anywhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
map <leader>s <Plug>(easymotion-f)
nmap <leader>s <Plug>(easymotion-overwin-f)
" Move to line
map <leader>L <Plug>(easymotion-bd-jk)
nmap <leader>L <Plug>(easymotion-overwin-line)
map  <leader>/ <Plug>(easymotion-sn)
omap <leader>/ <Plug>(easymotion-tn)
