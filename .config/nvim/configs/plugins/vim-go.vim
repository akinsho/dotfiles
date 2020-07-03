"---------------------------------------------------------------------------//
" VIM-GO
"---------------------------------------------------------------------------//
let g:go_highlight_types                 = 1
let g:go_highlight_fields                = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments  = 0
let g:go_highlight_generate_tags         = 1
let g:go_def_mapping_enabled             = 0
let g:go_highlight_functions             = 1
let g:go_highlight_methods               = 1
let g:go_highlight_extra_types           = 1
let g:go_highlight_structs               = 1
let g:go_highlight_operators             = 1
let g:go_highlight_build_constraints     = 1
let g:go_highlight_function_arguments    = 1
let g:go_highlight_function_calls        = 1

if !PluginLoaded('vim-go')
  finish
endif

" "auto format with goimports as well as gofmt
let g:go_fmt_command                    = "goimports"

let g:go_gopls_enabled                  = 0
let g:go_gopls_complete_unimported      = 1
let g:go_gopls_options                  = ['-remote=auto']
let g:go_gopls_deep_completion          = 1
let g:go_gopls_staticcheck              = 1
" let g:go_def_mode                       = 'gopls'
" let g:go_info_mode                      = 'gopls'
" let g:go_referrers_mode                 = 'gopls'

let g:go_doc_popup_window                = 1
let g:go_highlight_space_tab_error       = 1
let g:go_term_enabled                    = 0
let g:go_term_close_on_exit              = 1
let g:go_term_height                     = 20
let g:go_term_width                      = 50
let g:go_auto_type_info                  = 0
let g:go_auto_sameids                    = 0
let g:go_fmt_autosave                    = 1
let g:go_def_reuse_buffer                = 1
let g:go_doc_keywordprg_enabled          = 0 "Stops auto binding K

let g:go_diagnostics_enabled             = 0
let g:go_highlight_diagnostic_warnings   = 1 " Coc handles diagnostics
let g:go_metalinter_autosave             = 0
let g:go_jump_to_error                   = 0
" let g:go_metalinter_autosave_enabled     = ['vet', 'errcheck', 'ineffassign']

" ---------------------------------------------------
" VIM-GO !!!
" ---------------------------------------------------
nmap <silent><leader>d <Plug>(go-doc)
nmap <silent><localleader>t  <Plug>(go-test)
nmap <silent><localleader>r  <Plug>(go-run)
nmap <silent><localleader>b <Plug>(go-build)
nmap <silent><localleader>i <Plug>(go-info)
" ---------------------------------------------------
" Open Alternate files
" ---------------------------------------------------
nnoremap <silent><leader>a  :A<CR>
nnoremap <silent><leader>A  :A!<CR>
nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>as :AS<CR>
nnoremap <silent><leader>at :AT<CR>

nnoremap <silent><leader>fs :GoFillStruct<CR>
nnoremap <silent><leader>er :GoIfErr<CR>

command! -bang A call go#alternate#Switch(<bang>0, 'edit')
command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
command! -bang AS call go#alternate#Switch(<bang>0, 'split')
command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
