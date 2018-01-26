set noruler
set laststatus=0

let g:ale_set_signs                     = 1
let g:ale_open_list                     = 0
let g:ale_echo_cursor                   = 1
let g:ale_set_highlights                = 0
let g:gitgutter_sign_added              = '+'
let g:ale_sign_error                    = '❗'
let g:nvim_typescript#type_info_on_hold = 0
" let g:indentLine_enabled = 0
set noshowcmd

augroup DisabledDeoplete
  au!
  autocmd FileType typescript,typescript.tsx let b:deoplete_disable_auto_complete = 1
  autocmd FileType javascript,javascript.jsx let b:deoplete_disable_auto_complete = 1
  autocmd FileType css,less,scss let b:deoplete_disable_auto_complete = 1
augroup END


unmap /
