setlocal foldtext=utils#braces_fold_text()
setl completeopt-=preview
match Error /\%80v.\+/

let b:switch_custom_definitions =
      \ [
      \   {
      \     '<div\(.\{-}\)>\(.\{-}\)</div>': '<span\1>\2</span>',
      \     '<span\(.\{-}\)>\(.\{-}\)</span>': '<div\1>\2</div>',
      \   }
      \ ]

let g:vim_jsx_pretty_colorful_config = 1
