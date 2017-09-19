"====================================================================================
"AUTOCOMMANDS
"===================================================================================
augroup Code Comments             "{{{
"------------------------------------+
au!
" Horizontal Rule (78 char long)
autocmd FileType vim                           nnoremap <leader>hr 0i""---------------------------------------------------------------------------//<ESC>
autocmd FileType javascript,php,c,cpp,css      nnoremap <leader>hr 0i/**-------------------------------------------------------------------------**/<ESC>
autocmd FileType python,perl,ruby,sh,zsh,conf  nnoremap <leader>hr 0i##---------------------------------------------------------------------------//<ESC>

augroup END "}}}

augroup WhiteSpace
  " Highlight Whitespace
  highlight ExtraWhitespace ctermfg=red guifg=red
  match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END

" Auto open grep quickfix window
augroup QFix
  au!
  au QuickFixCmdPost *grep* cwindow
  " Close help and git window by pressing q.
  autocmd FileType help,git-status,git-log,qf,
        \gitcommit,quickrun,qfreplace,ref,gina-log,gina-status
        \simpletap-summary,vcs-commit,Godoc,vcs-status,vim-hacks
        \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif
  autocmd QuitPre * if &filetype !=# 'qf' | lclose | endif
augroup END

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction


augroup CheckOutsideTime
  autocmd!
  autocmd WinEnter,BufRead,BufEnter,FocusGained * silent! checktime " automatically check for changed files outside vim
  au FocusLost * silent! wa "Saves all files on switching tabs i.e losing focus, ignoring warnings about untitled buffers
  " Autosave buffers before leaving them
  autocmd BufLeave * silent! :wa
augroup end

" Disable paste.
augroup Cancel_Paste
  autocmd!
  autocmd InsertLeave *
        \ if &paste | set nopaste | echo 'nopaste' | endif
augroup END


augroup UpdateVim
  autocmd!
  " Reload vim and config automatically {{{
  execute 'autocmd UpdateVim BufWritePost '.$DOTFILES.'/vim/configs/*,vimrc nested'
        \ .' source $MYVIMRC | redraw | silent doautocmd ColorScheme'
  " }}}
  if has('gui_running')
    source $MYGVIMRC | echo 'Source .gvimrc'
  endif
  autocmd FocusLost * :wa
  autocmd VimResized * :redraw! | echom 'Redrew'
  " autocmd VimResized * wincmd =
augroup END

augroup AirLineRefresh
  autocmd BufDelete * call airline#extensions#tabline#buflist#invalidate()
augroup END

  function! s:expand_html_tab()
" try to determine if we're within quotes or tags.
" if so, assume we're in an emmet fill area.
   let l:line = getline('.')
   if col('.') < len(l:line)
     let l:line = matchstr(l:line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')
     if len(l:line) >= 2
        return "\<C-n>"
     endif
   endif
    " try to determine if we're within quotes or tags.
  " if so, assume we're in an emmet fill area.
  let l:line = getline('.')
  if col('.') < len(l:line)
    let l:line = matchstr(l:line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')

    if len(l:line) >= 2
      return "\<Plug>(emmet-move-next)"
    endif
  endif

  " go to next item in a popup menu.
  if pumvisible()
    return "\<C-n>"
  endif

  " expand anything emmet thinks is expandable.
  " I'm not sure control ever reaches below this block.
  if emmet#isExpandable()
    return "\<Plug>(emmet-expand-abbr)"
  endif

  " return a regular tab character
  return "\<tab>"
  endfunction

augroup mutltiple_filetype_settings
  autocmd!
  " syntaxcomplete provides basic completion for filetypes that lack a custom one.
  " :h ft-syntax-omni
  autocmd FileType * if exists("+omnifunc") && &omnifunc == ""
        \ | setlocal omnifunc=syntaxcomplete#Complete | endif

  autocmd FileType * if exists("+completefunc") && &completefunc == ""
        \ | setlocal completefunc=syntaxcomplete#Complete | endif

  autocmd FileType html,css,javascript,typescript,typescript.tsx,vue,javascript.jsx EmmetInstall
  autocmd FileType html,css,javascript,jsx,javascript.jsx setlocal backupcopy=yes
  autocmd FileType html,markdown,css imap <buffer><expr><tab> <sid>expand_html_tab()
  autocmd FileType css,scss,sass,stylus,less setl omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

  if exists('g:plugs["tern_for_vim"]')
    autocmd FileType javascript,javascript.jsx,jsx,typscript,tsx,typescript.jsx
          \ setlocal omnifunc=tern#Complete
  else
    autocmd FileType javascript,javascript.jsx,jsx,typscript,tsx,typescript.jsx
          \ setlocal omnifunc=javascriptcomplete#CompleteJS
  endif
  au * BufWinEnter :AutoSave<CR> | echom 'Autosave Enabled'
augroup END

augroup filetype_javascript_typescript
  autocmd!
  "==================================
  "TypeScript
  "==================================
  autocmd VimEnter,BufNewFile,BufEnter *.ts,*.tsx
        \ let b:ale_javascript_prettier_options=
        \ '--trailing-comma all --tab-width 4 --print-width 100'
  autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx ALEFix
  autocmd WinEnter,BufRead,VimEnter *.tsx,*.jsx,*.js set completeopt-=preview
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
augroup END

augroup FileType_Clojure
  autocmd!
  " Evaluate Clojure buffers on load
  autocmd BufRead *.clj, *cljs try | silent! Require | catch /^Fireplace/ | endtry
augroup END

augroup FileType_html
  autocmd!
  autocmd BufNewFile,BufRead,BufWritePre *.html setlocal nowrap :normal gg=G
augroup END

augroup CommandWindow
  autocmd!
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END

augroup FileType_text
  autocmd!
  autocmd FileType text setlocal textwidth=78
augroup END

if has('nvim')
  augroup nvim
    au!
    autocmd BufEnter term://* startinsert
    au BufEnter,WinEnter * if &buftype == 'terminal' | startinsert | set nocursorline | endif
    highlight BlackTerminal guibg=black ctermbg=Black
    if exists('+winhighlight')
    autocmd TermOpen * if &buftype !=# 'fzf'
          \ | set winhighlight=Normal:BlackTerminal,NormalNC:BlackTerminal,CursorLine:BlackTerminal
          \ | endif
    endif
    autocmd TermOpen * set bufhidden=hide | set nonumber
    au FileType fzf tnoremap <nowait><buffer> <esc> <c-g> "Close FZF in neovim with esc
  augroup END
endif

function! s:SetupHelpWindow() "{{{
  wincmd L
  vertical resize 80
endfunction "}}}

augroup FileType_all
  autocmd!
  autocmd FileType python setl ts=4
  autocmd FileType rust setl sw=0 sts=0
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
  au FileType help au BufEnter,BufWinEnter <buffer> call <SID>SetupHelpWindow()
  au FileType help au BufEnter,BufWinEnter <buffer> setlocal spell!
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


augroup OpenImages
  autocmd BufEnter *.png,*.jpg,*gif exec "! ~/.iterm2/imgcat ".expand("%") | :bw
augroup END

"Close vim if only window is a Nerd Tree
augroup NERDTree
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd FileType nerdtree setlocal nolist nonumber
augroup END

augroup LongFiles
  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif
augroup END


augroup fix-ultisnips-overriding-tab-visual-mode
    autocmd!
    autocmd VimEnter * xnoremap <Tab> >gv
augroup END

"Stolen from HiCodin's Dotfiles a really cool set of fold text functions {{{
function! NeatFoldText()
  let l:line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let l:lines_count = v:foldend - v:foldstart + 1
  let l:lines_count_text = '(' . ( l:lines_count ) . ')'
  let l:foldtextstart = strpart('✦' . l:line, 0, (winwidth(0)*2)/3)
  let l:foldtextend = l:lines_count_text . repeat(' ', 2 )
  let l:foldtextlength = strlen(substitute(l:foldtextstart . l:foldtextend, '.', 'x', 'g')) + &foldcolumn
  return l:foldtextstart . repeat(' ', winwidth(0)-l:foldtextlength) . l:foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}
