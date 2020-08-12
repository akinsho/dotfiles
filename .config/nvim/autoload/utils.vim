function! utils#toggle_plugin_config() abort
  if &ft != 'vim'
    return
  endif
  let config_file = expand('%:p')
  let toggled_config =  match(config_file, 'inactive.vim') != -1
        \ ? substitute(config_file, '\.inactive\.vim', '.vim','')
        \ : substitute(config_file, '\.vim', '.inactive.vim','')

  echohl String
  echom 'moving ' . config_file ' to ' . toggled_config
  echohl clear

  try
    let src_to_dest = config_file . ' ' . toggled_config
    if exists('g:loaded_fugitive')
      execute 'Gmove '. toggled_config
    elseif executable('git')
      execute '!git mv '. src_to_dest
    else
      execute '!mv '. src_to_dest
    endif
  catch
    " error handle
    call VimrcMessage("Toggling plugin failed because ". v:exception)
  endtry
endfunction

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
  let syn_id = synID(line('.'), col('.'), 1)
  let names = s:hi_chain(syn_id)
  echo join(names, ' -> ')
endfunction


function! s:hi_chain(syn_id) abort
  let name = synIDattr(a:syn_id, 'name')
  let names = []

  call add(names, name)

  let original = synIDtrans(a:syn_id)
  if a:syn_id != original
    call add(names, synIDattr(original, 'name'))
  endif

  return names
endfunction
""---------------------------------------------------------------------------//
" Takes a base - highlight group to extend,
" group - the new group name
" add - the settings to add  to the highlight
""---------------------------------------------------------------------------//"
function! utils#extend_highlight(base, group, add)
  redir => base_hi
  sil! exe 'highlight' a:base
  redir END
  let grp_hi = split(base_hi, '\n')[0]
  let grp_hi = substitute(grp_hi, '^'.a:base.'\s\+xxx', '', '')
  sil exe 'highlight' a:group grp_hi a:add
endfunction

function! utils#tab_message(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
