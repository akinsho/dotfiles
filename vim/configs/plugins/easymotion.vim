""---------------------------------------------------------------------------//
"EasyMotion mappings
""---------------------------------------------------------------------------//
let g:EasyMotion_prompt = 'Jump to → '
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
map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" easymotion with hjkl keys
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" map <Leader>l <Plug>(easymotion-lineforward)
" map <Leader>h <Plug>(easymotion-linebackward)
nnoremap <leader>/ /
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  <leader>n <Plug>(easymotion-next)
map  <leader>N <Plug>(easymotion-prev)
"}}}
