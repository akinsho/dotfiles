"---------------------------------------------------------------------------//
" VIM-GO
"---------------------------------------------------------------------------//
" "auto format with goimports as well as gofmt
let g:go_fmt_command                    = "goimports"

let g:go_term_height                    = 30
let g:go_term_width                     = 30
let g:go_term_mode                      = "split"
let g:go_list_type                      = "locationlist"
let g:go_auto_type_info                 = 0
let g:go_auto_sameids                   = 0
let g:go_fmt_autosave                   = 1
let g:go_alternate_mode                 = "vsplit"
let g:go_doc_keywordprg_enabled         = 0 "Stops auto binding K
let g:go_highlight_types                = 1
let g:go_highlight_fields               = 0
let g:go_highlight_variable_assignments = 1
let g:go_def_reuse_buffer               = 1
let g:go_highlight_functions            = 1
let g:go_highlight_methods              = 1
let g:go_highlight_extra_types          = 1
let g:go_highlight_structs              = 1
let g:go_highlight_operators            = 1
let g:go_highlight_build_constraints    = 1
let g:go_highlight_function_arguments   = 1
let g:go_metalinter_autosave = 1
"'vetshadow' - checks if variable names are shadowed
let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'goconst','ineffassign']
