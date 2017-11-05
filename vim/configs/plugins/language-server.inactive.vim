let g:LanguageClient_serverCommands = {
      \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
      \ 'javascript': ['/usr/local/lib/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js'],
      \ 'javascript.jsx': ['/usr/local/lib/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js'],
      \ 'typescript': ['/usr/local/lib/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js'],
      \ 'typescript.tsx': ['/usr/local/lib/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js'],
      \ 'html': ['html-languageserver', '--stdio'],
      \ 'css': ['css-languageserver', '--stdio'],
      \ 'sass': ['css-languageserver', '--stdio'],
      \ 'scss': ['css-languageserver', '--stdio'],
      \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_selectionUI="fzf"

nnoremap <silent> <localleader>K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
