function! utils#toggle_plugin_config() abort
  if &ft != 'vim'
    return
  endif
  let l:config_file = expand('%:p') 
  let l:toggled_config =  match(l:config_file, 'inactive.vim') != -1
        \ ? substitute(l:config_file, '\.inactive\.vim', '.vim','')
        \ : substitute(l:config_file, '\.vim', '.inactive.vim','')

  echohl String
  echom 'moving ' . l:config_file ' to ' . l:toggled_config
  echohl clear

  try
    let l:src_to_dest = l:config_file . ' ' . l:toggled_config
    if exists('g:loaded_fugitive')
      execute 'Gmove '. l:toggled_config
    elseif executable('git')
      execute '!git mv '. l:src_to_dest
    else
      execute '!mv '. l:src_to_dest
    endif
  catch
    " error handle
    call VimrcMessage("Toggling plugin failed because ". v:exception)
  endtry
endfunction

command! TogglePluginConfig call utils#toggle_plugin_config()

function! utils#send_warning(msg) abort
  echohl WarningMsg
  echom a:msg
  echohl none
endfunction

function! utils#tab_zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction


function! utils#buf_zoom() abort
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
function! utils#reg()
  reg
  echo "Register: "
  let char = nr2char(getchar())
  if char != "\<Esc>"
    execute "normal! \"".char."p"
  endif
  redraw
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

" CREDIT: MHINZ
" Switch to VCS root, if there is one.
function! utils#cd() abort
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

""---------------------------------------------------------------------------//
" Windows
""---------------------------------------------------------------------------//
" Auto resize Vim splits to active split to 70% -
" https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

let s:auto_resize_on = 0

function! utils#auto_resize(factor)
  let l:fraction = a:factor / 10
  if s:auto_resize_on == 0
    let &winheight = &lines * l:fraction / 10
    let &winwidth = &columns * l:fraction / 10
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
function! utils#ModifyLineEndDelimiter(character)
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

""---------------------------------------------------------------------------//
" Credit:  June Gunn  - AutoSave {{{1
" ----------------------------------------------------------------------------
function! utils#buffer_autosave(enable)
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

" custom text-object for numerical values
function! utils#Numbers()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction

""---------------------------------------------------------------------------//
" Credit: Cocophon
" This function allows you to see the syntax highlight token of the cursor word and that token's links
" -> https://github.com/cocopon/pgmnt.vim/blob/master/autoload/pgmnt/dev.vim
""---------------------------------------------------------------------------//
function! utils#token_inspect() abort
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

command! -nargs=0 Token call utils#token_inspect()
nnoremap <leader>E :Token<cr>

function! utils#git_branch_dir(path) abort
  let path = a:path
  let prev = ''
  while path !=# prev
    let dir = path . '/.git'
    let type = getftype(dir)
    if type ==# 'dir' && isdirectory(dir.'/objects') && isdirectory(dir.'/refs') && getfsize(dir.'/HEAD') > 10
      return dir
    elseif type ==# 'file'
      let reldir = get(readfile(dir), 0, '')
      if reldir =~# '^gitdir: '
        return simplify(path . '/' . reldir[8:])
      endif
    endif
    let prev = path
    let path = fnamemodify(path, ':h')
  endwhile
  return ''
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
" Shamelessly stolen from Gary Bernhardt: https://github.com/garybernhardt/dotfiles
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! utils#open_changed_files()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
  let filenames = split(status, "\n")
  if len(filenames) > 0
    exec "edit " . filenames[0]
    for filename in filenames[1:]
      exec "tabedit " . filename
    endfor
  end
endfunction
command! OpenChangedFiles call utils#open_changed_files()

nnoremap <leader>oc :OpenChangedFiles<CR>
