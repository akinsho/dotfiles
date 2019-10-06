if has("gui_running") && has("gui_macvim")
  set transparency=0
  set guioptions=
  set guioptions+=g " gray menu items
  set guioptions+=m " menu bar
  "Too find font proper run fc-list | grep name-of-font
  set guifont=FuraCode\ Nerd\ Font:h16
  set guioptions+=e " nice gui tabs
  set linespace=1
  set antialias
  set macligatures
endif
""---------------------------------------------------------------------------//
" Message output on vim actions {{{1
" ----------------------------------------------------------------------------
set shortmess+=t                      " truncate file messages at start
set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=o                      " file-read message overwrites previous
set shortmess+=T                      " truncate non-file messages in middle
set shortmess+=W                      " don't echo "[w]"/"[written]" when writing
set shortmess+=a                      " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set shortmess+=f                      " (file x of x) instead of just (x of x)
set shortmess+=F                      "Dont give file info when editing a file
set shortmess+=mnrxos
if has('patch-7.4.314')
  set shortmess+=c                    " Disable 'Pattern not found' messages
endif
" ----------------------------------------------------------------------------
" Window splitting and buffers {{{1
" ----------------------------------------------------------------------------
set timeout timeoutlen=500 ttimeoutlen=10
set nohidden
set splitbelow splitright
set switchbuf=useopen,usetab,vsplit
if has('folding')
  if has('windows')
    set fillchars=vert:│
    set fillchars+=fold:-
    set fillchars+=diff:⣿
    if has('nvim-0.3.1')
      set fillchars+=msgsep:‾
      set fillchars+=eob:\              " suppress ~ at EndOfBuffer
    endif
  endif
    set foldlevelstart=999
    if has('nvim')
      set foldmethod=syntax
    else
      set foldmethod=indent
    endif
endif
""---------------------------------------------------------------------------//
" Diffing {{{1
" ----------------------------------------------------------------------------
set diffopt=vertical                  " Use in vertical diff mode
" blank lines to keep sides aligned, Ignore whitespace changes
set diffopt+=filler,iwhite,foldcolumn:0,context:4
if has("patch-8.1.0360") || has('nvim-0.3.2')
  set diffopt+=internal,algorithm:patience
endif
" ----------------------------------------------------------------------------
"             Format Options {{{1
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

" ----------------------------------------------------------------------------
" Vim Path {{{1
" ----------------------------------------------------------------------------
" NOTE: Use vim-apathy instead https://github.com/tpope/vim-apathy
if !has_key(g:plugs, 'vim-apathy')
  set path+=**/src/main/**,**
endif
" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode {{{1
" ----------------------------------------------------------------------------
" Use faster grep alternatives if possible
if executable('rg')
  set grepprg=rg\ --no-heading\ --smart-case\ --vimgrep\ $*
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
set wildignorecase " Ignore case when completing file names and directories
" Binary
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.dll,*.jar,*.pyc,*.rbc,*.class
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
if has('nvim-0.4')
  set wildoptions=pum
  set pumblend=2
endif
" ----------------------------------------------------------------------------
" Display {{{1
" --------------------------------------------------------------------------
set cmdheight=2 " Set command line height to two lines
set conceallevel=2
set concealcursor=nv
set synmaxcol=1024 " don't syntax highlight long lines
if has('linebreak') "Causes wrapped line to keep same indentation
  " This should cause lines to wrap around words rather than random characters
  set linebreak
  let &showbreak='↪ '
  " Options include -> '…', '↳ ', '→','↪ '
  if exists('&breakindentopt')
    set breakindentopt=sbr
  endif
endif
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
" LIST =============================================================
set list                              " invisible chars
set listchars+=tab:\¦\ ,
set listchars+=extends:…
set listchars+=precedes:…
" BULLET (U+2022, UTF-8: E2 80 A2)
set listchars+=trail:•
set listchars+=eol:\ ,
" =====================================================================
"-----------------------------------
set iskeyword+=_,$,@
set nojoinspaces
set gdefault
" insert completion height and options
set pumheight=15
set number relativenumber
set numberwidth=5
set report=0 " Always show # number yanked/deleted lines
set smartindent
set wrap
set wrapmargin=2
set textwidth=80
if exists('&signcolumn')
  if has('nvim-0.4')
   "yes confirms showing the column and the specified size
    set signcolumn=yes:2
  else
    set signcolumn=yes "enables column that shows signs and error symbols
  endif
endif
set ruler
set completeopt+=noinsert,noselect,longest
set completeopt-=preview
set nohlsearch
"Automatically :write before running commands and changing files
set autowriteall
if has('unnamedplus')
  set clipboard+=unnamedplus
elseif has('clipboard')
  set clipboard+=unnamed
endif
if !has('nvim')
  set lazyredraw " Turns on lazyredraw which postpones redrawing for macros and command execution
  set laststatus=2
  set incsearch
  set autoindent
  set backspace=2 "Back space deletes like most programs in insert mode
  set ttyfast
else
  set nolazyredraw
endif
if exists('&belloff')
  set belloff=all
endif
if has('termguicolors')
  " Not sure  if these are still necessary for vim
  let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
  set termguicolors " set vim-specific sequences for rgb colors super important for truecolor support in vim
endif
" ctags - search for a tags file then in current dir then home dir
set tags=./.tags,./.git/.tags,tags,~/.tags

""---------------------------------------------------------------------------//
"Colorscheme {{{1
""---------------------------------------------------------------------------//
if !exists('g:gui_oni')
set background=dark
  " ========================
  " OneDark
  " ========================
  " let g:onedark_terminal_italics = 1
  " augroup ColorExtend
  "   autocmd!
  "   autocmd ColorScheme * call onedark#extend_highlight(
  "         \ "DiffChange", { "gui": "none", "cterm": "none" })
  " augroup END
  " colorscheme onedark
  " ========================
  " Night Owl
  " ========================
  " colorscheme night-owl
  " ========================
  " Tender
  " ========================
  " colorscheme tender
  " ========================
  " ONE
  " ========================
  " See highlight.vim for colorscheme overrides
  let g:one_allow_italics = 1
  colorscheme one
endif

"---------------------------------------------------------------------------//
" Title {{{1
"---------------------------------------------------------------------------//
" Custom Terminal title
function! GetTitleString() abort
  if &filetype ==? 'fzf'
    return 'FZF'
  endif
  if filereadable(expand('%'))
    try
      return fnamemodify(fugitive#repo().tree(), ':p:s?/$??:t')
    catch
      return 'VIM'
    endtry
  endif

  return fnamemodify(getcwd(), ':t')
endfunction
set titlestring=%{GetTitleString()}
let &titlestring=' ❐ %f  %r %m'
set title

"---------------------------------------------------------------------------//
"Nvim {{{1
"---------------------------------------------------------------------------//
if has('nvim')
  set inccommand=nosplit
  set guicursor=n:blinkon1
  let g:terminal_scrollback_buffer_size = 500000
endif

"---------------------------------------------------------------------------//
" Utilities {{{1
"---------------------------------------------------------------------------//
set noshowmode "No mode showing in command pane
set sessionoptions-=blank,buffers,globals,help,options
set viewoptions=cursor,folds        " save/restore just these (with `:{mk,load}view`)
set updatetime=200
if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif
" Add dictionary to vim's autocompletion
set complete+=k
" Dont use included files for completion
set complete-=i
if !has('nvim')
  set display+=lastline
endif
set encoding=utf-8
scriptencoding utf-8
set dictionary+=/usr/share/dict/words
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set history=1000
if !empty(&viminfo)
  set viminfo^=!
  set viminfo+='0
endif
"-----------------------------------------------------------------------------
" BACKUP AND SWAPS {{{
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
  if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
  endif
endif
if has ('persistent_undo')
  if !has('nvim')
    set autoread " reload files if they were edited elsewhere
    set undodir=~/.vim/.undo//
  endif
  if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
  endif
  set undolevels=1000
  set undofile
endif
"}}}
" ----------------------------------------------------------------------------
" Match and search {{{1
" ----------------------------------------------------------------------------
set ignorecase smartcase wrapscan " Searches wrap around the end of the file
if &filetype ==# 'html'
  set matchpairs+=<:> "setting is super annoying if not html
endif
augroup cursorline
  autocmd!
  if !exists('g:gui_oni')
    autocmd WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave,BufWinLeave * setlocal nocursorline
  endif
augroup END
set scrolloff=9 sidescrolloff=10 sidescroll=1 nostartofline " Stops some cursor movements from jumping to the start of a line

"====================================================================================
"Spelling {{{1
"====================================================================================
set spellfile=$DOTFILES/vim/.vim-spell-en.utf-8.add
set nospell
if has('syntax')
  set spellcapcheck=                  " don't check for capital letters at start of sentence
endif
set fileformats=unix,mac,dos
set complete+=kspell
"===================================================================================
"Mouse {{{1
"===================================================================================
set mousehide
set mouse=nv
set mousefocus
if !has('nvim')
  set ttymouse=xterm2
endif
set secure  " Disable autocmd etc for project local vimrc files.
set exrc " Allow project local vimrc files example .nvimrc see :h exrc
""---------------------------------------------------------------------------//
" vim:foldmethod=marker
