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
  let exclusions = ['log']
  " Don't highlight trailing spaces in certain filetypes or special buffers
  if index(exclusions, &filetype) >= 0 || &buftype != ""
    setlocal nolist
  else
    highlight! ExtraWhitespace guifg=red
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
        \  if empty(&buftype) && &number
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
  " NOTE: we should only reload config files for plugins not all vim files
  execute 'autocmd UpdateVim BufWritePost '. g:vim_dir .'/configs/*.vim,$MYVIMRC nested'
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
" Hide the colour column when there isn't enough space
function! s:check_color_column(...)
  " if called from WinLeave event this value is 1
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

augroup LocalSpelling
  " Set spell to the queens english for commonly used languages
  " this could go into ftplugin files but that is a lot more
  " work than doing this...
  autocmd Filetype dart,javascript,typescript,rust,go,elm,text,vim,yaml setlocal spell spelllang=en_gb
  " Ignore CamelCase words when spell checking
  " source: https://stackoverflow.com/questions/7561603/vim-spell-check-ignore-capitalized-words
  fun! s:ignore_camel_case()
    syn match CamelCase /\<[A-Z][a-z]\+[A-Z].\{-}\>/ contains=@NoSpell transparent
    syn cluster Spell add=CamelCase
  endfun
  autocmd BufRead,BufNewFile * call s:ignore_camel_case()
augroup end

augroup config_filetype_settings "{{{1
  autocmd!
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
  " set filetype all variants of .env files
  autocmd BufRead,BufNewFile .env.* set filetype=sh
augroup END

augroup CommandWindow "{{{1
  autocmd!
  " map q to close command window on quit
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  " Automatically jump into the quickfix window on open
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END

" This is only available in nightly neovim
" Alternatively use coc-yank or vim-highlighted-yank
if has('nvim-0.5')
  augroup TextYankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank('IncSearch', 500)
  augroup END
endif

augroup Cursorline
  autocmd!
  autocmd WinEnter,BufWinEnter * if &buftype !=? 'terminal' | setlocal cursorline | endif
  autocmd WinLeave,BufWinLeave * setlocal nocursorline
augroup END

augroup CustomWindowSettings
  autocmd!
  " TODO: we match specifically against zsh terminals since we are trying
  " to avoid highlighting fzf buffers.
  "
  " find an autocommand pattern to exclude fzf explicitly
  " term://*fzf*
  " SEE: https://github.com/junegunn/fzf/issues/576
  " FIXME this breaks on sourcing vimrc
  autocmd TermOpen,WinNew,WinEnter term://*zsh*,term://*bash*
        \ silent! lua require"color_helpers".darken_terminal(-30)
  autocmd TermOpen * setlocal nonumber norelativenumber
  autocmd WinEnter,WinNew * if &previewwindow
        \ | setlocal nospell concealcursor=nv nocursorline colorcolumn=
        \ | endif
augroup END

augroup Utilities "{{{1
  autocmd!
  " close FZF in neovim with esc
  autocmd FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

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

  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END
