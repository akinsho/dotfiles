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

function! utils#info_message(msg) abort
  echohl String
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
"}}}
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

""---------------------------------------------------------------------------//
" Fold Text (For Curly Brace languages)
""---------------------------------------------------------------------------//
function! utils#braces_fold_text(...)
  let line = ' ' . substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldchar = matchstr(&fillchars, 'fold:\')
  let l:window_width = winwidth(0)
  let foldtextstart = strpart('✦' . repeat(foldchar, v:foldlevel * 2) . line, 0, (l:window_width * 2) / 3)
  let foldtextend = lines_count_text . repeat(' ', 2)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', l:window_width - foldtextlength - 7) . foldtextend . ' ' 
endfunction


""---------------------------------------------------------------------------//
" Takes a base - highlight group to extend,
" group - the new group name
" add - the settings to add  to the highlight
""---------------------------------------------------------------------------//"
function! utils#extend_highlight(base, group, add)
  redir => basehi
  sil! exe 'highlight' a:base
  redir END
  let grphi = split(basehi, '\n')[0]
  let grphi = substitute(grphi, '^'.a:base.'\s\+xxx', '', '')
  sil exe 'highlight' a:group grphi a:add
endfunction

function! utils#move_line_up()
  call utils#move_line_or_visual_up(".", "")
endfunction

function! utils#move_line_down()
  call utils#move_line_or_visual_down(".", "")
endfunction

function! utils#move_visual_up()
  call utils#move_line_or_visual_up("'<", "'<,'>")
  normal gv
endfunction

function! utils#move_visual_down()
  call utils#move_line_or_visual_down("'>", "'<,'>")
  normal gv
endfunction

function! utils#move_line_or_visual_up(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num - v:count1 - 1 < 0
    let move_arg = "0"
  else
    let move_arg = a:line_getter." -".(v:count1 + 1)
  endif
  call utils#move_line_or_visual_up_or_down(a:range."move ".move_arg)
endfunction

function! utils#move_line_or_visual_down(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num + v:count1 > line("$")
    let move_arg = "$"
  else
    let move_arg = a:line_getter." +".v:count1
  endif
  call utils#move_line_or_visual_up_or_down(a:range."move ".move_arg)
endfunction

function! utils#move_line_or_visual_up_or_down(move_arg)
  let col_num = virtcol(".")
  execute "silent! ".a:move_arg
  execute "normal! ".col_num."|"
endfunction

" open the current entry in th preview window
function! utils#preview_file_under_cursor()
  let cur_list = b:qf_isLoc == 1 ? getloclist('.') : getqflist()
  let cur_line = getline(line('.'))
  let cur_file = fnameescape(substitute(cur_line, '|.*$', '', ''))
  if cur_line =~ '|\d\+'
    let cur_pos  = substitute(cur_line, '^\(.\{-}|\)\(\d\+\)\(.*\)', '\2', '')
    execute "pedit +" . cur_pos . " " . cur_file
  else
    execute "pedit " . cur_file
  endif
endfunction
