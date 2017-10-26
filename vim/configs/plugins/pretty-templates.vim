""---------------------------------------------------------------------------//
" Pretty templates
""---------------------------------------------------------------------------//
" Register tag name associated the filetype
call jspretmpl#register_tag('gql', 'graphql')
augroup JSTempl
  autocmd!
  "TODO: This should be in local vimrc as I might want to highlight html
  autocmd FileType javascript,typescript JsPreTmpl graphql
augroup END
