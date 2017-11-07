"Add Arrow functions and conceal car to typescript syntax
exe 'syntax match tsArrowFunction /=>/      skipwhite skipempty nextgroup=tsFuncBlock,tsCommentFunction                                   '.(exists('g:javascript_conceal_arrow_function') ? 'conceal cchar='.g:javascript_conceal_arrow_function : '')
exe 'syntax match tsArrowFunction /()\ze\s*=>/   skipwhite skipempty nextgroup=tsArrowFunction                                        '.(exists('g:javascript_conceal_noarg_arrow_function') ? 'conceal cchar='.g:javascript_conceal_noarg_arrow_function : '')
exe 'syntax match tsArrowFunction /_\ze\s*=>/    skipwhite skipempty nextgroup=tsArrowFunction                                        '.(exists('g:javascript_conceal_underscore_arrow_function') ? 'conceal cchar='.g:javascript_conceal_underscore_arrow_function : '')
" This a conceal char so cannot change highlight
" hi link tsArrowFunction Special

" hi typescriptFuncArg gui=italic
" hi tsArguments gui=italic,bold
