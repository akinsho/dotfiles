set noruler
set laststatus=0

let g:ale_set_signs                     = 0
let g:ale_echo_cursor                   = 0
let g:ale_set_highlights                = 0
let g:gitgutter_sign_added              = '+'
let g:nvim_typescript#type_info_on_hold = 0

unlet! g:term_win_highlight

let g:term_win_highlight = {
      \"guibg": "black",
      \"ctermbg":"BLACK",
      \}
