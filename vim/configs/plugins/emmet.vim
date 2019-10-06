""---------------------------------------------------------------------------//
"                    EMMET for Vim
""---------------------------------------------------------------------------//
let g:user_emmet_install_global = 1
let g:user_emmet_mode           = 'a'
let g:user_emmet_complete_tag   = 1
" self closing tag
" foo/<leader><tab> => <foo />
" does not work yet with non-closing html5 tags like <img>
inoremap <C-y>e <esc>:call emmet#expandAbbr(0,"")<cr>h:call emmet#splitJoinTag()<cr>wwi
nnoremap <C-y>e :call emmet#expandAbbr(0,"")<cr>h:call emmet#splitJoinTag()<cr>ww

let g:user_emmet_settings = {
  \ 'default_attributes': {
  \     'a': {'href': ''},
  \     'link': [{'rel': 'stylesheet'}, {'href': ''}],
  \ },
  \ 'html': {
  \ 'empty_element_suffix': ' />'
  \ },
  \ 'javascript': {
  \   'extends': 'jsx',
  \},
  \'typescript':{
  \   'extends': 'jsx',
  \},
  \'typescriptreact':{
  \   'extends': 'jsx'
  \}
  \}
