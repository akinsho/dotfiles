" set foldopen=all
setl foldenable
setl foldmethod=syntax foldlevelstart=99
setl completeopt-=preview
setl colorcolumn=100
set suffixesadd+=.ts
set suffixesadd+=.tsx

if !exists('g:gui_oni')
  nnoremap gd :TSDef<CR>
  nnoremap <leader>d :TSDef<CR>
  nnoremap <localleader>p :TSDefPreview<CR>
  nnoremap <localleader>r :TSRefs<CR>
  nnoremap <localleader>t :TSType<CR>
  nnoremap <localleader>s :TSGetDocSymbols<CR>
endif

nnoremap <localleader>c :TSEditConfig<CR>
nnoremap <localleader>i :TSImport<CR>
nnoremap <leader>jr :call lib#JSXEncloseReturn()<CR>
nnoremap vat :call lib#JSXSelectTag()<CR>
nnoremap mT :!mocha %<CR>

let g:LanguageClient_autoStart = 0
" Highlight over 80 cols in red
match Error /\%100v.\+/

syn region foldImports start="import" end=/import\s*{\?\s*/ fold keepend
" /import.*\n^$/
hi link typescriptBrowserObjects TypescriptType
" hi typescriptBrowserObjects gui=italic,bold guifg=yellow
function! SteveLoshText()
     let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction

" Set a nicer foldtext function
set foldtext=SteveLoshText()

function! TypescriptFold()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  " let sub = sub . repeat(' ', winwidth(0)-n - 7)

  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction
