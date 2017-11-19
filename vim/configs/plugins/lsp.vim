
let g:LanguageClient_serverCommands = {
                  \ 'reason': ['ocaml-language-server', '--stdio'],
                  \ 'ocaml': ['ocaml-language-server', '--stdio'],
                  \ 'html': ['html-languageserver', '--stdio'],
                  \ 'css': ['css-languageserver', '--stdio'],
                  \ 'sass': ['css-languageserver', '--stdio'],
                  \ 'scss': ['css-languageserver', '--stdio'],
                  \ }

if executable('javascript-typescript-stdio')
      let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
      let g:LanguageClient_serverCommands.typescript = ['javascript-typescript-stdio']
      let g:LanguageClient_serverCommands["typescript.tsx"] = ['javascript-typescript-stdio']
      let g:LanguageClient_serverCommands["javascript.jsx"] = ['javascript-typescript-stdio']
endif

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> <localleader>K :call LanguageClient_textDocument_hover()<CR>
silent! nunmap gd
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> <localleader>ca :call LanguageClient_textDocument_codeAction()<CR>

set formatexpr=LanguageClient_textDocument_rangeFormatting()
