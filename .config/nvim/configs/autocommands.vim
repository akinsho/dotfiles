"====================================================================================
" AUTOCOMMANDS
"===================================================================================
if exists('+CmdlineEnter')
  augroup VimrcIncSearchHighlight
    autocmd!
    " autotically clear search highlight once
    autocmd CmdlineEnter [/\?] :set hlsearch
    autocmd CmdlineLeave [/\?] :set nohlsearch
  augroup END
endif

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

function s:setup_smart_close() abort
  let filetypes = [
        \ "help",
        \ "git-status",
        \ "git-log",
        \ "gitcommit",
        \ "dbui",
        \ "fugitive",
        \ "fugitiveblame",
        \ "LuaTree",
        \ "log",
        \ "tsplayground"
        \]
  let is_readonly = (&readonly || !&modifiable) && !hasmapto('q', 'n')
  if index(filetypes, &ft) >= 0 || is_readonly || &buftype == 'nofile'
    nnoremap <buffer><nowait><silent> q :<C-u>call <sid>smart_close()<CR>
  endif
endfunction

" Smart Close {{{
augroup SmartClose
  au!
  " Auto open grep quickfix window
  autocmd QuickFixCmdPost *grep* cwindow
  " Close certain filetypes by pressing q.
  autocmd FileType * call <SID>setup_smart_close()
  " Close quick fix window if the file containing it was closed
  autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix')
        \ | bd! | endif
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
  " NOTE: This takes ${VIM_STARTUP_TIME} duration to run
  autocmd BufWritePost $DOTFILES/**/nvim/configs/*.vim,$MYVIMRC ++nested
        \  source $MYVIMRC | redraw | silent doautocmd ColorScheme |
        \  call VimrcMessage("sourced ".fnamemodify($MYVIMRC, ":t"), "Title")

  if has('gui_running')
    if filereadable($MYGVIMRC)
      source $MYGVIMRC | echo 'Sourced .gvimrc'
    endif
  endif
  autocmd FocusLost * silent! wall
  " Update the cursor column to match current window size
  autocmd VimEnter,BufWinEnter,VimResized,FocusGained,WinEnter * call s:check_color_column()
  autocmd WinLeave * call s:check_color_column(1)
  " Make windows equal size when vim resizes
  autocmd VimResized * wincmd =
augroup END
" }}}

let s:column_exclusions = ['startify', 'vimwiki', 'vim-plug', 'help']
" Hide the colour column when there isn't enough space
function! s:check_color_column(...)
  if index(s:column_exclusions, &ft) != -1
        \ || !&modifiable
        \ || !&buflisted
        \ || strlen(&buftype) > 0
      setlocal colorcolumn=
    return
  endif
  " if called from WinLeave event this value is 1
  let leaving = get(a:, '0', 0)
  if winwidth('%') <= 120 || leaving
    setlocal colorcolumn=
  " only reset this value when it doesn't already exist
  elseif !&colorcolumn
    setlocal colorcolumn<
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

" This is only available in nightly neovim
" Alternatively use coc-yank or vim-highlighted-yank
if has('nvim-0.5')
  augroup TextYankHighlight
    autocmd!
    " don't execute silently in case of errors
    autocmd TextYankPost * lua require'vim.highlight'.on_yank({ timeout = 500, on_visual = false })
  augroup END
endif

augroup Cursorline
  autocmd!
  autocmd BufEnter * if &buftype !=? 'terminal' | setlocal cursorline | endif
  autocmd BufLeave * setlocal nocursorline
augroup END

" TODO make sure this doesn't highlight FZF buffers
" find a nicer way to highlight "toggleterm" as well
function! s:terminal_setup()
  if &buftype ==# 'terminal'&& (&filetype ==# '' || &filetype ==# 'toggleterm')
      lua require"color_helpers".darken_terminal(-30)
    endif
endfunction

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
  " TODO: we match specifically against zsh terminals since we are trying
  " to avoid highlighting fzf buffers.
  " find an autocommand pattern to exclude fzf explicitly term://*fzf*
  " SEE: https://github.com/junegunn/fzf/issues/576

  " These overrides should apply to all buffers
  autocmd TermOpen * setlocal nocursorline nonumber norelativenumber
  autocmd TermOpen,ColorScheme,WinNew,TermEnter term://*zsh*,term://*bash*
        \ call s:terminal_setup()
  " on BufRead the name of the toggle-able terminal will have changed
  " so it will not be caught by the pattern above
  autocmd BufEnter,ColorScheme * call s:terminal_setup()
  autocmd WinEnter,WinNew * if &previewwindow
        \ | setlocal nospell concealcursor=nv nocursorline colorcolumn=
        \ | endif
augroup END

augroup Utilities "{{{1
  autocmd!
  " close FZF in neovim with <ESC>
  autocmd FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

  autocmd TermOpen * startinsert!
  autocmd BufLeave * if &buftype ==# 'terminal' | stopinsert! | endif
  autocmd BufEnter * if &buftype ==# 'terminal' | startinsert! | endif

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

  autocmd FileType gitcommit,gitrebase set bufhidden=delete

  " FIXME should this be being called for all existing files
  if exists('*mkdir') "auto-create directories for new files
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
  endif

  " Save a buffer when we leave it
  autocmd BufLeave * silent! update

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ |   echom 'Filetype set to ' . &ft
        \ | endif

  " Reload Vim script automatically if setlocal autoread
  if has('nvim')
    autocmd BufWritePost,FileWritePost **/nvim/lua/**/*.lua nested
          \ execute ('luafile ' . fnamemodify(expand('<afile>'), ':p'))
          \ | call VimrcMessage('sourced '.bufname('%'), 'Title')
  endif

  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END
