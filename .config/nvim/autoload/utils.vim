function! utils#message(msg, ...) abort
  let hl = 'WarningMsg'
  if a:0 " a:0 is the number of optional args provided
    let hl = a:1
  endif
  execute 'echohl '. hl
  echom a:msg
  echohl none
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
    " use "tabnew" instead of "new" below if you prefer tabs instead of split windows
    vnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction


" regular expressions that match numbers (order matters .. keep '\d' last!)
" note: \+ will be appended to the end of each
let s:reg_nums = [ '0b[01]', '0x\x', '\d' ]

" https://vimways.org/2018/transactions-pending/
function! utils#in_number()
  " select the next number on the line
  " this can handle the following three formats (so long as s:regNums is
  " defined as it should be above this function):
  "   1. binary  (eg: "0b1010", "0b0000", etc)
  "   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
  "   3. decimal (eg: "0", "0000", "10", "01", etc)
  " NOTE: if there is no number on the rest of the line starting at the
  "       current cursor position, then visual selection mode is ended (if
  "       called via an omap) or nothing is selected (if called via xmap)

  " need magic for this to work properly
  let l:magic = &magic
  set magic

  let l:line_nr = line('.')

  " create regex pattern matching any binary, hex, decimal number
  let l:pat = join(s:reg_nums, '\+\|') . '\+'

  " move cursor to end of number
  if (!search(l:pat, 'ce', l:line_nr))
    " if it fails, there was not match on the line, so return prematurely
    return
  endif

  " start visually selecting from end of number
  normal! v

  " move cursor to beginning of number
  call search(l:pat, 'cb', l:line_nr)

  " restore magic
  let &magic = l:magic
endfunction

function! utils#around_number()
  " select the next number on the line and any surrounding white-space;
  " this can handle the following three formats (so long as s:regNums is
  " defined as it should be above these functions):
  "   1. binary  (eg: "0b1010", "0b0000", etc)
  "   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
  "   3. decimal (eg: "0", "0000", "10", "01", etc)
  " NOTE: if there is no number on the rest of the line starting at the
  "       current cursor position, then visual selection mode is ended (if
  "       called via an omap) or nothing is selected (if called via xmap);
  "       this is true even if on the space following a number

  " need magic for this to work properly
  let l:magic = &magic
  set magic

  let l:line_nr = line('.')
  " create regex pattern matching any binary, hex, decimal number
  let l:pat = join(s:reg_nums, '\+\|') . '\+'
  " move cursor to end of number
  if (!search(l:pat, 'ce', l:line_nr))
    " if it fails, there was not match on the line, so return prematurely
    return
  endif
  " move cursor to end of any trailing white-space (if there is any)
  call search('\%'.(virtcol('.')+1).'v\s*', 'ce', l:line_nr)
  " start visually selecting from end of number + potential trailing whitspace
  normal! v
  " move cursor to beginning of number
  call search(l:pat, 'cb', l:line_nr)

  " move cursor to beginning of any white-space preceding number (if any)
  call search('\s*\%'.virtcol('.').'v', 'b', l:line_nr)

  " restore magic
  let &magic = l:magic
endfunction

lua << EOF
-- this is required since devicons returns 2 values which need to be collected
-- into a table before they can be read out in vimscript
function _G.__devicon_icon(name, extension)
    local loaded, devicons = pcall(require, "nvim-web-devicons")
    if not loaded then
        return {}
    end
    local icon, hl = devicons.get_icon(name, extension, {default = true})
    return {icon, hl}
end
EOF

function utils#get_devicon(bufname) abort
  try
    let extension = fnamemodify(a:bufname, ':e')
    let icon_data = v:lua.__devicon_icon(a:bufname, extension)
    return icon_data
  catch /.*/
    echoerr v:exception
    return ['', '']
  endtry
endfunction
