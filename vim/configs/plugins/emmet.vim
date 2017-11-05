""---------------------------------------------------------------------------//
"                    EMMET for Vim
""---------------------------------------------------------------------------//
let g:user_emmet_mode         = 'a'
let g:user_emmet_complete_tag = 1
let g:user_emmet_settings     = {
      \ 'html': { 'empty_element_suffix': ' />'  },
      \'javascript': {'extends': 'jsx', 'empty_element_suffix': ' />',
      \},
      \'typescript':{'extends': 'tsx', 'empty_element_suffix': ' />'}
      \}
let g:user_emmet_leader_key     = "<C-Y>"
let g:user_emmet_expandabbr_key =  "<C-Y>"
let g:user_emmet_install_global = 0
