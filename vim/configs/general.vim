""---------------------------------------------------------------------------//
" => HELPER FUNCTIONS
""---------------------------------------------------------------------------//
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has('win16') || has('win32')
        let g:cmd_edited = substitute(g:cmd, '\\(.*\[\\\\]\\).*', '\\1', '')
    else
        let g:cmd_edited = substitute(g:cmd, '\\(.*\[/\]\\).*', '\\1', '')
    endif

    if g:cmd == g:cmd_edited
        if has('win16') || has('win32')
            let g:cmd_edited = substitute(g:cmd, '\\(.*\[\\\\\]\\).*\[\\\\\]', '\\1', '')
        else
            let g:cmd_edited = substitute(g:cmd, '\\(.*\[/\]\\).*/', '\\1', '')
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . ' ' . expand('%:p:h') . '/'
  endfunc

function! JsEchoError(msg)
  redraw | echon 'js: ' | echohl ErrorMsg | echon a:msg | echohl None
endfunction

" Swapping between test file and main file.
function! JsSwitch(bang, cmd)
  let l:file = expand('%')
  if empty(l:file)
    call JsEchoError('no buffer name')
    return
  elseif l:file =~# '^\f\+.test\.js$'
    let l:root = split(l:file, '.test.js$')[0]
    let l:alt_file = l:root . '.js'
  elseif l:file =~# '^\f\+\.js$'
    let l:root = split(l:file, '.js$')[0]
    let l:alt_file = l:root . '.test.js'
  else
    call JsEchoError('not a js file')
    return
  endif
  if empty(a:cmd)
    execute ':edit ' . l:alt_file
  else
    execute ':' . a:cmd . ' ' . l:alt_file
  endif
endfunction
au Filetype javascript command! -bang A call JsSwitch(<bang>0, '')

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let l:tmux_start = "\<Esc>Ptmux;"
  let l:tmux_end = "\<Esc>\\"

  return l:tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . l:tmux_end
endfunction
if !has('nvim')
  let &t_SI .= WrapForTmux("\<Esc>[?2004h")
  let &t_EI .= WrapForTmux("\<Esc>[?2004l")
endif

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
endfunction

if !has('nvim')
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
endif

set modelines=0
set nomodeline
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
set shortmess+=F                      "Dont give file info when editing a file
set shortmess+=mnrxo
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
set switchbuf=useopen,usetab,vsplit
set sessionoptions-=options,blank,folds,help
if !has('nvim')
  set termsize="10x30"
endif
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
set iskeyword+=_,$,@,%,#
if has('unnamedplus')
  set clipboard=unnamedplus
elseif has('clipboard')
  set clipboard=unnamed
endif
set nojoinspaces
set gdefault
" insert completion height and options
set pumheight=10
set title
set number relativenumber
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
if exists('&signcolumn')
  set signcolumn=yes "enables column that shows signs and error symbols
endif
set ruler
set incsearch
set completeopt+=noinsert,noselect,longest
set completeopt-=preview
set autowrite "Automatically :write before running commands
if !has('nvim')
  set complete-=i
  set lazyredraw " Turns on lazyredraw which postpones redrawing for macros and command execution
  set autoindent
  set backspace=2 "Back space deletes like most programs in insert mode
  set ttyfast " Improves smoothness of redrawing when there are multiple windows
endif
if exists('&belloff')
  set belloff=all
endif
if has('termguicolors')
  set termguicolors " set vim-specific sequences for rgb colors super important for truecolor support in vim
  if exists('$TMUX')
    let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
  endif
endif
"}}}
" ----------------------------------------------------------------------------
" ------------------------------------
" Command line
" ------------------------------------
set noshowcmd "Show commands being input
set cmdheight=2 " Set command line height to two lines
"-----------------------------------------------------------------
"Abbreviations
"-----------------------------------------------------------------
iabbrev w@ www.akin-sowemimo.com

"}}}
"
"--------------------------------------------------------------
"-----------------------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------------------
set background=dark
colorscheme quantum

if has('nvim')
  let g:terminal_scrollback_buffer_size = 100000
  let s:num = 0
  "        black      red        green      yellow     blue       magenta    cyan       white
  for s:color in [
        \ '#101112', '#b24e4e', '#9da45a', '#f0c674', '#5f819d', '#85678f', '#5e8d87', '#707880',
        \ '#373b41', '#cc6666', '#a0a85c', '#f0c674', '#81a2be', '#b294bb', '#8abeb7', '#c5c8c6',
        \ ]
    " let g:terminal_color_{s:num} = s:color
    let s:num += 1
  endfor
  let g:terminal_color_background = '#000000'
endif

"NVIM
"--------------------------------------------------------------
if has('nvim')
  set inccommand=nosplit
endif
"-------------------------------------------------------------
" Utilities
"---------------------------------------------------------------------
set noshowmode "No mode showing in command pane
set updatetime=200
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
set encoding=utf-8
scriptencoding utf-8
set dictionary+=/usr/share/dict/words

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set history=100
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
  set viminfo+='0
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
if &filetype ==# 'html'
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
set scrolloff=10 " Show context around current cursor position i.e. cursor lines
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
""---------------------------------------------------------------------------//
" Trailing whitespace handling
""---------------------------------------------------------------------------//
" Highlight end of line whitespace.
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
""---------------------------------------------------------------------------//
