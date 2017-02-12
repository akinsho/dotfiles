" ________  ___  __    ___  ________   ________           ________  ________  ________   ________ ___  ________     
"|\   __  \|\  \|\  \ |\  \|\   ___  \|\   ____\         |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\    
"\ \  \|\  \ \  \/  /|\ \  \ \  \\ \  \ \  \___|_        \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|    
" \ \   __  \ \   ___  \ \  \ \  \\ \  \ \_____  \        \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___  
"  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \        \ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \ 
"   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \        \ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
"    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\        \|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|
"                                        \|_________|                                                               
                                                                                                                   
                                                                                                                    


set nocompatible "IMproved, required
filetype off " required  Prevents potential side-effects
             " from system ftdetects scripts
"-----------------------------------------------------------
"Plugins
"-----------------------------------------------------------
"set the runtime path to include Vundle and initialise
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

let g:ycm_confirm_extra_conf = 0

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
"Added YouCompleteMe autocompleter
Plugin 'Valloric/YouCompleteMe'
"Added nerdtree filetree omnitool : )
Plugin 'scrooloose/nerdtree'
"Added vim-airline
Plugin 'bling/vim-airline'
"Added ctrlP fuzzy finger
Plugin 'ctrlpvim/ctrlp.vim'
"Added syntastic syntax checker
Plugin 'vim-syntastic/syntastic'
"Added vim surround for enclosing with parens
Plugin 'tpope/vim-surround'
"Added jsbeautify
Plugin 'maksimr/vim-jsbeautify'
"Added airline themes" 
Plugin 'vim-airline/vim-airline-themes'
" Add fugitive git status and command plugins
Plugin 'tpope/vim-fugitive'
" Adds file manipulation functionality
Plugin 'tpope/vim-eunuch'
"Added Editor Config plugin to maintain style choices
Plugin 'editorconfig/editorconfig-vim'

"Added nerdcommenter for commenting out text
Plugin 'scrooloose/nerdcommenter'
"Added emmet vim plugin
Plugin 'mattn/emmet-vim'
"Added delimit me auto parens plugin
Plugin 'Raimondi/delimitMate'
"Added further javascript syntax highlighting
Plugin 'jelera/vim-javascript-syntax'
"Added node.vim plugin
Plugin 'moll/vim-node' 
"Added javascript lib - syntax highlighting for popular libraries
Plugin 'othree/javascript-libraries-syntax.vim'
"Added CS approx to allow gvim colorschemes to work in terminal
" Plugin 'godlygeek/csapprox'
" Does the same as CS approx ?better
Plugin 'colorsupport.vim'
"Added oceanic next theme
Plugin 'mhartington/oceanic-next'
" Added yet another js syntax highlighter
Plugin 'othree/yajs.vim',{'for':'javascript'}
" Added html5 syntax highlighter
Plugin 'othree/html5.vim'
"Added easy motions
Plugin 'easymotion/vim-easymotion'
"Added vim polyglot a collection of language packs for vim
Plugin 'sheerun/vim-polyglot'
"Added vim snippets for code autofilling
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
Plugin 'isRuslan/vim-es6'
Plugin 'jamescarr/snipmate-nodejs'
"Autocorrects 4,000 common typos
Plugin 'chip/vim-fat-finger'


"Added SyntaxComplete for more syntax completion
Plugin 'vim-scripts/SyntaxComplete'
"Added vim javascript
Plugin 'pangloss/vim-javascript'
"Add proper markdown syntax and indentation plugin
Plugin 'gabrielelana/vim-markdown'
"Markdown previewer
Plugin 'JamshedVesuna/vim-markdown-preview' 
"Added color picker plugin
Plugin 'KabbAmine/vCoolor.vim'
"Add Tern for autocompletion
Plugin 'ternjs/tern_for_vim'
"Add Gundo - undo plugin for vim
Plugin 'sjl/gundo.vim'
"Add buffergator for better buffer control
Plugin 'jeetsukumaran/vim-buffergator'
"Add vim-signature which higlights and shows marks for a file
Plugin 'kshenoy/vim-signature'
"Tim pope's surround plugin allows . to repeat more actions
Plugin 'tpope/vim-repeat'
"Added yankstack a lighter weight version of yankring
Plugin 'maxbrunsfeld/vim-yankstack'
"Added rainbow parentheses plugin colorizes parens depending on depth
Plugin 'luochen1990/rainbow'
"Add supertab to use tab for all insert mode completions
Plugin 'ervandew/supertab'
"Added JavaScript indent
Plugin 'vim-scripts/JavaScript-Indent'
"Added Breezy theme
" Plugin 'fneu/breezy'
"Added Quantum theme (light or dark)
" Plugin 'tyrannicaltoucan/vim-quantum'
"Added Vim-one colorscheme
" Plugin 'rakr/vim-one'
"Add Plugin to manage tag files
Plugin 'ludovicchabant/vim-gutentags'
"Navigate panes in vim and tmux with the same bindings
Plugin 'christoomey/vim-tmux-navigator'
" A fun start up sceen for vim 
Plugin 'mhinz/vim-startify'
"Add Base16 color schemes vim
Plugin 'chriskempson/base16-vim'
"Add file type icons to vim
Plugin 'ryanoasis/vim-devicons' " This Plugin must load after the others



" All of your Plugins must be added before the following line
call vundle#end()            " required
" if !has('nvim')
  filetype plugin indent on
" endif
"Brief help
":PluginList       - lists configured plugins
":PluginInstall    - installs plugins; append `!` to update or just
":PluginUpdate
":PluginSearch foo - searches for foo; append `!` to refresh local cache
":PluginClean      - confirms removal of unused plugins; append `!` to
"auto-approve removal
"!!!This line is key to making vim work in tmux
set term=screen-256color
"====================================================================================
"Leader bindings
"====================================================================================

"Remap leader key
let mapleader = ","
"Local leader key
let maplocalleader = "\<space>"
"--------------------------------------------------------------------------------------------------
"Plugin Mappings
"--------------------------------------------------------------------------------------------------


" Ctrl+N to toggle Nerd Tree
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1 "Show hidden files by default

"Press enter to complete suggestions - turned off
let g:SuperTabCrMapping = 0

"Vim signature bindings
nnoremap [[ :call signature#marker#Goto('prev', 1, v:count)
nnoremap ]] :call signature#marker#Goto('next', 1, v:count)



let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_browser='Google Chrome'
let vim_markdown_preview_toggle=2


"EasyMotion overwin mappings
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

nmap <Leader>w <Plug>(easymotion-overwin-w)

"Jump anywhere with easy motion
let g:EasyMotion_re_anywhere = 'a' .
        \       '(<.|^$)' . '|' .
        \       '(.>|^$)' . '|' .
        \       '(\l)\zs(\u)' . '|' .
        \       '(_\zs.)' . '|' .
        \       '(#\zs.)'

"Mapped yank stack keys
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste
let g:yankstack_map_keys = 0

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab><tab>"
let g:UltiSnipsJumpForwardTrigger="<tab><tab>"
let g:UltiSnipsJumpB5ckwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"YouCompleteMe configurations
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"SuperTab default completion type
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_always_populate_location_list = 1 
"add Vcoolor color picker mapping
let g:vcoolor_map = '<C-u>'

"Use emmet only for html and css files 
let g:user_emmet_install_global = 0
augroup Emmet
  au!
autocmd Filetype html,css EmmetInstall
autocmd Filetype html,css imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
"Emmet for vim leader keymap
let g:user_emmet_leader_key='<leader>k'
augroup END
"<tab>
"Set space to visually select a word


"CtrlP config
let g:ctrlp_working_path_mode = 'ra'
let g:ctlp_max_files = 600
"search by file name by default
let g:ctrlp_by_filename = 1
"Allow CTRL p to show hidden files
let g:ctrlp_show_hidden = 1
"Add mapping for Gundo vim
nnoremap <F5> :GundoToggle<CR>
			
"Color the sign column dark grey by default
highlight SignColumn guibg=darkgrey

"Rainbow parens always on
let g:rainbow_active = 1 "0 is off by default and can be toggled
"Advanced rainbow parens config for future reference
    let g:rainbow_conf = {
    \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
    \   'operators': '_,_',
    \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \   'separately': {
    \       '*': {},
    \       'tex': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \       },
    \       'lisp': {
    \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
    \       },
    \       'vim': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \       },
    \       'html': 0,
    \       'css': 0,
    \   }
    \}

"NerdCommenter config
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1





"Set up libraries to highlight with library syntax highlighter
let g:used_javascript_libs = 'underscore,jquery,angularjs,react,jasmine,chai,handlebars'

"===================================================================================
"BASE16 Colors - changes a range of colors to appear more vivid 
"===================================================================================
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif



"Autocommands
"===================================================================================

"Saves files on switching tabs i.e losing focus
au FocusLost * :wa

augroup filetype_css
	autocmd!
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
augroup END
augroup filetype_javascript
	autocmd!
	autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
	autocmd FileType javascript :iabbrev <buffer> elif else if(){<CR>}<esc>3hi
	autocmd FileType javascript :iabbrev <buffer> iff if(){<CR>}<esc>hi
	
	autocmd FileType javascript :iabbrev <buffer> els else {<CR>}<esc>hi
	autocmd FileType javascript :iabbrev <buffer> cons console.log()

	autocmd FileType javascript :iabbrev <buffer> und undefined
	autocmd FileType js UltiSnipsAddFiletypes javascript-mocha javascript.es6.react
augroup END


augroup FileType_html	
	autocmd!
	autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
	autocmd BufNewFile, BufRead *.html setlocal nowrap :normal gg:G
augroup END

augroup FileType_markdown
	autocmd!
	autocmd BufNewFile, BufRead *.md setlocal spell spelllang=en_uk "Detect .md files as mark down
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

augroup FileType_text
	autocmd!
	autocmd FileType text setlocal textwidth=78
augroup END

augroup FileType_all
	autocmd!
	autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
	                \   exe "normal! g`\"" |
			            \ endif
augroup END

"Close vim if only window is a Nerd Tree
augroup FileType_all
	autocmd!
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END


augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
augroup END

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

"====================================================================================
"Spelling
"====================================================================================

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell
"Add spell checking local
setlocal spell spelllang=en_us
"-----------------------------------------------------------------
"Mappings
"-----------------------------------------------------------------
"Paste mode for large block of external text
set pastetoggle=<F2>
"time out on mapping after half a second, time out on key codes after a tenth
"of a second
set timeout timeoutlen=500 ttimeoutlen=100

"Create a horizontal split
"Not Working ATM!!!
nnoremap <C--> :sp<CR>
"Create a vertical split
nnoremap <C-\> :vsp<CR>
" Resize window vertically - grow
nnoremap <Leader>ff 20<c-w>+
" Resize window vertically  - shrink
nnoremap <Leader>ee 20<c-w>-
" Increase window size horizontally 
nnoremap <leader>f 20<c-w>>
" Decrease window size horizontally
nnoremap <leader>e 20<c-w><
" Max out the height of the current split
nnoremap <localleader>f <C-W>_
" Max out the width of the current split
nnoremap <localleader>e <C-W>|


"Normalize all split sizes, which is very handy when resizing terminal
nnoremap <leader>= <C-W>=
"Break out current window into new tabview
nnoremap <leader>t <C-W>T 
"Close every window in the current tabview but the current one
nnoremap <localleader>q <C-W>o
"Swap top/bottom or left/right split
nnoremap <localleader>r <C-W>R
nnoremap <localleader>m :tabnext<CR>
nnoremap <localleader>/ :tabprev<CR>

nnoremap <leader>x :lclose<CR>

"Indent a page of HTML (?works for other code)
nnoremap <C-G> gg=G<CR>
"Change operator arguments to a character representing the desired motion
"Moves to the previous set of parentheses and operate on its contents
onoremap il( :<c-u>normal! F)vi(<cr>
"Moves to the next set of parentheses and operate on its contents
onoremap in( :<c-u>normal! f(vi(<cr>
"Moves to the previous set of braces and operate on its contents
onoremap lb{ :<c-u>normal! F}vi{<cr>
"Moves to the next set of braces and operate on its contents
onoremap nb{ :<c-u>normal! f{vi{<cr>

onoremap p i(
onoremap pp i{
onoremap o a(
onoremap oo a{

"map window keys to leader
noremap <C-h> <c-w>h 
noremap <C-j> <c-w>j
noremap <C-k> <c-w>k
noremap <C-l> <c-w>l


"Remap arrow keys to do nothing
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

"key mappings
"Add delete in insert mode
inoremap <C-D> <esc>caw
"Move to the beginning of a word in insert mode
inoremap <C-B> <esc>bi
"Move to the end of a word in insert mode - added l due to jump back on
"escapping insert mode
inoremap <C-E> <esc>lwi
"Deletes and moves the line above
nnoremap _ ddkkp
"Deletes and replaces the line below
nnoremap - ddp
" Map jk to esc key - using jk prevents jump that using ii causes 
inoremap jk <ESC>
nnoremap jk <ESC>

" Yank text to the OS X clipboard
 noremap <leader>y "*y
 noremap <leader>yy "*Y


"Maps K and J to a 10 k and j but @= makes the motions multipliable - not
"a word I know
noremap K  @='10k'<CR>
noremap J  @='10j'<CR>
noremap .l  @='6l'<CR>
noremap .h  @='6h'<CR>

"This line opens the vimrc in a vertical split
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"This line allows the current file to source the vimrc allowing me use bindings as they're added
:nnoremap <leader>sv :source $MYVIMRC<cr>
"This maps leader quote (single or double to wrap the word in quotes)
:nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
:nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" :vnoremap <leader>' `><esc>a'<esc>v`>i'<esc>v
"Remap high and low keys to go to beginning and end of lines
:nnoremap H 0
:nnoremap L $
"Remapped high to hh low to ll middle is unchanged
" :nnoremap bu H 
:nnoremap ¬ L
:nnoremap ˙ H
"Map Q to remove a CR
:nnoremap Q J

"Terminal mappings to allow changing windows with Alt-h,j,k,l
if has("nvim")
:tnoremap <A-h> <C-\><C-n><C-w>h
:tnoremap <A-j> <C-\><C-n><C-w>j
:tnoremap <A-k> <C-\><C-n><C-w>k
:tnoremap <A-l> <C-\><C-n><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
endif


"Add neovim terminal escape with ESC mapping
if has("nvim")
:tnoremap <ESC> <C-\><C-n>
endif
"==============================================================
"Mouse 
"==============================================================
"Stop mouse scrolling
if !has('nvim')
" set  mouse=c
set mouse=a "this is the command that works for mousepad
noremap <ScrollWheelUp>      <nop>
noremap <S-ScrollWheelUp>    <nop>
noremap <C-ScrollWheelUp>    <nop>
noremap <ScrollWheelDown>    <nop>
noremap <S-ScrollWheelDown>  <nop>
noremap <C-ScrollWheelDown>  <nop>
noremap <ScrollWheelLeft>    <nop>
noremap <S-ScrollWheelLeft>  <nop>
noremap <C-ScrollWheelLeft>  <nop>
noremap <ScrollWheelRight>   <nop>
noremap <S-ScrollWheelRight> <nop>
noremap <C-ScrollWheelRight> <nop>
endif
"====================================================================================
"Buffer and Tab settings
"====================================================================================

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden


" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nnoremap <leader>n :enew<cr>
" Opens a new tab
nnoremap <localleader>n :tabnew<CR> 
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'

" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1

" Looper buffers
let g:buffergator_mru_cycle_loop = 1

nnoremap <Leader><LEFT> :BuffergatorMruCyclePrev leftabove vert sbuffer<CR> 
nnoremap <Leader><UP> :BuffergatorMruCyclePrev leftabove sbuffer<CR>
nnoremap <Leader><RIGHT> :BuffergatorMruCyclePrev rightbelow vert sbuffer<CR>
nnoremap <Leader><DOWN> :BuffergatorMruCyclePrev rightbelow sbuffer<CR> 
" Go to the previous buffer open
nmap <leader>/ :BuffergatorMruCyclePrev<cr>

" Go to the next buffer open
nmap <leader>m :BuffergatorMruCycleNext<cr>

" View the entire list of buffers open
nmap <leader>o :BuffergatorToggle<cr>

" Shared bindings from Solution #1 from earlier
nmap <leader>bq :bp <BAR> bd #<cr>

"The line below will re color the line numbers column if you want to
" hi LineNr   cterm=bold ctermbg=gray ctermfg=black gui=bold guibg=gray guifg=white


"Bindings for using buffers without buffergator
" " Move to the next buffer
" nmap ,m :bnext<CR>
"
" " Move to the previous buffer
" nmap ,k :bprevious<CR>
"
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nnoremap ,q :bp <BAR> bd #<CR>

" " Show all open buffers and their status
" nmap <leader>bl :ls<CR>

" ----------------------------------------------------------------------------
" Message output on vim actions
" ----------------------------------------------------------------------------

set shortmess-=f                      " (file x of x) instead of just (x of x)
set shortmess+=mnrxoOt
if has('patch-7.4.314')
  set shortmess+=c                    " Disable "Pattern not found" messages
endif

" ----------------------------------------------------------------------------
" Window splitting and buffers
" ----------------------------------------------------------------------------
set splitbelow "Open a horizontal split below current window
set splitright "Open a vertical split to the right of the window
set fillchars=vert:│                  " Vertical sep between windows (unicode)- ⣿
" reveal already opened files from the quickfix window instead of opening new
" buffers
set switchbuf=useopen

" ----------------------------------------------------------------------------
" Diffing
" ----------------------------------------------------------------------------

" Note this is += since fillchars was defined in the window config
set fillchars+=diff:⣿
set diffopt=vertical                  " Use in vertical diff mode
set diffopt+=filler                   " blank lines to keep sides aligned
set diffopt+=iwhite                   " Ignore whitespace changes
" ----------------------------------------------------------------------------
" Input auto-formatting (global defaults)
" Probably need to update these in after/ftplugin too since ftplugins will
" probably update it.
" ----------------------------------------------------------------------------
set formatoptions=
set formatoptions+=1
set formatoptions+=q                  " continue comments with gq"
set formatoptions+=c                  " Auto-wrap comments using textwidth
set formatoptions+=r                  " Continue comments by default
set formatoptions-=o                  " do not continue comment using o or O
set formatoptions+=n                  " Recognize numbered lists
set formatoptions+=2                  " Use indent from 2nd line of a paragraph

set nrformats-=octal " never use octal when <C-x> or <C-a>"
" ----------------------------------------------------------------------------
" Vim Path
" ----------------------------------------------------------------------------
"Vim searches recursively through all directories and subdirectories
set path+=**







" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode
" ----------------------------------------------------------------------------
set wildmenu
set wildmode=list:longest,full        " Complete files using a menu AND list
set wildignorecase
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
" set wildignore+=*.*~,*~
 set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

" ----------------------------------------------------------------------------
" Display
" --------------------------------------------------------------------------
set title                             " wintitle = filename - vim
"Using current terminal font - which is a patched nerd font
" set guifont=Inconsolata\ for\ Powerline\ Plus\ Nerd\ File\ Types:14
"Add relative line numbers
set number
"relative add set relativenumber to show numbers relative to the cursor
set numberwidth=3
"Turns on smart indent which can help indent files like html natively
set smartindent
set wrap
set textwidth=79
"Use one space, not two, after punctuation
set nojoinspaces

set autowrite "Automatically :write before running commands

set backspace=2 "Back space deletes like most programs in insert mode
if has('vim')
set signcolumn=yes "enables column that shows signs and error symbols
endif

set ruler
set incsearch

" Always display the status line even if only one window is displayed
set laststatus=2

" Use visual bell when there are errors not audio beep
set visualbell
"Reset color on quitting vim
" au VimLeave * !echo -ne""\033[0m"
"Setting the t_ variables if a further step to ensure 24bit colors
   if has('termguicolors') && !has('gui_running')
         set termguicolors
         " set Vim-specific sequences for RGB colors
         let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
         let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
 	           endif
" ------------------------------------
" Cursor
" ------------------------------------

"Set cursorline to the focused window only and change color/styling of cursor line depending on mode
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  "underline
  autocmd VimEnter,InsertEnter * highlight CursorLine cterm=none ctermbg=240 guibg=#0b2a2a
  autocmd InsertLeave * highlight CursorLine cterm=none ctermbg=240 guibg=#1C3956
  au WinLeave * setlocal nocursorline
augroup END
"         autocmd InsertEnter * highlight guibg=#0b2a2a guifg=NONE
"         autocmd InsertLeave * highlight CursorLine  guibg=#0129a0 guifg=NONE
" Show context around current cursor position
set scrolloff=8
set sidescrolloff=16

" Stops some cursor movements from jumping to the start of a line
set nostartofline

"================================================================================
"Whitespace
"================================================================================
"Display extra whitespace
" set list listchars=tab:»·,trail:·,nbsp:·,trail:·,nbsp:·
"Courtesy of vim casts - http://vimcasts.org/episodes/show-invisibles/
" set list
" set listchars=
" set listchars+=tab:▸\
" set listchars+=trail:·
" set listchars+=nbsp:⣿
" set listchars+=extends:»              " show cut off when nowrap
" set listchars+=precedes:«
"Invisible character colors 
"highlight NonText guifg=#4a4a59
"highlight SpecialKey guifg=#4a4a59
" augroup TrailingWhiteSpace
"         au!
" highlight ExtraWhitespace ctermbg=red guibg=red
" match ExtraWhitespace /\s\+$/
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()
" augroup END
" ------------------------------------
" Tab line
" ------------------------------------
" set tabline
" set showtabline=2

" ------------------------------------
" Command line
" ------------------------------------
"Show commands being input
set showcmd
" Set command line height to two lines
set cmdheight=1

"-----------------------------------------------------------------
"Abbreviations
"-----------------------------------------------------------------
iabbrev w@ www.akin-sowemimo.com



"-----------------------------------------------------------------
"Plugin configurations
"-----------------------------------------------------------------
"JsBeautify plugin activated here
noremap <c-f> :call JsBeautify()<cr>

"fugitive plugin 
set statusline+=%{fugitive#statusline()}
let g:EditorConfig_exclude_patterns = ['fugitive://.*']


"Syntastic config
set statusline+=%#warningmsg#
set statusline+={SyntasticStatuslineFlag()}
set statusline+=%*
" Change the syntastic windows height
let g:syntastic_loc_list_height = 2
let g:syntastic_enable_ballons=has('ballon_eval')
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_aggregate_errors=1
" let g:syntastic_auto_jump=1
let g:syntastic_error_symbol='☠️'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
" '⚠'
let g:syntastic_style_warning_symbol =  '💩'
"'✗'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn





 if !has('nvim') && has('syntax') && !exists('g:syntax_on')
   syntax enable
 endif
"-----------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------
"Set color Scheme
" colorscheme breezy
"Well Supported true color scheme - dark version background brown not
"black
" colorscheme one
" set background=dark
" Too soft but nice, the dark version is also not a black background vim error? my
" eyes are terrible??
" colorscheme quantum
" The Best and Most stable colorscheme
colorscheme OceanicNext
"Too Dark
" colorscheme base16-default-dark
"let g:quantum_contrast = 'high'
" let g:quantum_black  = 1

"=======================================================================
"Airline theme
"=======================================================================
let g:airline_theme='oceanicnext'
" let g:airline_theme='breezy'
" let g:airline_theme='quantum'
" let g:airline_theme='one'
" let g:quantum_italics = 1
" let g:one_allow_italics = 1


" ----------------------------------------------------------------------------
" Tabbing - overridden by editorconfig, after/ftplugin
" ----------------------------------------------------------------------------
set expandtab                         " default to spaces instead of tabs
set shiftwidth=2                      " softtabs are 2 spaces for expandtab

" Alignment tabs are two spaces, and never tabs. Negative means use same as
" shiftwidth (so the 2 actually doesn't matter).
set softtabstop=-2

" real tabs render width. Applicable to HTML, PHP, anything using real tabs.
" I.e., not applicable to JS.
set tabstop=2

" use multiple of shiftwidth when shifting indent levels.
" this is OFF so block comments don't get fudged when using ">>" and "<<"
set noshiftround

" When on, a <Tab> in front of a line inserts blanks according to
" 'shiftwidth'. 'tabstop' or 'softtabstop' is used in other places.
set smarttab

"set backspace=indent,eol,start


"Add vim sensible config options

if !has('nvim')
set complete-=i
set autoindent
endif




" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-I>', 'n') ==# ''
  nnoremap <silent> <C-I> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-I>
endif

" if !&scrolloff
"           set scrolloff=1
"                   endif
" if !&sidescrolloff
"         set sidescrolloff=5
"                     endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
	set encoding=utf-8
      		endif

" if &listchars ==# 'eol:$'
"   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
"     endif




if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

set autoread " reload files if they were edited elsewhere

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" set formatoptions=qrn1


let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'





"Turn swap files off - FOR GOD's SAKE they are ruining my life
set noswapfile
set nobackup
"This saves all back up files in a vim backup directory
set backupdir=~/.vim/.backup//
" set directory=~/.vim/.swp//
set undodir=~/.vim/.undo//

if has("vms")
set nobackup
	 else
set backup
	endif
set history=50

" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------
set matchtime=1 " tenths of a second
set showmatch "briefly jump to ?matching parens
" Sets a case insensitive search except when using Caps
set ignorecase
set smartcase
set wrapscan " Searches wrap around the end of the file
set hlsearch

