""---------------------------------------------------------------------------//
"                    EMMET for Vim
""---------------------------------------------------------------------------//
let g:user_emmet_mode         = 'a'
let g:user_emmet_complete_tag = 1

let g:user_emmet_settings     = {
      \ 'default_attributes': {
      \     'a': {'href': ''},
      \     'link': [{'rel': 'stylesheet'}, {'href': ''}],
      \ },
      \ 'html': { 'empty_element_suffix': ' />'  },
      \'javascript.jsx': {'extends': 'jsx', 'empty_element_suffix': ' />',
      \},
      \'typescript.tsx':{'extends': 'jsx', 'empty_element_suffix': ' />'}
      \}
let g:user_emmet_leader_key = '<c-space>'
let g:user_emmet_install_global = 0
