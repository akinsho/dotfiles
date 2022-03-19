function! utils#tab_zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction

"
" Verbatim matching for *.
"
function! utils#search() abort
  let regsave = @@
  normal! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = regsave
endfunction
""---------------------------------------------------------------------------//
" Windows
""---------------------------------------------------------------------------//
" Auto resize Vim splits to active split to 70% -
" https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

let s:auto_resize_on = 0

function! utils#auto_resize(...)
  if s:auto_resize_on == 0
    let factor = get(a:, '1', 70)
    let fraction = factor / 10
    let &winheight = &lines * fraction / 10
    let &winwidth = &columns * fraction / 10
    let s:auto_resize_on = 1
    echom 'Auto resize ON'
  else
    let &winheight = 30
    let &winwidth = 30
    wincmd =
    let s:auto_resize_on = 0
    echom 'Auto resize OFF'
  endif
endfunction

"==========[ ModifyLineEndDelimiter ]==========
" Description:
"	This function takes a delimiter character and:
"	- removes that character from the end of the line if the character at the end
"	of the line is that character
"	- removes the character at the end of the line if that character is a
"	delimiter that is not the input character and appends that character to
"	the end of the line
"	- adds that character to the end of the line if the line does not end with
"	a delimiter
"
" Delimiters:
" - ","
" - ";"
"==========================================
function! utils#modify_line_end_delimiter(character)
  let line_modified = 0
  let line = getline('.')

  for character in [',', ';']
    " check if the line ends in a trailing character
    if line =~ character . '$'
      let line_modified = 1

      " delete the character that matches:

      " reverse the line so that the last instance of the character on the
      " line is the first instance
      let newline = join(reverse(split(line, '.\zs')), '')

      " delete the instance of the character
      let newline = substitute(newline, character, '', '')

      " reverse the string again
      let newline = join(reverse(split(newline, '.\zs')), '')

      " if the line ends in a trailing character and that is the
      " character we are operating on, delete it.
      if character != a:character
        let newline .= a:character
      endif

      break
    endif
  endfor

  " if the line was not modified, append the character
  if line_modified == 0
    let newline = line . a:character
  endif

  call setline('.', newline)
endfunction
"}}}

" NOTE: we define this outside of our ftplugin/qf.vim
" since that is loaded on each run of our qf window
" this means that it would be recreated each time if
" not defined separately, so on replacing the quickfix
" we would recreate this function during it's execution
" source: https://vi.stackexchange.com/a/21255
" using range-aware function
function! utils#qf_delete(bufnr) range
  " get current qflist
  let l:qfl = getqflist()
  " no need for filter() and such; just drop the items in range
  call remove(l:qfl, a:firstline - 1, a:lastline - 1)
  " replace items in the current list, do not make a new copy of it;
  " this also preserves the list title
  call setqflist([], 'r', {'items': l:qfl})
  " restore current line
  call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction
