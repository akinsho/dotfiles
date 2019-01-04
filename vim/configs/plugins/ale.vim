""---------------------------------------------------------------------------//
"     ALE
""---------------------------------------------------------------------------//
let g:ale_lint_on_enter                        = 1
let g:ale_lint_on_insert_leave                 = 0
let g:ale_fix_on_save                          = 1
let g:ale_lint_delay                           = 300
let g:ale_pattern_options = {
      \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
      \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
      \}
", 'eslint'
let g:ale_fixers = {
      \'reason':['refmt'],
      \'typescript':['prettier', 'tslint'],
      \'javascript':['prettier'], 
      \'json':'prettier',
      \'css':['prettier','stylelint'],
      \'less':['prettier', 'stylelint']
      \}

let g:ale_sh_shellcheck_options                = '-e SC2039'  " Allow local in Shell Check

" let g:ale_sign_error         = ''
" let g:ale_sign_warning       = ''
" let g:ale_sign_info          = ''
let g:ale_sign_column_always                   = 1
let g:ale_sign_error                           = '✗'
let g:ale_sign_info                            = '💡'
let g:ale_sign_warning                         = ''
let g:ale_sign_style_error                     = ''
let g:ale_sign_style_warning                   = ''
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_reason_ols_use_global                = 0
let g:ale_warn_about_trailing_whitespace       = 1
let g:ale_echo_msg_error_str                   = g:ale_sign_error
let g:ale_echo_msg_warning_str                 = g:ale_sign_warning
let g:ale_echo_msg_format                      = '[%linter% %severity%]: %(code) %%s' 
let g:ale_linters                              = {                                                           
      \'python': ['flake8'],
      \'sql': ['sqlint'],
      \'typescript':['tsserver', 'tslint'],
      \}

let g:ale_linter_aliases = {
      \ 'jsx': ['css', 'javascript'],
      \ 'tsx': ['css', 'typescript'],
      \ 'vue': ['vue', 'javascript']
      \}

let g:ale_open_list             = 0
let g:ale_keep_list_window_open = 1
let g:ale_list_window_size      = 5

nmap [a <Plug>(ale_next_wrap)
nmap ]a <Plug>(ale_previous_wrap)

let g:ale_stylus_stylelint_use_global = 0

if has('nvim-0.3.2')
  let g:ale_virtualtext_cursor = 1
  let g:ale_virtualtext_prefix = '💡'
endif

highlight ALEErrorSign guifg=red guibg=NONE
highlight ALEWarningSign guifg=yellow guibg=NONE
highlight ALEWarning gui=underline cterm=underline
highlight link ALEVirtualTextError ALEErrorSign
highlight link ALEVirtualTextWarning ALEWarningSign
