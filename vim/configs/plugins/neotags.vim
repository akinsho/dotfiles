let g:neotags_enabled          = 1
let g:neotags_patternlength    = 1024
let g:neotags#typescript#order = 'cnfmoited'

let g:neotags#typescript#c = { 'group': 'javascriptClassTag' }
let g:neotags#typescript#C = { 'group': 'javascriptConstantTag' }
let g:neotags#typescript#f = { 'group': 'javascriptFunctionTag' }
let g:neotags#typescript#o = { 'group': 'javascriptObjectTag' }


let g:neotags#typescript#n = g:neotags#typescript#C
let g:neotags#typescript#f = g:neotags#typescript#f
let g:neotags#typescript#m = g:neotags#typescript#f
let g:neotags#typescript#o = g:neotags#typescript#o
let g:neotags#typescript#i = g:neotags#typescript#C
let g:neotags#typescript#t = g:neotags#typescript#C
let g:neotags#typescript#e = g:neotags#typescript#C

let g:neotags#typescript#d = g:neotags#typescript#c

highlight link javascriptClassTag Special
highlight link javascriptConstantTag Special
highlight link FunctionTag Special
highlight link javascriptObjectTag PreProc
