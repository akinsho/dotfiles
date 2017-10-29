""---------------------------------------------------------------------------//
"     ALE
""---------------------------------------------------------------------------//
" Disable linting for all minified JS files.
if has('gui_running')
  let g:ale_set_balloons                 = 1
endif
" Enable completion where available.
" let g:ale_javascript_prettier_options = '--config ~/.prettierrc'
let g:ale_lint_on_insert_leave                 = 1
let g:ale_fix_on_save                          = 1
let g:ale_lint_on_enter                        = 0
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options          =
      \'--single-quote --trailing-comma es5' "Order of arguments matters here!!
let g:ale_pattern_options                      =
      \{'\.min.js$': {'ale_enabled': 0}}
let g:ale_fixers = {
      \'typescript':['prettier', 'tslint'],
      \'javascript':['prettier', 'eslint'],
      \'json':'prettier',
      \'css':'stylelint'
      \}
let g:ale_sh_shellcheck_options          = '-e SC2039' " Allow local in Shell Check
let g:ale_echo_msg_format                = '%linter%: %s [%severity%]'
let g:ale_sign_column_always             = 1
let g:ale_sign_error                     = '✘'
let g:ale_sign_warning                   = '⚠️'
let g:ale_warn_about_trailing_whitespace = 1
"TODO: integrate stylelint
let g:ale_linters                     = {
      \'python': ['flake8'],
      \'css': ['stylelint'],
      \'jsx': ['eslint'],
      \'sql': ['sqlint'],
      \'typescript':['tsserver', 'tslint'],
      \'go': ['gofmt -e', 'go vet', 'golint', 'go build', 'gosimple', 'staticcheck'],
      \'html':[]
      \}
let g:ale_set_highlights    = 0
let g:ale_linter_aliases    = {'jsx': 'css', 'typescript.jsx': 'css'}
nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)

augroup AleTS
  autocmd BufNewFile,BufEnter,BufRead *.ts,*.tsx
        \ let b:ale_javascript_prettier_options=
        \ '--trailing-comma all --tab-width 4 --print-width 100'
augroup END

"}}}
