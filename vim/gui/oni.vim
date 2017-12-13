set noruler
set laststatus=0

let g:ale_set_signs                     = 1
let g:ale_open_list                     = 0
let g:ale_echo_cursor                   = 1
let g:ale_set_highlights                = 0
let g:gitgutter_sign_added              = '+'
let g:ale_sign_error                    = '❗'
let g:nvim_typescript#type_info_on_hold = 0
set noshowcmd

augroup TablineHighlighting
  au!
  au Colorscheme * highlight Tabline guibg=#282c34
  au VimEnter,Colorscheme * highlight TablineFill guibg=#282c34
augroup END

