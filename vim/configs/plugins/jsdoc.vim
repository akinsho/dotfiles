let g:jsdoc_allow_input_prompt      = 0
let g:jsdoc_input_description       = 1
let g:jsdoc_additional_descriptions = 1
let g:jsdoc_underscore_private      = 1
let g:jsdoc_enable_es6              = 1

nmap <silent> <localleader>l ?function<cr>:noh<cr><Plug>(jsdoc)
