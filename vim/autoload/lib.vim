function! lib#tab_zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction


function! lib#buf_zoom() abort
  if exists('t:zoomed') && t:zoomed
    exec t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction


" Peekabo Like functionality
function! lib#reg()
  reg
  echo "Register: "
  let char = nr2char(getchar())
  if char != "\<Esc>"
    execute "normal! \"".char."p"
  endif
  redraw
endfunction

function! JSXIsSelfCloseTag()
  let l:line_number = line(".")
  let l:line = getline(".")
  let l:tag_name = matchstr(matchstr(line, "<\\w\\+"), "\\w\\+")

  exec "normal! 0f<vat\<esc>"

  cal cursor(line_number, 1)

  let l:selected_text = join(getline(getpos("'<")[1], getpos("'>")[1]))

  let l:match_tag = matchstr(matchstr(selected_text, "</\\w\\+>*$"), "\\w\\+")

  return tag_name != match_tag
endfunction

function! lib#JSXSelectTag()
  if JSXIsSelfCloseTag()
    exec "normal! \<esc>0f<v/\\/>$\<cr>l"
  else
    exec "normal! \<esc>0f<vat"
  end
endfunction


" transform this:
"   <p>Hello</p>
" into this:
"   return (
"     <p>Hello</p>
"   );
function! lib#JSXEncloseReturn()
  let l:previous_q_reg = @q
  let l:tab = &expandtab ? repeat(" ", &shiftwidth) : "\t"
  let l:line = getline(".")
  let l:line_number = line(".")
  let l:distance = len(matchstr(line, "^\[\\t|\\ \]*"))
  if &expandtab
    let l:distance = (distance / &shiftwidth)
  endif

  call lib#JSXSelectTag()
  exec "normal! \"qc"

  let @q = repeat(tab, distance) . "return (\n" . repeat(tab, distance + 1) . substitute(getreg("q"), "\\n", ("\\n" . tab), "g") .  "\n" . repeat(tab, distance) . ");\n"

  exec "normal! dd\"qP"

  let @q = previous_q_reg
endfunction

"
" Verbatim matching for *.
"
function! lib#search() abort
  let regsave = @@
  normal! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = regsave
endfunction

function! lib#search_all() abort
  call lib#search()
  call setqflist([])
  execute 'bufdo vimgrepadd! /'. @/ .'/ %'
endfunction

" CREDIT: MHINZ
" Switch to VCS root, if there is one.
"
function! lib#cd() abort
  if &buftype =~# '\v(nofile|terminal)' || expand('%') =~# '^fugitive'
    return
  endif
  if !exists('s:cache')
    let s:cache = {}
  endif
  let dirs   = [ '.git', '.hg', '.svn' ]
  let curdir = resolve(expand('%:p:h'))
  if !isdirectory(curdir)
    echohl WarningMsg | echo 'No such directory: '. curdir | echohl NONE
    return
  endif
  if has_key(s:cache, curdir)
    execute 'lcd' fnameescape(s:cache[curdir])
    " echohl WarningMsg | echo 'Jumping to '. curdir | echohl NONE
    return
  endif
  for dir in dirs
    let founddir = finddir(dir, curdir .';')
    if !empty(founddir)
      break
    endif
  endfor
  let dir = empty(founddir) ? curdir : resolve(fnamemodify(founddir, ':p:h:h'))
  let s:cache[curdir] = dir
  execute 'lcd' fnameescape(dir)
  " echohl WarningMsg | echo 'Jumping to '. curdir | echohl NONE
endfunction

"
" Smarter tag-based jumping.
"
function! lib#jump() abort
  if (&filetype == 'vim' && &buftype == 'nofile') || &buftype == 'quickfix'
    execute "normal! \<cr>"
  elseif &filetype == 'neoman'
    execute "normal \<c-]>"
  else
    if exists('g:cscoped')
      try
        execute 'cscope find g' expand('<cword>')
      catch /E259/
        echohl WarningMsg
        redraw | echomsg 'No match found: '. expand('<cword>')
        echohl NONE
      endtry
    else
      try
        execute "normal! g\<c-]>"
      catch /E349/ " no identifier under cursor
      catch /E426/
        echohl WarningMsg
        redraw | echomsg 'No match found: '. expand('<cword>')
        echohl NONE
      endtry
    endif
    normal! zvzt
    " call halo#run()
  endif
endfunction


""---------------------------------------------------------------------------//
" Windows
""---------------------------------------------------------------------------//
" Auto resize Vim splits to active split to 70% -
" https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window
let g:auto_resize_on = 1

function! lib#auto_resize()
  if g:auto_resize_on == 1
    let &winheight = &lines * 9 / 10
    let &winwidth = &columns * 9 / 10
    let g:auto_resize_on = 0
    echom 'Auto resize on'
  else
    set winheight=30
    set winwidth=30
    let g:auto_resize_on = 1
  endif
endfunction


" This keeps the cursor in place when using * or #
function! lib#star_search(key) abort
  let g:_view = winsaveview()
  let out = a:key

  if mode() ==? 'v'
    let out = '"vy' . (a:key == '*' ? '/' : '?') . "\<c-r>="
          \. 'substitute(escape(@v, ''/\.*$^~[''), ''\_s\+'', ''\\_s\\+'', ''g'')'
          \. "\<cr>\<cr>"
  endif

  return out."N:\<c-u>"
        \   .join(['let g:_pos = getpos(''.'')[1:2]',
        \   ':call winrestview(g:_view)',
        \   ':call cursor(g:_pos)',
        \   ':set hlsearch',
        \   ':unlet! g:_view',
        \   ':unlet! g:_pos'], "\<cr>")."\<cr>"
endfunction
""---------------------------------------------------------------------------//
" CREDIT: Romain L
""---------------------------------------------------------------------------//
" make list-like commands more intuitive
function! lib#CCR()
  let cmdline = getcmdline()
  command! -bar Z silent set more|delcommand Z
  if cmdline =~ '\v\C^(ls|files|buffers)'
    " like :ls but prompts for a buffer command
    return "\<CR>:b"
  elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
    " like :g//# but prompts for a command
    return "\<CR>:"
  elseif cmdline =~ '\v\C^(dli|il)'
    " like :dlist or :ilist but prompts for a count for :djump or :ijump
    return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
  elseif cmdline =~ '\v\C^(cli|lli)'
    " like :clist or :llist but prompts for an error/location number
    return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
  elseif cmdline =~ '\C^old'
    " like :oldfiles but prompts for an old file to edit
    set nomore
    return "\<CR>:Z|e #<"
  elseif cmdline =~ '\C^changes'
    " like :changes but prompts for a change to jump to
    set nomore
    return "\<CR>:Z|norm! g;\<S-Left>"
  elseif cmdline =~ '\C^ju'
    " like :jumps but prompts for a position to jump to
    set nomore
    return "\<CR>:Z|norm! \<C-o>\<S-Left>"
  elseif cmdline =~ '\C^marks'
    " like :marks but prompts for a mark to jump to
    return "\<CR>:norm! `"
  elseif cmdline =~ '\C^undol'
    " like :undolist but prompts for a change to undo
    return "\<CR>:u "
  else
    return "\<CR>"
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
function! lib#ModifyLineEndDelimiter(character)
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

" saves all the visible windows if needed/possible
function! lib#AutoSave()
  let this_window = winnr()
  windo if &buftype != "nofile" && expand('%') != '' && &modified | write | endif
execute this_window . 'wincmd w'
endfunction

"line containing the match blinks
function! lib#HLNext (blinktime)
  set invcursorline
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  set invcursorline
  redraw
endfunction


""---------------------------------------------------------------------------//
" Credit:  June Gunn  - AutoSave {{{1
" ----------------------------------------------------------------------------
function! lib#buffer_autosave(enable)
  augroup autosave
    autocmd!
    if a:enable
      autocmd TextChanged,InsertLeave <buffer>
            \  if empty(&buftype) && !empty(bufname(''))
            \|   silent! update
            \| endif
    endif
  augroup END
endfunction

command! -bang AutoSave call lib#autosave(<bang>1)

" custom text-object for numerical values
function! lib#Numbers()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
