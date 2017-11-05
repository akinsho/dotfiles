function! akin#tab_zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction


function! akin#buf_zoom() abort
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
function! akin#reg()
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

function! akin#JSXSelectTag()
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
function! akin#JSXEncloseReturn()
  let l:previous_q_reg = @q
  let l:tab = &expandtab ? repeat(" ", &shiftwidth) : "\t"
  let l:line = getline(".")
  let l:line_number = line(".")
  let l:distance = len(matchstr(line, "^\[\\t|\\ \]*"))
  if &expandtab
    let l:distance = (distance / &shiftwidth)
  endif

  call akin#JSXSelectTag()
  exec "normal! \"qc"

  let @q = repeat(tab, distance) . "return (\n" . repeat(tab, distance + 1) . substitute(getreg("q"), "\\n", ("\\n" . tab), "g") .  "\n" . repeat(tab, distance) . ");\n"

  exec "normal! dd\"qP"

  let @q = previous_q_reg
endfunction

"
" Verbatim matching for *.
"
function! akin#search() abort
  let regsave = @@
  normal! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = regsave
endfunction

function! akin#search_all() abort
  call akin#search()
  call setqflist([])
  execute 'bufdo vimgrepadd! /'. @/ .'/ %'
endfunction

"
" Switch to VCS root, if there is one.
"
function! akin#cd() abort
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
endfunction

"
" Smarter tag-based jumping.
"
function! akin#jump() abort
  if (&filetype == 'vim' && &buftype == 'nofile') || &buftype == 'quickfix'
    execute "normal! \<cr>"
  elseif &filetype == 'neoman'
    execute "normal \<c-]>"
  else
    if exists('g:cscoped')
      try
        execute 'cscope find g' expand('<cword>')
      " catch /E259/
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
" Auto resize Vim splits to active split to 70% - https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window
let g:auto_resize_on = 1

function! akin#auto_resize()
  if g:auto_resize_on == 1
    let &winheight = &lines * 7 / 10
    let &winwidth = &columns * 7 / 10
    let g:auto_resize_on = 0
    echom 'Auto resize on'
  else
    set winheight=30
    set winwidth=30
    let g:auto_resize_on = 1
  endif
endfunction
