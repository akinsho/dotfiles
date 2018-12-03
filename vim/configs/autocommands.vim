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
        \simpletap-summary,vcs-commit,Godoc,vcs-status,vim-hacks
        \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
  " autocmd Filetype qf setl nocolor
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

  autocmd QuitPre * if &filetype !=# 'qf' | lclose | endif
  autocmd FileType qf nnoremap <buffer> <c-p> <up>
        \|nnoremap <buffer> <c-n> <down>
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
augroup END

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction


augroup CheckOutsideTime "{{{1
  autocmd!
  autocmd WinEnter,BufWinEnter,BufWinLeave,BufRead,BufEnter,FocusGained * silent! checktime " automatically check for changed files outside vim
  au BufEnter * silent! call lib#buffer_autosave
  au FocusLost * silent! call lib#AutoSave() "Saves all files on switching tabs i.e losing focus, ignoring warnings about untitled buffers
  " Autosave buffers before leaving them
augroup end

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
      execute 'autocmd UpdateVim BufWritePost '. g:dotfiles .'/vim/configs/*,vimrc nested'
            \ .' source $MYVIMRC | redraw | silent doautocmd ColorScheme'

  if has('gui_running')
    if filereadable($MYGVIMRC)
      source $MYGVIMRC | echo 'Source .gvimrc'
    endif
  endif
  autocmd FocusLost * :wa
  autocmd VimResized * redraw!
  autocmd VimResized * wincmd =
  autocmd VimResized,WinNew,BufWinEnter,BufRead,BufEnter * call CheckColorColumn()
augroup END
" }}}

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
    autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter *
          \ call system("tmux rename-window 'vim | " . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
  augroup END
endif

augroup mutltiple_filetype_settings "{{{1
  autocmd!
  " syntaxcomplete provides basic completion for filetypes that lack a custom one.
  " :h ft-syntax-omni
  autocmd FileType * if exists("+omnifunc") && &omnifunc == ""
        \ | setlocal omnifunc=syntaxcomplete#Complete | endif

  autocmd FileType * if exists("+completefunc") && &completefunc == ""
        \ | setlocal completefunc=syntaxcomplete#Complete | endif

  autocmd FileType html,css,vue,reason,*.jsx,*.js,*.tsx EmmetInstall
  autocmd FileType html,css,javascript,jsx,javascript.jsx setlocal backupcopy=yes
  autocmd FileType html,markdown,css imap <buffer><expr><tab> <sid>expand_html_tab()
  autocmd FileType css,scss,sass,stylus,less setl omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

  if exists('g:plugs["tern_for_vim"]')
    autocmd FileType javascript,javascript.jsx,jsx ",typscript,typescript.tsx
          \ setlocal omnifunc=tern#Complete
  else
    autocmd FileType javascript,javascript.jsx,jsx,typscript,tsx
          \ setlocal omnifunc=javascriptcomplete#CompleteJS
  endif
augroup END


augroup filetype_javascript_typescript "{{{1
  autocmd!
  "==================================
  "TypeScript
  "==================================
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
augroup END

augroup FileType_html "{{{1
  autocmd!
  autocmd BufNewFile,BufEnter *.html setlocal nowrap
  autocmd BufNewFile,BufRead,BufWritePre *.html :normal gg=G
augroup END


augroup CommandWindow "{{{1
  autocmd!
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END


augroup FileType_text "{{{1
  autocmd!
  autocmd FileType text setlocal textwidth=78
augroup END

augroup fileSettings "{{{1
  autocmd!
  autocmd Filetype vim-plug setlocal nonumber
augroup END

augroup hide_lines "{{{1
  " Hide line numbers when entering diff mode
  autocmd!
  autocmd FilterWritePre * if &diff | set nonumber norelativenumber nocursorline | endif
augroup END

" Terminal Black Background {{{
function! s:highlight_myterm() abort
  try
    exe 'highlight MyTerminal '.
          \'guibg='. g:term_win_highlight["guibg"].
          \' ctermbg='.g:term_win_highlight["ctermbg"]
    exe 'setl winhighlight=Normal:MyTerminal,NormalNC:MyTerminal,CursorLine:MyTerminal,CursorLineNr:MyTerminal'
  catch v:exception
    echohl WarningMsg
    echom v:exception
    echohl none
  endtry
endfunction


if has('nvim')
  augroup nvim
    au!
    autocmd BufEnter term://* startinsert
    "Do everything possible to prevent numbers and cursorline in term buffer
    autocmd BufEnter,BufWinLeave,BufWinEnter,WinEnter,InsertLeave term://* setlocal nonumber norelativenumber nocursorline
    autocmd TermOpen * setlocal nonumber norelativenumber
    au BufEnter,WinEnter * if &buftype == 'terminal' | startinsert | set nocursorline | endif
    " TODO: Tidy this up as there must be a way not to run this for fzf term buffers using an if statement
    if exists('+winhighlight') "&& &filetype !=? 'fzf'
      autocmd TermOpen *
            \ | call s:highlight_myterm()
      " Clear highlight for fzf buffers because yuck
      au FileType fzf setl winhighlight=
    endif
    autocmd TermOpen * set bufhidden=hide
    au FileType fzf tnoremap <nowait><buffer> <esc> <c-g> "Close FZF in neovim with esc
  augroup END
  au BufWinEnter * if &buftype == 'terminal' | setlocal bufhidden=hide | endif
endif


" Setup Help Window "{{{1
function! s:SetupHelpWindow()
  wincmd L
  vertical resize 80
endfunction

augroup FileType_all "{{{1
  autocmd!
  au BufNewFile,BufRead * setlocal formatoptions-=cro
  au FileType help au BufEnter,BufWinEnter <buffer> call <SID>SetupHelpWindow()
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "keepjumps normal g`\"" |
        \ endif

  autocmd User Fugitive
        \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
        \   nnoremap <buffer> .. :edit %:h<CR> |
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
  autocmd FileType gitcommit setlocal nolist
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END



augroup NERDTree "{{{1
  "Close vim if only window is a Nerd Tree
  autocmd!
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd FileType nerdtree setlocal nolist nonumber
  " Refresh NERDTree on Open
  autocmd BufEnter * if exists('b:NERDTree')
        \ | execute 'normal R' | endif
augroup END


augroup LongFiles "{{{1
  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END

if v:version >= 700
  " Save the buffers current cursor position
  augroup CursorSave
    au BufLeave * let b:winview = winsaveview()
    au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
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

