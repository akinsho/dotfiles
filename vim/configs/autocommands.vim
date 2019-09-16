"====================================================================================
"AUTOCOMMANDS
"===================================================================================
augroup Code Comments             "{{{1
  "------------------------------------+
  au!
  " Horizontal Rule (78 char long)
  autocmd FileType vim                           nnoremap <leader>hr 0i""---------------------------------------------------------------------------//<ESC>
  autocmd FileType javascript,php,c,cpp,css      nnoremap <leader>hr 0i/**-------------------------------------------------------------------------**/<ESC>
  autocmd FileType python,perl,ruby,sh,zsh,conf  nnoremap <leader>hr 0i##---------------------------------------------------------------------------//<ESC>
augroup END

"Whitespace Highlight {{{
function! s:WhitespaceHighlight()
  " Don't highlight trailing spaces in certain filetypes.
  if &filetype ==# 'help' || &filetype ==# 'vim-plug'
    hi! ExtraWhitespace NONE
  else
    hi! ExtraWhitespace guifg=red
  endif
endfunction

function! s:ClearMatches() abort
  try
    call clearmatches()
  endtry
endfunction

augroup vimrc-incsearch-highlight
  autocmd!
  if exists('+CmdlineEnter')
    autocmd CmdlineEnter [/\?] :set hlsearch
    autocmd CmdlineLeave [/\?] :set nohlsearch
  endif
augroup END

augroup togglerelativelinenumbers
  autocmd!
  " If in normal mode show hybrid numbers
  " except in previewwindow and other readonly/ helper windows
  " OR if the ft has a setting to turn of numbers for that buffer
  autocmd InsertEnter,BufLeave,WinLeave,FocusLost *
        \ if &previewwindow | setlocal nonumber norelativenumber |
        \ elseif &l:number && empty(&buftype) |
        \ setlocal norelativenumber |
        \ endif
  autocmd InsertLeave,BufEnter,WinEnter,FocusGained *
        \ if &previewwindow | setlocal nonumber norelativenumber | 
        \ elseif &l:number && empty(&buftype) |
        \ setlocal relativenumber |
        \ endif
augroup end

augroup WhiteSpace "{{{1
  au!
  " Highlight Whitespace
  highlight ExtraWhitespace ctermfg=red guifg=red
  match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * silent! s:ClearMatches()
  autocmd BufEnter * silent! call s:WhitespaceHighlight()
augroup END

" Auto open grep quickfix window and SmartClose {{{
augroup SmartClose
  au!
  au QuickFixCmdPost *grep* cwindow
  " Close help and git window by pressing q.
  autocmd FileType help,git-status,git-log,qf,
        \gitcommit,quickrun,qfreplace,ref,
        \vcs-commit,Godoc,vcs-status,vim-hacks
        \ nnoremap <buffer><nowait><silent> q :<C-u>call <sid>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

  " Close quick fix window if the file containing it was closed
  autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix')
        \ | bd | q | endif

  autocmd QuitPre * if &filetype !=# 'qf' | lclose | endif
  autocmd FileType qf nnoremap <buffer> <c-p> <up>
        \|nnoremap <buffer> <c-n> <down>
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  " automatically close corresponding loclist when quitting a window
  if exists('##QuitPre')
    autocmd QuitPre * nested if &filetype != 'qf' | silent! lclose | endif
  endif
augroup END

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction


augroup CheckOutsideTime "{{{1
  autocmd!
  " automatically check for changed files outside vim
  autocmd WinEnter,BufWinEnter,BufWinLeave,BufRead,BufEnter,FocusGained * silent! checktime
augroup end

""---------------------------------------------------------------------------//
" Credit:  June Gunn  - AutoSave {{{1
" ----------------------------------------------------------------------------
augroup AutoSave
  autocmd!
  autocmd CursorHold,CursorHoldI <buffer>
        \  if empty(&buftype) && !empty(bufname('')) && &modifiable == 1 && &readonly == 0 && &buftype != 'nofile'
        \|   echo "(AutoSaved at " . strftime("%H:%M:%S") . ")"
        \|   silent! update
        \| endif
augroup END

" Disable paste.{{{
augroup Cancel_Paste
  autocmd!
  if !g:gui_neovim_running
    autocmd InsertLeave *
          \ if &paste | set nopaste | echo 'nopaste' | endif
  endif
augroup END

" Reload vim and config automatically {{{
augroup UpdateVim
  autocmd!
  execute 'autocmd UpdateVim BufWritePost '. g:dotfiles .'/vim/configs/*,$MYVIMRC nested'
        \ .' source $MYVIMRC | redraw | silent doautocmd ColorScheme'

  if has('gui_running')
    if filereadable($MYGVIMRC)
      source $MYGVIMRC | echo 'Source .gvimrc'
    endif
  endif
  autocmd FocusLost * silent! wall
  autocmd VimResized * redraw!
  autocmd VimResized * wincmd =
augroup END
" }}}

" Hide the colorcolumn when there isn't enough space
"TODO Need to hook into more events to remove colorcolumn
function! CheckColorColumn()
  if &ft ==# 'startify'
    return
  endif
  let b:cl_size = &colorcolumn
  if winwidth('%') <= 120
    setl colorcolumn=
  else
    try
      let &colorcolumn=b:cl_size
    catch
      echohl WarningMsg
      echom v:exception
      echohl None
      let &colorcolumn=80 "Desparate default
    endtry
  endif
endfunction

if exists('$TMUX')
  augroup TmuxTitle
    if has('nvim') " Figure out async api for vim to replicate this functionality
      autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter *
            \ if strlen(expand("%:t")) | call jobstart("tmux rename-window 'vim | " . expand("%:t") . "'") | endif
      autocmd VimLeave * call jobstart('tmux setw automatic-rename')
    endif
  augroup END
endif

augroup mutltiple_filetype_settings "{{{1
  autocmd!
  autocmd FileType html,css,javascript,jsx,javascript.jsx setlocal backupcopy=yes
augroup END

augroup filetype_javascript_typescript "{{{1
  autocmd!
  "==================================
  "TypeScript
  "==================================
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
augroup END

augroup FileType_html "{{{1
  autocmd!
  autocmd BufNewFile,BufEnter *.html setlocal nowrap
  autocmd BufNewFile,BufRead,BufWritePre *.html :normal gg=G
augroup END


augroup CommandWindow "{{{1
  autocmd!
  " map q to close command window on quit
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END

augroup fileSettings "{{{1
  autocmd!
  autocmd Filetype vim-plug setlocal nonumber norelativenumber
augroup END

" Add Per Window Highlights {{{
function! s:handle_window_enter() abort
  if &buftype ==# 'terminal'
    setlocal nocursorline nonumber norelativenumber "scrolloff=0
    highlight TerminalColors guibg=#22252B ctermbg=black
    highlight TerminalEndOfBuffer guifg=#22252B guibg=#22252B
    if exists('+winhighlight') 
      setlocal winhighlight=Normal:TerminalColors,NormalNC:TerminalColors,EndOfBuffer:TerminalEndOfBuffer
    endif
  endif
  if &previewwindow 
    setlocal nospell concealcursor=nv nocursorline colorcolumn=
    " if exists('+winhighlight') 
    "   " These highlights set the preview to have the same foreground as the
    "   " cursorline but not to show the tildes which mark the end of the buffer
    "   let l:cursorline_background = synIDattr(hlID('CursorLine'), 'bg#')
    "   execute 'silent highlight PreviewEndOfBuffer guifg='.l:cursorline_background
    "   setlocal winhighlight=Normal:CursorLine,EndOfBuffer:PreviewEndOfBuffer
    " endif
  endif
endfunction

if has('nvim')
  augroup nvim
    au!
    autocmd ColorScheme,BufWinEnter,WinEnter,WinNew,TermOpen * call s:handle_window_enter()
    "Close FZF in neovim with esc
    " TODO: Clear highlight for fzf buffers (tidy this up)
    autocmd FileType fzf
          \ tnoremap <nowait><buffer> <esc> <c-g> 
          \ | setlocal winhighlight=
  augroup END
endif

" Setup Help Window "{{{1
function! s:SetupHelpWindow()
  wincmd L
  vertical resize 80
endfunction

augroup FileType_all "{{{1
  autocmd!

  autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

  autocmd FileType help au BufEnter,BufWinEnter <buffer> call <SID>SetupHelpWindow()
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "keepjumps normal g`\"" |
        \ endif

  if exists('*mkdir') "auto-create directories for new files
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
  endif

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

  " Reload Vim script automatically if setlocal autoread
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> |
        \   echo 'source '.bufname('%') |
        \ endif
augroup END

augroup fugitiveSettings
  autocmd!
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END

augroup LongFiles "{{{1
  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END

if v:version >= 700
  " Save the buffers current cursor position
  augroup CursorSave
    autocmd BufLeave * let b:winview = winsaveview()
    autocmd BufEnter * if (exists('b:winview')) | call winrestview(b:winview) | endif
  augroup END
endif

" Fold Text {{{
"Stolen from HiCodin's Dotfiles a really cool set of fold text functions
function! NeatFoldText()
  let l:line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let l:lines_count = v:foldend - v:foldstart + 1
  let l:lines_count_text = '(' . ( l:lines_count ) . ')'
  let l:foldtextstart = strpart('✦ ----' . l:line, 0, (winwidth(0)*2)/3)
  let l:foldtextend = l:lines_count_text . repeat(' ', 2 )
  let l:foldtextlength = strlen(substitute(l:foldtextstart . l:foldtextend, '.', 'x', 'g')) + &foldcolumn
  "NOTE: fold start shows the start the next section replaces everything after the text with
  " spaces up to the length of the line but leaves 7 spaces for the fold length and finally shows the
  " fold length with 2 space padding
  return l:foldtextstart . repeat(' ', winwidth(0) - l:foldtextlength - 7) . l:foldtextend
endfunction
set foldtext=NeatFoldText()

