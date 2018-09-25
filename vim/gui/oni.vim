set noruler
set laststatus=0

let g:ale_fix_on_save                   = 1
let g:ale_set_signs                     = 1
let g:ale_echo_cursor                   = 1
let g:ale_set_highlights                = 0
let g:ale_sign_error                    = '❗'
let g:nvim_typescript#type_info_on_hold = 0
let g:startify_change_to_vcs_root       = 0
let g:startify_disable_at_vimenter      = 1
set noshowcmd

augroup DisabledAle
  au!
  autocmd FileType typescript,typescript.tsx,javascript,javascript.jsx,json,graphql,markdown
        \ let g:ale_linters = {
        \   'typescript': ['tslint'],
        \}
        " \ let g:ale_fix_on_save = 0
augroup END


unmap /
