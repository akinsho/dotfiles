if exists('g:gui_oni')
  finish
endif
let g:LanguageClient_serverCommands = {
                  \ 'reason': ['ocaml-language-server', '--stdio'],
                  \ 'ocaml': ['ocaml-language-server', '--stdio'],
                  \ 'html': ['html-languageserver', '--stdio'],
                  \ }

if executable('javascript-typescript-stdio')
      let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
      let g:LanguageClient_serverCommands["javascript.jsx"] = ['javascript-typescript-stdio']
      let g:LanguageClient_serverCommands.typescript = ['javascript-typescript-stdio']
      let g:LanguageClient_serverCommands["typescript.tsx"] = ['javascript-typescript-stdio']
endif

if executable('css-language-server')
  let g:LanguageClient_serverCommands.css = ['css-languageserver', '--stdio']
  let g:LanguageClient_serverCommands.sass = ['css-languageserver', '--stdio']
  let g:LanguageClient_serverCommands.scss = ['css-languageserver', '--stdio']
endif

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_changeThrottle = 1.5

nnoremap <silent> <localleader>K :call LanguageClient_textDocument_hover()<CR>
silent! nunmap gd
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> <localleader>ca :call LanguageClient_textDocument_codeAction()<CR>

set formatexpr=LanguageClient_textDocument_rangeFormatting()
