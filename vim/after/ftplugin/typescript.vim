setl foldenable
set foldopen=all
setl foldmethod=syntax foldlevelstart=99
setl completeopt-=preview
setl colorcolumn=100
set suffixesadd+=.ts
set suffixesadd+=.tsx

nnoremap gd :TSDef<CR>
nnoremap <leader>d :TSDef<CR>
nnoremap <localleader>p :TSDefPreview<CR>
nnoremap <localleader>r :TSRefs<CR>
nnoremap <localleader>t :TSType<CR>
nnoremap <localleader>c :TSEditConfig<CR>
nnoremap <localleader>i :TSImport<CR>
nnoremap <localleader>s :TSGetDocSymbols<CR>
nnoremap <leader>jr :call akin#JSXEncloseReturn()<CR>
nnoremap vat :call akin#JSXSelectTag()<CR>
nnoremap mT :!mocha %<CR>

syn region foldImports start="import" end=/import.*\n^$/ fold keepend

" Set a nicer foldtext function
set foldtext=TypescriptFold()
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
  let sub = sub . "                                                                                                                  "

  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction
