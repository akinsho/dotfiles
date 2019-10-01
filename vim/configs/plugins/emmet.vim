""---------------------------------------------------------------------------//
"                    EMMET for Vim
""---------------------------------------------------------------------------//
let g:user_emmet_install_global = 1
let g:user_emmet_mode           = 'a'
let g:user_emmet_complete_tag   = 1

let g:user_emmet_settings     = {
                  \ 'default_attributes': {
                  \     'a': {'href': ''},
                  \     'link': [{'rel': 'stylesheet'}, {'href': ''}],
                  \ },
                  \ 'html': { 'empty_element_suffix': ' />'  },
                  \ 'javascript': {
                  \   'extends': 'jsx', 'empty_element_suffix': ' />',
                  \},
                  \'typescript':{
                  \   'extends': 'jsx', 'empty_element_suffix': ' />'
                  \},
                  \'typescriptreact':{
                  \   'extends': 'jsx', 'empty_element_suffix': ' />'}
                  \}
