setl completeopt-=preview
match Error /\%80v.\+/

setlocal foldlevel=4

let b:switch_custom_definitions =
      \ [
      \   {
      \     '<div\(.\{-}\)>\(.\{-}\)</div>': '<span\1>\2</span>',
      \     '<span\(.\{-}\)>\(.\{-}\)</span>': '<div\1>\2</div>',
      \   }
      \ ]

let g:vim_jsx_pretty_colorful_config = 1
