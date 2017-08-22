""---------------------------------------------------------------------------//
" => HELPER FUNCTIONS
""---------------------------------------------------------------------------//
function! s:SetupHelpWindow() "{{{
  wincmd L
  vertical resize 79
  setl nonumber winfixwidth colorcolumn=
endfunction "}}}
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
  endfunc

function! JsEchoError(msg)
  redraw | echon "js: " | echohl ErrorMsg | echon a:msg | echohl None
endfunction

" Swapping between test file and main file.
function! JsSwitch(bang, cmd)
  let file = expand('%')
  if empty(file)
    call JsEchoError("no buffer name")
    return
  elseif file =~# '^\f\+.test\.js$'
    let l:root = split(file, '.test.js$')[0]
    let l:alt_file = l:root . ".js"
  elseif file =~# '^\f\+\.js$'
    let l:root = split(file, ".js$")[0]
    let l:alt_file = l:root . '.test.js'
  else
    call JsEchoError("not a js file")
    return
  endif
  if empty(a:cmd)
    execute ":edit " . alt_file
  else
    execute ":" . a:cmd . " " . alt_file
  endif
endfunction
au Filetype javascript command! -bang A call JsSwitch(<bang>0, '')

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
if !has("nvim")
  let &t_SI .= WrapForTmux("\<Esc>[?2004h")
  let &t_EI .= WrapForTmux("\<Esc>[?2004l")
endif

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
"====================================================================================
"AUTOCOMMANDS {{{
"===================================================================================
augroup Code Comments             "{{{
"------------------------------------+
" Horizontal Rule (78 char long)
autocmd FileType vim                           nnoremap <leader>hr 0i""---------------------------------------------------------------------------//<ESC>
autocmd FileType javascript,php,c,cpp,css      nnoremap <leader>hr 0i/**-------------------------------------------------------------------------**/<ESC>
autocmd FileType python,perl,ruby,sh,zsh,conf  nnoremap <leader>hr 0i##---------------------------------------------------------------------------//<ESC>
" Comment Banners (adds 5 spaces at each end)
autocmd FileType vim                           nnoremap <leader>cb I"     <ESC>A     "<ESC>yyp0lv$hhr-yykPjj
autocmd FileType python,perl,ruby,sh,zsh,conf  nnoremap <leader>cb I#     <ESC>A     #<ESC>yyp0lv$hhr-yykPjj
autocmd FileType javascript,php,c,cpp,css      nnoremap <leader>cb I/*     <ESC>A     */<ESC>yyp0llv$r-$hc$*/<ESC>yykPjj

augroup END "}}}

au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
   let l = 1
   let n_lines = 0
   let w_width = winwidth(0)
   while l <= line('$')
       " number to float for division
       let l_len = strlen(getline(l)) + 0.0
       let line_width = l_len/w_width
       let n_lines += float2nr(ceil(line_width))
       let l += 1
   endw
   exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Close help and git window by pressing q.
augroup quickfix_menu_quit
  autocmd!
  autocmd FileType help,git-status,git-log,qf,
        \gitcommit,quickrun,qfreplace,ref,
        \simpletap-summary,vcs-commit,vcs-status,vim-hacks
        \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif
augroup END

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup Go_Mappings
  autocmd!
  autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4 nolist
  autocmd BufNewFile,WinEnter,BufRead *.go setlocal nolist
  autocmd FileType go nmap <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)
  autocmd FileType go nmap <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
augroup END

augroup CheckOutsideTime - "excellent function but implemented by terminus
  autocmd!
  autocmd WinEnter,BufRead,BufEnter,FocusGained * silent! checktime " automatically check for changed files outside vim
  au FocusLost * silent! wa "Saves all files on switching tabs i.e losing focus, ignoring warnings about untitled buffers
augroup end

" Disable paste.
augroup Cancel_Paste
  autocmd!
  autocmd InsertLeave *
        \ if &paste | set nopaste | echo 'nopaste' | endif
augroup END

augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
  if has('gui_running')
    source $MYGVIMRC | echo 'Source .gvimrc'
  endif
augroup END


augroup VimResizing
  autocmd!
  autocmd VimResized * wincmd =
  autocmd FocusLost * :wa
  autocmd VimResized * :redraw! | :echo 'Redrew'
augroup END

  function! s:expand_html_tab()
" try to determine if we're within quotes or tags.
" if so, assume we're in an emmet fill area.
   let line = getline('.')
   if col('.') < len(line)
     let line = matchstr(line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')
     if len(line) >= 2
        return "\<C-n>"
     endif
   endif
    " try to determine if we're within quotes or tags.
  " if so, assume we're in an emmet fill area.
  let line = getline('.')
  if col('.') < len(line)
    let line = matchstr(line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')

    if len(line) >= 2
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

augroup filetype_completion
  autocmd!
  " syntaxcomplete provides basic completion for filetypes that lack a custom one.
  " :h ft-syntax-omni
  autocmd FileType * if exists("+omnifunc") && &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
  autocmd FileType * if exists("+completefunc") && &completefunc == "" | setlocal completefunc=syntaxcomplete#Complete | endif
  autocmd FileType html,css,javascript,typescript,typescript.tsx,vue,javascript.jsx EmmetInstall
  autocmd FileType html,markdown,css imap <buffer><expr><tab> <sid>expand_html_tab()
  autocmd FileType css,scss,sass,stylus,less setl omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType javascript,javascript.jsx,jsx,typscript,tsx,typescript.jsx setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd CompleteDone * silent! pclose!
augroup END

augroup filetype_javascript_typescript
  autocmd!
  "==================================
  "TypeScript
  "==================================
  autocmd VimEnter,BufNewFile,BufEnter *.ts,*.tsx let b:ale_javascript_prettier_options='--trailing-comma all --tab-width 4 --print-width 100'
  autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx ALEFix
  autocmd FileType typescript setl softtabstop=4 tabstop=4 shiftwidth=4
  "==================================
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
  " autocmd FileType javascript nnoremap <buffer> <leader>co I{/*<C-O>A */}<esc>
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile .eslintrc,.stylelintrc,.babelrc set filetype=json
  autocmd FileType javascript setlocal concealcursor=nvic
augroup END

augroup FileType_Clojure
  autocmd!
  " Evaluate Clojure buffers on load
  autocmd BufRead *.clj, *cljs try | silent! Require | catch /^Fireplace/ | endtry
augroup END

augroup FileType_html
  autocmd!
  autocmd BufNewFile, BufRead *.html setlocal nowrap :normal gg=G
augroup END


augroup FileType_markdown
  autocmd!
  autocmd BufNewFile, BufRead *.md setlocal spell spelllang=en_uk "Detect .md files as mark down
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>aa :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>ia :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd BufNewFile,BufRead *.md :nnoremap <buffer><leader>+ :HeaderIncrease<cr>
  autocmd BufNewFile,BufRead *.md :nnoremap <buffer><leader>- :HeaderDecrease<cr>
augroup END

augroup filetype_vim
  "Vimscript file settings -------------------------
  autocmd!
  "This command makes vim start a file with all folds closed
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim nnoremap <leader>pi :PlugInstall<CR>
  autocmd FileType vim nnoremap <leader>ps :PlugStatus<CR>
  autocmd FileType vim nnoremap <leader>pc :PlugClean<CR>
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
augroup END

augroup FileType_text
  autocmd!
  autocmd FileType text setlocal textwidth=78
augroup END

if has('nvim')
  augroup nvim
    au!
    au BufEnter * if &buftype == 'terminal' | :startinsert | endif
    autocmd BufEnter term://* startinsert
    autocmd TermOpen * set bufhidden=hide
    au BufEnter * if &buftype == 'terminal' | setlocal nonumber | endif
    au FileType fzf tnoremap <nowait><buffer> <esc> <c-g> "Close FZF in neovim with esc
  augroup END
endif

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
        \   exe "normal g`\"" |
        \ endif

  if exists("*mkdir") "auto-create directories for new files
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
  endif
augroup END

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END

"Close vim if only window is a Nerd Tree
augroup NERDTree
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd FileType nerdtree setlocal nolist
augroup END

"Stolen from HiCodin's Dotfiles a really cool set of fold text functions
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldtextstart = strpart('✦' . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}
" Javascript {{{
function! FoldText()
  let line = ' ' . substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldchar = matchstr(&fillchars, 'fold:\')
  let foldtextstart = strpart('✦' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend . ' '
endfunction
augroup jsfolding
  autocmd!
  autocmd FileType javascript,javascript.jsx,jsx setlocal foldenable|setlocal foldmethod=indent|setlocal foldtext=FoldText()
  au Filetype javascript,javascript.jsx,jsx setlocal foldlevelstart=99
augroup END
" }}}
" CSS {{{
function! CSSFoldText()
  let line = substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldchar = matchstr(&fillchars, 'fold:\')
  let foldtextstart = strpart('✦ ' . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend . ' '
endfunction
augroup ft_css
  au!
  au Filetype css setlocal foldmethod=indent | setlocal foldlevelstart=99
  au Filetype css setlocal foldmarker={,}
  au FileType css setlocal foldtext=CSSFoldText()
augroup END

" ----------------------------------------------------------------------------
" Message output on vim actions
" ----------------------------------------------------------------------------
set shortmess+=t                      " truncate file messages at start
set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=O                      " file-read message overwrites previous
set shortmess+=T                      " truncate non-file messages in middle
set shortmess+=W                      " don't echo "[w]"/"[written]" when writing
set shortmess-=l
set shortmess+=a                      " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
 set shortmess-=f                      " (file x of x) instead of just (x of x)
" set shortmess+=I                      " no splash screen
" set shortmess+=mnrxoOt
if has('patch-7.4.314')
  set shortmess+=c                    " Disable 'Pattern not found' messages
endif

" ----------------------------------------------------------------------------
" Window splitting and buffers
" ----------------------------------------------------------------------------
"NOTE: notimeout setting is super important as it prevents delayed key entry
" set notimeout timeoutlen=500 ""ttimeoutlen=100
set timeout timeoutlen=500 ttimeoutlen=10
set nohidden
set winwidth=30
set splitbelow "Open a horizontal split below current window
set splitright "Open a vertical split to the right of the window
if has('folding')
  if has('windows')
    set fillchars=vert:│
    set fillchars+=fold:-
  endif
  set foldlevelstart=99
  set foldnestmax=3
endif
set switchbuf=useopen,usetab,newtab
set sessionoptions-=options
if !has('nvim')
  set termsize="10x30"
endif
set completeopt+=noselect,longest
set completeopt-=preview
" ----------------------------------------------------------------------------
" DIFFING {{{
" ----------------------------------------------------------------------------

" Note this is += since fillchars was defined in the window config
set fillchars+=diff:⣿
set diffopt=vertical                  " Use in vertical diff mode
set diffopt+=filler                   " blank lines to keep sides aligned
set diffopt+=iwhite                   " Ignore whitespace changes
"}}}
" ----------------------------------------------------------------------------
"             FORMAT OPTIONS {{{
" ----------------------------------------------------------------------------
" Input auto-formatting (global defaults)
" Probably need to update these in after/ftplugin too since ftplugins will
" probably update it.
set formatoptions=
set formatoptions+=1
set formatoptions-=q                  " continue comments with gq"
set formatoptions-=c                  " Auto-wrap comments using textwidth
set formatoptions-=r                  " Do not continue comments by default
set formatoptions-=o                  " do not continue comment using o or O
set formatoptions+=n                  " Recognize numbered lists
set formatoptions+=2                  " Use indent from 2nd line of a paragraph
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif
set nrformats-=octal " never use octal when <C-x> or <C-a>"
"}}}
" ----------------------------------------------------------------------------
" Vim Path
" ----------------------------------------------------------------------------
" set path+=** "Vim searches recursively through all directories and subdirectories
set path+=**/src/main/**,** " path set to some greedy globs and suffixesadd set to contain .js. This allows me to press gf (open file under cursor) on a require statement, and it will actually take me to the source (if it exists)
set suffixesadd+=.js,.jsx,.ts,.tsx
" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode {{{
" ----------------------------------------------------------------------------
" Use faster grep alternatives if possible
if executable('rg')
  " set grepprg=rg\ --vimgrep\ --no-heading
  set grepprg=rg\ --smart-case\ --vimgrep\ $*
  set grepformat^=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m
endif
"pressing Tab on the command line will show a menu to complete buffer and file names
set wildchar=<Tab>
set wildmenu
set wildmode=full       " Shows a menu bar as opposed to an enormous list
set wildcharm=<C-Z>
nnoremap <leader><tab> :b <C-Z>
set wildignorecase " Ignore case when completing file names and directories
" Binary
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.jar,*.pyc,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Cache
set wildignore+=.sass-cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem
" Temp/System
set wildignore+=*.*~,*~
set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

"}}}
" ----------------------------------------------------------------------------
" Display {{{
" --------------------------------------------------------------------------
set conceallevel=2
"syntax sync minlines=256 " update syntax highlighting for more lines increased scrolling performance
 set synmaxcol=1024 " don't syntax highlight long lines
set emoji
if has('linebreak') "Causes wrapped line to keep same indentation
  " This should cause lines to wrap around words rather than random characters
  set linebreak
  " let &showbreak='↳ ' " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
  let &showbreak='↪ '
  if exists('&breakindentopt')
    set breakindentopt=shift:2
  endif
endif
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
" LIST =============================================================
set list                              " show invisible chars
set listchars+=tab:▷\ 
set listchars+=precedes:←
set listchars+=extends:→
set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)
set listchars+=eol:\ 
" =====================================================================
"-----------------------------------
set iskeyword+=- "Enables better css syntax highlighting
set iskeyword+=_,$,@,%,#
if has("unnamedplus")
  set clipboard=unnamedplus
elseif has("clipboard")
  set clipboard=unnamed
endif
set nojoinspaces
set gdefault
" insert completion height and options
set pumheight=10
set title
set number relativenumber
if has('+relativenumber')
    set number relativenumber
elseif has('nvim')
    set number relativenumber
else
  set number
endif
if !has('gui_running')
  set linespace=4
else
  set linespace=2
endif
set numberwidth=5
set report=0 " Always show # number yanked/deleted lines
set smartindent
set wrap
set textwidth=79
if has('vim')
  if exists('&signcolumn')
    set signcolumn=yes "enables column that shows signs and error symbols
  endif
else
  set signcolumn=yes
endif
set ruler
set incsearch
set completeopt+=noinsert
if !has('nvim')
  set complete-=i
  set lazyredraw " Turns on lazyredraw which postpones redrawing for macros and command execution
  set autoindent
  set autowrite "Automatically :write before running commands
  set backspace=2 "Back space deletes like most programs in insert mode
  set ttyfast " Improves smoothness of redrawing when there are multiple windows
endif
if exists('&belloff')
  set belloff=all
endif
if has('termguicolors')
  set termguicolors " set vim-specific sequences for rgb colors super important for truecolor support in vim
  let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
endif
"}}}
" ----------------------------------------------------------------------------
" ------------------------------------
" Command line
" ------------------------------------
set showcmd "Show commands being input
set cmdheight=2 " Set command line height to two lines
"-----------------------------------------------------------------
"Abbreviations
"-----------------------------------------------------------------
iabbrev w@ www.akin-sowemimo.com
iabbrev fn function
iabbrev fl false
iabbrev tr true

"}}}
"
"--------------------------------------------------------------
"NVIM
"--------------------------------------------------------------
if has('nvim')
  "Only enable this if you become a Python dev
  " let g:python_host_prog='/Users/A_nonymous/.pyenv/versions/neovim2/bin/python'
  " let g:python3_host_prog='/Users/A_nonymous/.pyenv/versions/neovim3/bin/python'
  set inccommand=nosplit
  let g:terminal_color_1  = '#cc0000'
  let g:terminal_color_2  = '#4e9a06'
  let g:terminal_color_3  = '#c4a000'
  let g:terminal_color_4  = '#3465a4'
  let g:terminal_color_5  = '#75507b'
  let g:terminal_color_6  = '#0b939b'
  let g:terminal_color_7  = '#d3d7cf'
  let g:terminal_color_8  = '#555753'
  let g:terminal_color_9  = '#ef2929'
  let g:terminal_color_10 = '#8ae234'
  let g:terminal_color_11 = '#fce94f'
  let g:terminal_color_12 = '#729fcf'
  let g:terminal_color_13 = '#ad7fa8'
  let g:terminal_color_14 = '#00f5e9'
  let g:terminal_color_15 = '#eeeeec'
endif
"-----------------------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------------------
set background=dark
colorscheme quantum


"-------------------------------------------------------------
" Utilities
"---------------------------------------------------------------------
set noshowmode "No mode showing in command pane
set updatetime=2000
if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif
" ----------------------------------------------------------------------------
" Tabbing - overridden by editorconfig, after/ftplugin {{{
" ----------------------------------------------------------------------------
set expandtab                         " default to spaces instead of tabs
set shiftwidth=2                      " softtabs are 2 spaces for expandtab
set softtabstop=-2 " Alignment tabs are two spaces, and never tabs. Negative means use same as shiftwidth (so the 2 actually doesn't matter).
set tabstop=8 " real tabs render width. Applicable to HTML, PHP, anything using real tabs. I.e., not applicable to JS.
set noshiftround " use multiple of shiftwidth when shifting indent levels. this is OFF so block comments don't get fudged when using \">>" and \"<<"
set smarttab " When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'. 'tabstop' or 'softtabstop' is used in other places.
set complete+=k " Add dictionary to vim's autocompletion
set display+=lastline
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif
scriptencoding utf-8
" set dictionary+=/usr/share/dict/words

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set history=100
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
"-----------------------------------------------------------------------------
" BACKUP AND SWAPS
"-----------------------------------------------------------------------------
"Turn swap files off - FOR GOD's SAKE they are ruining my life
set noswapfile
"This saves all back up files in a vim backup directory
if exists('$SUDO_USER')
  set nobackup                        " don't create root-owned files
  set nowritebackup                   " don't create root-owned files
else
  set backupdir=~/.vim/.backup//
  set backupdir+=~/local/.vim/tmp/backup
  set backupdir+=~/.vim/tmp/backup    " keep backup files out of the way
endif
if !has('nvim')
  set autoread " reload files if they were edited elsewhere
endif
if has ('persistent_undo')
  if exists('$SUDO_USER')
    set noundofile "Dont add root owned files which I will need to sudo to remove
  else
    set undodir=~/.vim/.undo//
    set undolevels=1000
    set undodir+=~/local/.vim/tmp/undo
    set undodir+=.
    set undofile
  endif
endif
"}}}
" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------
set ignorecase
set smartcase
set wrapscan " Searches wrap around the end of the file
set nohlsearch " -functionality i.e. search highlighting done by easy motion and incsearch
if &ft ==# 'html'
  set matchpairs+=<:> "setting is super annoying if not html
endif
" ----------------------------------------------------------------------------
" CURSOR  "{{{
" ----------------------------------------------------------------------------
" Set cursorline to the focused window only and change and previously color/styling of cursor line depending on mode - Slow?
augroup cursorline
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter,InsertLeave * setlocal cursorline
  autocmd WinLeave,InsertEnter * setlocal nocursorline
augroup END

set scrolloff=999 " Show context around current cursor position i.e. cursor lines remaining whilst moving up or down As this is set to a large number the cursor will remain in the middle of the page on scroll (8 ) was the previous value
set sidescrolloff=10
set nostartofline " Stops some cursor movements from jumping to the start of a line
"}}}
"====================================================================================
"Spelling
"====================================================================================
" Dropbox or kept in Git.
set spellfile=$HOME/.vim-spell-en.utf-8.add
set fileformats=unix,dos,mac
set complete+=kspell
"===================================================================================
"Mouse {{{
"===================================================================================
set mousehide
set mouse=a "this is the command that works for mousepad
" Swap iTerm2 cursors in [n]vim insert mode when using tmux, more here https://gist.github.com/andyfowler/1195581
if exists('$TMUX')
  if !has('nvim')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  endif
endif

if !has('nvim')
  set ttymouse=xterm2
  set mouse=a
endif
"}}}
