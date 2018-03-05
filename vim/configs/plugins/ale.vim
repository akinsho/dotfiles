""---------------------------------------------------------------------------//
"     ALE
""---------------------------------------------------------------------------//
" Disable linting for all minified JS files.
if has('gui_running')
  let g:ale_set_balloons                       = 1
endif
" Enable completion where available.
" let g:ale_completion_enabled                = 1
let g:ale_lint_on_enter                        = 1
let g:ale_lint_on_insert_leave                 = 1
let g:ale_fix_on_save                          = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options          =
      \'--single-quote --trailing-comma es5' "Order of arguments matters here!!
let g:ale_pattern_options =
      \{'\.min.js$': {'ale_enabled': 0},
      \'oni/.*\.ts$':{'ale_fix_on_save': 0}
      \}
let g:ale_fixers = {
      \'reason':['refmt'],
      \'typescript':['prettier', 'tslint'],
      \'javascript':['prettier', 'eslint'],
      \'json':'prettier',
      \'css':['prettier','stylelint'],
      \'less':['prettier', 'stylelint']
      \}
let g:ale_sh_shellcheck_options          = '-e SC2039' " Allow local in Shell Check
let g:ale_echo_msg_format                = '%linter%: %(code): %%s [%severity%]'
let g:ale_sign_column_always             = 1
let g:ale_sign_error                     = '✖'
let g:ale_echo_delay                     = 80
let g:ale_sign_warning                   = '❗'
let g:ale_lint_delay                     = 1000
let g:ale_warn_about_trailing_whitespace = 1
"\'css': ['stylelint'],
let g:ale_linters                     = {
      \'markdown': ['prettier'],
      \'python': ['flake8'],
      \'jsx': ['eslint'],
      \'sql': ['sqlint'],
      \'typescript':['tsserver', 'tslint'],
      \'go': ['gofmt -e', 'go vet', 'golint', 'go build', 'gosimple', 'staticcheck'],
      \'html':['tidy']
      \}
let g:ale_linter_aliases    = {'jsx': 'css', 'tsx': 'css'}
nmap [a <Plug>(ale_next_wrap)
nmap ]a <Plug>(ale_previous_wrap)
nmap [d <Plug>(ale_detail)
nmap [gd <Plug>(ale_go_to_definition)

let g:ale_stylus_stylelint_use_global = 0

augroup AleTS
  autocmd BufNewFile,BufEnter,BufRead *.ts,*.tsx
        \ let b:ale_javascript_prettier_options=
        \ '--trailing-comma --tab-width 4 all --print-width 100'
augroup END

" let g:ale_open_list             = 1
" let g:ale_keep_list_window_open = 1
" let g:ale_list_window_size      = 8
"}}}
