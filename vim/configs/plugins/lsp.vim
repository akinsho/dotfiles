if exists('g:gui_oni')
  finish
endif

  " \ 'reason': ['~/reason-language-server/reason-language-server.exe'],
let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ 'html': ['html-languageserver', '--stdio'],
    \ }

if executable('javascript-typescript-stdio')
  let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
  let g:LanguageClient_serverCommands["javascript.jsx"] = ['javascript-typescript-stdio']
endif

if executable('css-language-server')
  let g:LanguageClient_serverCommands.css = ['css-languageserver', '--stdio']
  let g:LanguageClient_serverCommands.sass = ['css-languageserver', '--stdio']
  let g:LanguageClient_serverCommands.scss = ['css-languageserver', '--stdio']
endif

if executable('flow-language-server')
  let g:LanguageClient_serverCommands.javascript = ['flow-language-server', '--stdio']
  let g:LanguageClient_serverCommands["javascript.jsx"] = ['flow-language-server', '--stdio']
endif

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

let g:LanguageClient_loggingLevel = 'DEBUG' 
let g:LanguageClient_loggingFile = '/tmp/lsp.log'

function! LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    silent! nunmap gd
    nnoremap <buffer><silent> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <buffer><silent> gd :call LanguageClient_textDocument_definition()<CR>
    nnoremap <buffer><silent> <F2> :call LanguageClient_textDocument_rename()<CR>
    nnoremap <buffer><silent> <localleader>ca :call LanguageClient_textDocument_codeAction()<CR>
  endif
endfunction

augroup LC_Mappings
  au!
  autocmd FileType * call LC_maps()
augroup END


set formatexpr=LanguageClient_textDocument_rangeFormatting()
