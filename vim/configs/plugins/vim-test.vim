" VIM-TEST {{{
""---------------------------------------------------------------------------//
" this can be in the project-local .vimrc
function! TypeScriptTransform(cmd) abort
  return substitute(a:cmd, 'src/\vtest/(\S+)\.ts', 'build/test/\1.js','g')
endfunction

let g:test#custom_transformations = {"typescript": function("TypeScriptTransform")}
let g:test#transformation = "typescript"
let test#neovim#term_position = "vsplit"
" exists(':Tnew') ? "neoterm" : 
let test#strategy = has('nvim') ? 'neovim' : 'vimterminal'

nnoremap <silent> t<C-w> :TestNearest --watch<CR>
nnoremap <silent> t<C-n> :TestNearest<CR>
nnoremap <silent> t<C-f> :TestFile<CR>
nnoremap <silent> t<C-s> :TestSuite<CR>
nnoremap <silent> t<C-l> :TestLast<CR>
nnoremap <silent> t<C-g> :TestVisit<CR>
"}}}
