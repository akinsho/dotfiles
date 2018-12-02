" Credit: Cocophon
" This function allows you to see the syntax highlight token of the cursor word and that token's links
" -> https://github.com/cocopon/pgmnt.vim/blob/master/autoload/pgmnt/dev.vim

function! token#inspect() abort
  let synid = synID(line('.'), col('.'), 1)
  let names = exists(':ColorSwatchGenerate')
        \ ? s:hi_chain_with_colorswatch(synid)
        \ : s:hi_chain(synid)
  echo join(names, ' -> ')
endfunction


function! s:hi_chain(synid) abort
  let name = synIDattr(a:synid, 'name')
  let names = []

  call add(names, name)

  let original = synIDtrans(a:synid)
  if a:synid != original
    call add(names, synIDattr(original, 'name'))
  endif

  return names
endfunction

"Displays the name of the highlight group of the selected word
function! s:SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! -nargs=0 Token call token#inspect()
nnoremap <leader>E :Token<cr>
