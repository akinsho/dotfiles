" VIM-TEST {{{
""---------------------------------------------------------------------------//
" this can be in the project-local .vimrc
function! TypeScriptTransform(cmd) abort
  return substitute(a:cmd, 'src/\vtest/(\S+)\.ts', 'build/test/\1.js','g')
endfunction

let g:test#custom_transformations = {"typescript": function("TypeScriptTransform")}
let g:test#transformation = "typescript"

nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>ts :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
nnoremap <silent> <localleader>tv :TestVisit<CR>
"}}}
