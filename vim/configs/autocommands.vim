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

"Whitespace Highlight {{{1
function! s:WhitespaceHighlight()
  " Don't highlight trailing spaces in certain filetypes.
  let exclusions = ['help', 'vim-plug', 'log']
  if index(exclusions, &filetype) >= 0 || &buftype == "quickfix"
    setlocal nolist
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


augroup fileSettings "{{{1
  autocmd!
  autocmd Filetype vim-plug,git setlocal nonumber norelativenumber
augroup END

augroup togglerelativelinenumbers
  autocmd!
  " If in normal mode show hybrid numbers
  " except in previewwindow and other readonly/ helper windows
  " OR if the ft has a setting to turn of numbers for that buffer
  autocmd InsertEnter,BufLeave,WinLeave,FocusLost *
        \ if &previewwindow
        \ |  setlocal nonumber norelativenumber
        \ | elseif empty(&buftype) && &number
        \ |  setlocal norelativenumber
        \ | endif

  autocmd InsertLeave,BufEnter,WinEnter,FocusGained *
        \ if &previewwindow
        \ |  setlocal nonumber norelativenumber
        \ | elseif empty(&buftype) && &number
        \ |  setlocal number relativenumber
        \ | endif
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

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

" SmartClose {{{
augroup SmartClose
  au!
  " Auto open grep quickfix window
  au QuickFixCmdPost *grep* cwindow
  " Close help and git window by pressing q.
  autocmd FileType help,git-status,git-log,gitcommit,ref,Godoc,dbui,fugitive,LuaTree,log
        \ nnoremap <buffer><nowait><silent> q :<C-u>call <sid>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

  " Close quick fix window if the file containing it was closed
  autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix')
        \ | bd | q | endif

  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  " automatically close corresponding loclist when quitting a window
  if exists('##QuitPre')
    autocmd QuitPre * nested if &filetype !=# 'qf' | silent! lclose | endif
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

" Disable paste.{{{
augroup Cancel_Paste
  autocmd!
    autocmd InsertLeave *
          \ if &paste | set nopaste | echo 'nopaste' | endif
augroup END

" Reload vim and config automatically {{{
augroup UpdateVim
  autocmd!
  execute 'autocmd UpdateVim BufWritePost '. g:dotfiles .'/vim/*.vim,$MYVIMRC nested'
        \ .' source $MYVIMRC | redraw | silent doautocmd ColorScheme'

  if has('gui_running')
    if filereadable($MYGVIMRC)
      source $MYGVIMRC | echo 'Source .gvimrc'
    endif
  endif
  autocmd FocusLost * silent! wall
  " Autosave vim on typing stopped
  autocmd CursorHold,CursorHoldI * silent! update
  " Update the cursor column to match current window size
  autocmd VimEnter,BufWinEnter,VimResized,FocusGained,WinEnter * call s:check_color_column()
  autocmd WinLeave * call s:check_color_column(1)
  " Make windows equal size when vim resizes
  autocmd VimResized * wincmd =
augroup END
" }}}

let s:column_exclusions = [
      \ 'startify',
      \ 'gitcommit',
      \ 'vimwiki',
      \ 'vim-plug',
      \ 'help'
      \ ]
" Hide the colorcolumn when there isn't enough space
function! CheckColorColumn(...)
  " if called from winleave event this value is 1
  let leaving = get(a:, '0', 0)
  if index(s:column_exclusions, &ft) != -1 || !&buflisted
    return
  endif
  if winwidth('%') <= 120 || leaving
    setl colorcolumn=
  " only reset this value when it doesn't already exist
  elseif !&colorcolumn
    setl colorcolumn<
  endif
endfunction

function! s:update_tmux_statusline_colors() abort
  " Get the color of the current vim background and update tmux accordingly
  let bg_color = synIDattr(hlID('Normal'), 'bg')
  call jobstart('tmux set-option -g status-style bg=' . bg_color)
  " TODO: on vim leave we should set this back to what it was
endfunction

if exists('$TMUX')
  augroup TmuxConfig
    au!
    if has('nvim') " Figure out async api for vim to replicate this functionality
      autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter *
            \ if strlen(expand("%:t")) | call jobstart("tmux rename-window 'vim | " . expand("%:t") . "'") | endif
      autocmd VimLeave * call jobstart('tmux setw automatic-rename')
      autocmd ColorScheme,FocusGained * call s:update_tmux_statusline_colors()
    endif
  augroup END
endif

augroup config_filtetype_settings "{{{1
  autocmd!
  "==================================
  " Config files
  "==================================
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
  " set filetype all variants of .env files
  autocmd BufRead,BufNewFile .env.* set filetype=sh
augroup END

augroup FileType_html "{{{1
  autocmd!
  autocmd BufNewFile,BufEnter *.html setlocal nowrap
augroup END


augroup CommandWindow "{{{1
  autocmd!
  " map q to close command window on quit
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  " Automatically jump into the quickfix window on open
  " autocmd QuickFixCmdPost [^l]* nested cwindow
  " autocmd QuickFixCmdPost    l* nested lwindow
augroup END

" This is only available in nightly neovim
" Alternatively use coc-yank or vim-highlighted-yank
if has('nvim-0.5')
  augroup TextYankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank('IncSearch', 500)
  augroup END
endif

" Add Per Window Highlights {{{
function! s:handle_window_enter() abort
  if &buftype ==# 'terminal'
    setlocal nocursorline nonumber norelativenumber
    " if g:colors_name ==? 'one' || g:colors_name ==? 'onedark'
      " if exists('+winhighlight')
        "@TODO: figure out how to avoid highlighting fzf buffers
        " highlight TerminalColors guibg=#22252B ctermbg=black
        " highlight TerminalEndOfBuffer guifg=#22252B guibg=#22252B
        " setlocal winhighlight=Normal:TerminalColors,NormalNC:TerminalColors,EndOfBuffer:TerminalEndOfBuffer
      " endif
    " endif
  endif
  if &previewwindow
    setlocal nospell concealcursor=nv nocursorline colorcolumn=
  endif
endfunction

if has('nvim')
  augroup nvim
    au!
    autocmd ColorScheme,BufWinEnter,WinEnter,WinNew,TermOpen * call s:handle_window_enter()
    "Close FZF in neovim with esc
    autocmd FileType fzf
          \ tnoremap <nowait><buffer> <esc> <c-g>
  augroup END
endif

augroup FileType_all "{{{1
  autocmd!

  autocmd TermOpen,TermEnter * startinsert!
  autocmd TermLeave * stopinsert!
  " The above autocommands don't cover leaving an already open terminal buffer
  " which is in insert mode
  autocmd BufWinLeave * if &buftype ==# 'terminal' | stopinsert! | endif
  autocmd BufWinEnter * if &buftype ==# 'terminal' | startinsert! | endif

  " Surprisingly enough vim has added this to defaults.vim in vim8 but this
  " is not standard behaviour still in neovim
  if has('nvim')
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost *
          \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "keepjumps normal g`\"" |
          \ endif
  endif

  if exists('*mkdir') "auto-create directories for new files
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
  endif

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ |   echom 'Filetype set to ' . &ft
        \ | endif

  " Reload Vim script automatically if setlocal autoread
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> |
        \   echo 'source '.bufname('%') |
        \ endif
augroup END

augroup LongFiles "{{{1
  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END
