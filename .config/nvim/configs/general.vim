""---------------------------------------------------------------------------//
" Message output on vim actions {{{1
" ----------------------------------------------------------------------------
set shortmess=                        " remove defaults
set shortmess+=t                      " truncate file messages at start
set shortmess+=A                      " ignore annoying swap file messages
set shortmess+=o                      " file-read message overwrites previous
set shortmess+=O                      " file-read message overwrites previous
set shortmess+=T                      " truncate non-file messages in middle
set shortmess+=f                      " (file x of x) instead of just (x of x)
set shortmess+=F                      "Don't give file info when editing a file
set shortmess+=s
set shortmess+=c
" ----------------------------------------------------------------------------
" Window splitting and buffers {{{1
" ----------------------------------------------------------------------------
set timeout timeoutlen=500 ttimeoutlen=10
set hidden " this allows changing vim buffers without saving
set splitbelow splitright
set eadirection=hor
" exclude usetab as we do not want to jump to buffers in already open tabs
" do not use split or vsplit to ensure we don't open any new windows
set switchbuf=useopen,uselast
set fillchars=vert:│
set fillchars+=fold:\ 
set fillchars+=diff: "alternatives: ⣿ ░
if has('nvim-0.3.1')
  set fillchars+=msgsep:‾
  " suppress ~ at EndOfBuffer
  set fillchars+=eob:\ 
endif
if has('nvim-0.5')
  set fillchars+=foldopen:▾,foldsep:│,foldclose:▸
endif
""---------------------------------------------------------------------------//
" Diff {{{1
" ----------------------------------------------------------------------------
" Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
set diffopt+=vertical,iwhite,hiddenoff,foldcolumn:0,context:4
if has("patch-8.1.0360") || has('nvim-0.3.2')
  set diffopt+=algorithm:histogram,indent-heuristic
endif
" ----------------------------------------------------------------------------
" Format Options {{{1
" ----------------------------------------------------------------------------
" Input auto-formatting (global defaults)
" Probably need to update these in after/ftplugin too since ftplugins will
" probably update it.
set formatoptions=
set formatoptions+=1
set formatoptions-=q                  " continue comments with gq"
set formatoptions+=c                  " Auto-wrap comments using textwidth
set formatoptions+=r                  " Continue comments when pressing Enter
set formatoptions-=o                  " do not continue comment using o or O
set formatoptions+=n                  " Recognize numbered lists
set formatoptions+=2                  " Use indent from 2nd line of a paragraph
set formatoptions+=t                  " autowrap lines using text width value
set formatoptions+=j                  " remove a comment leader when joining lines.
" Only break if the line was not longer than 'textwidth' when the insert
" started and only at a white character that has been entered during the
" current insert command.
set formatoptions+=lv
" ----------------------------------------------------------------------------
" Folds {{{1
" ----------------------------------------------------------------------------
set foldtext=folds#render()
set foldopen+=search
" This is overwritten in lsp-fold compatible files by Coc
set foldmethod=syntax
set foldlevelstart=10
" The fold open and close markers are visually distracting
" and if the code is too nested it starts rendering fold depth
set foldcolumn=0
" if has('nvim-0.5')
"  set foldcolumn=auto:8
" endif
" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode {{{1
" ----------------------------------------------------------------------------
" Use faster grep alternatives if possible
if executable('rg')
  set grepprg=rg\ --hidden\ --no-heading\ --smart-case\ --vimgrep\ --follow\ $*
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
  set pumblend=3  " Make popup window translucent
endif
" ----------------------------------------------------------------------------
" Display {{{1
" --------------------------------------------------------------------------
" Set the colour column to highlight one column after the 'textwidth'
set colorcolumn=+1
set cmdheight=2 " Set command line height to two lines
set conceallevel=2
set concealcursor=nv
set synmaxcol=1024 " don't syntax highlight long lines
if has('linebreak') "Causes wrapped line to keep same indentation
  " This should cause lines to wrap around words rather than random characters
  set linebreak
  set showbreak=↪\ 
  " Options include -> '…', '↳ ', '→','↪ '
  if exists('&breakindentopt')
    set breakindentopt=sbr
  endif
endif
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
" ----------------------------------------------------------------------------
" List chars {{{1
" --------------------------------------------------------------------------
set list                              " invisible chars
set listchars=
set listchars+=tab:\│\ ,
set listchars+=extends:…
set listchars+=precedes:…
" BULLET (U+2022, UTF-8: E2 80 A2)
set listchars+=trail:•
set listchars+=eol:\ ,
" --------------------------------------------------------------------------
set iskeyword+=_,$,@
set nojoinspaces
set gdefault
" insert completion height and options
set pumheight=15
set numberwidth=4
set wrap
set wrapmargin=2
set softtabstop=2
set textwidth=80 " this is a default that might be too aggressive on modern screens
set confirm " make vim prompt me to save before doing destructive things
if exists('&signcolumn')
  if has('nvim-0.4')
   " yes confirms showing the column and the specified size
    set signcolumn=yes:2
  else
    set signcolumn=yes "enables column that shows signs and error symbols
  endif
endif
set completeopt+=noinsert,noselect,longest
set completeopt-=preview
set nohlsearch
" Automatically :write before running commands and changing files
set autowriteall
if has('unnamedplus')
  set clipboard+=unnamedplus
elseif has('clipboard')
  set clipboard+=unnamed
endif
if !has('nvim')
  set lazyredraw " Turns on lazyredraw which postpones redrawing for macros and command execution
  set laststatus=2
  set autoindent
  set ttyfast
endif
if exists('&belloff')
  set belloff=all
endif
if has('termguicolors')
  " Not sure  if these are still necessary for vim
  if !has('nvim')
    let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors " set vim-specific sequences for RGB colors super important for true color support in vim
endif
" Ctags - search for a tags file then in current dir then home dir
set tags=./.tags,./.git/.tags,tags,~/.tags
"--------------------------------------------------------------------------------
" Git editor
"--------------------------------------------------------------------------------
if has('nvim') && executable('nvr')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  let $EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
"---------------------------------------------------------------------------//
" Title {{{1
"---------------------------------------------------------------------------//
" Custom Terminal title
" BUG: kitty terminal's tabs flicker when setting the title
function! GetTitleString() abort
  if &filetype ==? 'fzf'
    return 'FZF'
  endif
  if filereadable(expand('%'))
    try
      return "❐ " . fnamemodify(fugitive#repo().tree(), ':p:s?/$??:t')
    catch
      return v:servername
    endtry
  endif
  return fnamemodify(getcwd(), ':t')
endfunction
let &titlestring=' ❐ %t %r %m'
let &titleold='%{fnamemodify(getcwd(), ":t")}'
set title
set titlelen=70

"---------------------------------------------------------------------------//
" Emoji {{{1
"---------------------------------------------------------------------------//
" emoji is true by default but makes (n)vim treat all emoji as double width
" which breaks rendering so we turn this off.
" CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
set noemoji
"---------------------------------------------------------------------------//
" Nvim {{{1
"---------------------------------------------------------------------------//
if has('nvim')
  set inccommand=nosplit
  " if on an older version of nvim the bug which causes the cursor
  " not to reset to previous state using CocList hasn't been fixed
  " yet -> https://github.com/neoclide/coc.nvim/commit/65637efe99fbc24a40541801c2c9b5f2066530a4
  if has('nvim-0.5')
    " This is from the help docs, it enables mode shapes, "Cursor" highlight, and blinking
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
          \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
          \,sm:block-blinkwait175-blinkoff150-blinkon175
  endif
endif
"---------------------------------------------------------------------------//
" Utilities {{{1
"---------------------------------------------------------------------------//
set noshowmode " no mode showing in command pane
set sessionoptions=buffers,curdir,tabpages,help,winpos " Do not add Folds here
set viewoptions=cursor,folds " save/restore just these (with `:{mk,load}view`)
set updatetime=300
if has('virtualedit')
  set virtualedit=block " allow cursor to move where there is no text in visual block mode
endif
" Add dictionary to vim's autocompletion
set complete+=k
" Don't use included files for completion
set complete-=i
if !has('nvim')
  set display+=lastline
endif
set encoding=utf-8
set fileencoding=utf-8
set dictionary+=/usr/share/dict/words
"-----------------------------------------------------------------------------
" BACKUP AND SWAPS {{{
"-----------------------------------------------------------------------------
" Turn swap files off - FOR GOD's SAKE they are ruining my life
set noswapfile
set nobackup
set nowritebackup
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
set scrolloff=9 sidescrolloff=10 sidescroll=1 nostartofline " Stops some cursor movements from jumping to the start of a line
"====================================================================================
" Spelling {{{1
"====================================================================================
set spellfile=$DOTFILES/.config/nvim/.vim-spell-en.utf-8.add
set spellsuggest+=12
if has('syntax')
  " don't check for capital letters at start of sentence
  set spellcapcheck=
endif
set fileformats=unix,mac,dos
set complete+=kspell
"===================================================================================
" Mouse {{{1
"===================================================================================
set mousehide
set mouse=nv
set mousefocus
if !has('nvim')
  set ttymouse=xterm2
endif
set secure  " Disable autocmd etc for project local vimrc files.
set exrc " Allow project local vimrc files example .nvimrc see :h exrc
"---------------------------------------------------------------------------//
" vim:foldmethod=marker
