"====================================================================================
" AUTOCOMMANDS
"===================================================================================

" Reload vim and config automatically {{{
augroup UpdateVim
  autocmd!
  " NOTE: This takes ${VIM_STARTUP_TIME} duration to run
  " autocmd BufWritePost $DOTFILES/**/nvim/configs/*.vim,$MYVIMRC ++nested
  "       \  luafile $MYVIMRC | redraw | silent doautocmd ColorScheme |
  "       \  call utils#message("sourced ".fnamemodify($MYVIMRC, ":t"), "Title")

  autocmd FocusLost * silent! wall
  " Make windows equal size when vim resizes
  autocmd VimResized * wincmd =
augroup END
" }}}

augroup config_filetype_settings "{{{1
  autocmd!
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
  " set filetype all variants of .env files
  autocmd BufRead,BufNewFile .env.* set filetype=sh
augroup END

augroup CommandWindow "{{{1
  autocmd!
  " map q to close command window on quit
  autocmd CmdwinEnter * nnoremap <silent><buffer><nowait> q <C-W>c
  " Automatically jump into the quickfix window on open
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END

function s:should_show_cursorline() abort
  return &buftype !=? 'terminal' && empty(&winhighlight) && &ft != ''
endfunction

augroup Cursorline
  autocmd!
  autocmd BufEnter * if s:should_show_cursorline() | setlocal cursorline | endif
  autocmd BufLeave * setlocal nocursorline
augroup END

" ----------------------------------------------------------------------------
" Open FILENAME:LINE:COL
" ----------------------------------------------------------------------------
function! s:goto_line()
  let tokens = split(expand('%'), ':')
  if len(tokens) <= 1 || !filereadable(tokens[0])
    return
  endif

  let file = tokens[0]
  let rest = map(tokens[1:], 'str2nr(v:val)')
  let line = get(rest, 0, 1)
  let col  = get(rest, 1, 1)
  bd!
  silent execute 'e' file
  execute printf('normal! %dG%d|', line, col)
endfunction

augroup GoToLine
  au!
  autocmd! BufRead * nested call s:goto_line()
augroup END

augroup CustomWindowSettings
  autocmd!
  " These overrides should apply to all buffers
  autocmd TermOpen * setlocal nocursorline nonumber norelativenumber
  autocmd WinEnter,WinNew * if &previewwindow
        \ | setlocal nospell concealcursor=nv nocursorline colorcolumn=
        \ | endif
augroup END

let s:save_excluded = ['lua.luapad']
function s:can_save() abort
  return empty(&buftype)
        \ && !empty(&filetype)
        \ && &modifiable
        \ && index(s:save_excluded, &ft) == -1
endfunction

augroup Utilities "{{{1
  autocmd!
  " source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
  autocmd BufReadCmd file:///* exe "bd!|edit ".substitute(expand("<afile>"),"file:/*","","")
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "keepjumps normal g`\"" |
        \ endif

  autocmd FileType gitcommit,gitrebase set bufhidden=delete
  autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')

  " Save a buffer when we leave it
  autocmd BufLeave * if s:can_save() | silent! update | endif

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ |   echom 'Filetype set to ' . &ft
        \ | endif

  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END
