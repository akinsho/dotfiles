function! fns#tab_zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction


function! fns#buf_zoom() abort
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
function! fns#reg()
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

function! fns#JSXSelectTag()
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
function! fns#JSXEncloseReturn()
  let l:previous_q_reg = @q
  let l:tab = &expandtab ? repeat(" ", &shiftwidth) : "\t"
  let l:line = getline(".")
  let l:line_number = line(".")
  let l:distance = len(matchstr(line, "^\[\\t|\\ \]*"))
  if &expandtab
    let l:distance = (distance / &shiftwidth)
  endif

  call fns#JSXSelectTag()
  exec "normal! \"qc"

  let @q = repeat(tab, distance) . "return (\n" . repeat(tab, distance + 1) . substitute(getreg("q"), "\\n", ("\\n" . tab), "g") .  "\n" . repeat(tab, distance) . ");\n"

  exec "normal! dd\"qP"

  let @q = previous_q_reg
endfunction

"
" Verbatim matching for *.
"
function! fns#search() abort
  let regsave = @@
  normal! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = regsave
endfunction

function! fns#search_all() abort
  call fns#search()
  call setqflist([])
  execute 'bufdo vimgrepadd! /'. @/ .'/ %'
endfunction

"
" Switch to VCS root, if there is one.
"
function! fns#cd() abort
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
function! fns#jump() abort
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

function! fns#auto_resize()
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


" This keeps the cursor in place when using * or #
function! fns#star_search(key) abort
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

fu! fns#open_folds(action) abort
    if a:action ==# 'is_active'
        return exists('s:open_folds')
    elseif a:action ==# 'enable'
        let s:open_folds = {
        \                    'foldclose' : &foldclose,
        \                    'foldopen'  : &foldopen,
        \                    'foldlevel' : &foldlevel,
        \                  }
        set foldlevel=0
        set foldclose=all
        set foldopen=all
        echo '[auto open folds] ON'
    else
        let &foldlevel = s:open_folds.foldlevel
        let &foldclose = s:open_folds.foldclose
        let &foldopen  = s:open_folds.foldopen
        unlet! s:open_folds
        echo '[auto open folds] OFF'
    endif
    return ''
  endfu
