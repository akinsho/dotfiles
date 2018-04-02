set noruler
set laststatus=0

let g:ale_fix_on_save                   = 1
let g:ale_set_signs                     = 1
let g:ale_echo_cursor                   = 1
let g:ale_set_highlights                = 0
let g:gitgutter_sign_added              = '+'
let g:ale_sign_error                    = '❗'
let g:nvim_typescript#type_info_on_hold = 0
" let g:startify_disable_at_vimenter = 2
" let g:indentLine_enabled = 0
set noshowcmd

augroup DisabledDeoplete
  au!
  autocmd FileType typescript,typescript.tsx,reason let b:deoplete_disable_auto_complete = 1
  autocmd FileType javascript,javascript.jsx let b:deoplete_disable_auto_complete = 1
  autocmd FileType css,less,scss let b:deoplete_disable_auto_complete = 1
augroup END

augroup DisabledAle
  au!
  autocmd FileType typescript,typescript.tsx,javascript,javascript.jsx,json,graphql,markdown
        \ let g:ale_fix_on_save = 0
augroup END


unmap /
