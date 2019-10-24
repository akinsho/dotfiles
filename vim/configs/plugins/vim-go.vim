"---------------------------------------------------------------------------//
" VIM-GO
"---------------------------------------------------------------------------//
" "auto format with goimports as well as gofmt
let g:go_fmt_command                    = "goimports"
let g:go_fmt_options = {
  \ 'goimports': '-local github.com/monzo/wearedev',
  \ }

let g:go_doc_popup_window               = 1
let g:go_highlight_space_tab_error      = 1
let g:go_gocode_unimported_packages     = 1
let g:go_term_enabled                   = 0
let g:go_term_close_on_exit             = 1
let g:go_term_height                    = 20
let g:go_term_width                     = 50
let g:go_auto_type_info                 = 0
let g:go_auto_sameids                   = 0
let g:go_fmt_autosave                   = 1
let g:go_doc_keywordprg_enabled         = 0 "Stops auto binding K
let g:go_highlight_types                = 1
let g:go_highlight_fields               = 1
let g:go_highlight_variable_declarations = 0
let g:go_highlight_variable_assignments = 1
let g:go_highlight_generate_tags        = 1
let g:go_def_reuse_buffer               = 1
let g:go_highlight_functions            = 1
let g:go_highlight_methods              = 1
let g:go_highlight_extra_types          = 1
let g:go_highlight_structs              = 1
let g:go_highlight_operators            = 1
let g:go_highlight_build_constraints    = 1
let g:go_highlight_function_arguments   = 1
let g:go_highlight_function_calls       = 1
let g:go_metalinter_autosave            = 1
let g:go_jump_to_error                  = 0
let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'errcheck', 'ineffassign']
