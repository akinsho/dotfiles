" ________  ___  __    ___  ________   ________           ________  ________  ________   ________ ___  ________
"|\   __  \|\  \|\  \ |\  \|\   ___  \|\   ____\         |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\
"\ \  \|\  \ \  \/  /|\ \  \ \  \\ \  \ \  \___|_        \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|
" \ \   __  \ \   ___  \ \  \ \  \\ \  \ \_____  \        \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___
"  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \        \ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \
"   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \        \ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
"    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\        \|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|
"                                        \|_________|


"Sections of this vimrc can be folded or unfolded using za, they are marked with 3 curly braces

set nocompatible "IMproved, required
filetype off " required  Prevents potential side-effects
" from system ftdetects scripts
"This command makes vim start a file with all folds closed
set foldlevelstart=0
"-----------------------------------------------------------
"Plugins
"-----------------------------------------------------------{{{
"This will autoinstall vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


"set the runtime path to include Vundle and initialise
call plug#begin('~/.vim/plugged')

"youcomplete me trial
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py','on': [] }
" autocmd InsertEnter * call plug#load('YouCompleteMe','ultisnips')

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
"Premature optimisation -_-
" augroup load_ultisnips_YouCompleteMe
"   autocmd!
"   autocmd InsertEnter * call plug#load('ultisnips')
"         \| autocmd! load_ultisnips_YouCompleteMe
" augroup END

" Ale  Async Linting as you type
Plug 'w0rp/ale'
"Added vim snippets for code autofilling
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
  Plug 'isRuslan/vim-es6'
  Plug 'epilande/vim-react-snippets'
"Added nerdtree filetree omnitool : )
Plug 'scrooloose/nerdtree'
"Added vim surround for enclosing with parens
Plug 'tpope/vim-surround'
" Add fugitive git status and command plugins
Plug 'tpope/vim-fugitive'
" Adds file manipulation functionality
Plug 'tpope/vim-eunuch'
"Added Editor Config plugin to maintain style choices
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
"Added emmet vim plugin
Plug 'mattn/emmet-vim'
"Add delimitmate
Plug 'Raimondi/delimitMate'
"Added javascript lib - syntax highlighting for popular libraries
Plug 'othree/javascript-libraries-syntax.vim'
" Added yet another js syntax highlighter - Not greater for performance
" Plug 'othree/yajs.vim',{ 'for': 'javascript' }  "THIS PLUGIN IS A FORK of jelera vim-javascript-syntax don't install both!!!!
"Added node.vim plugin
Plug 'moll/vim-node'
"Added easy motions
Plug 'easymotion/vim-easymotion'
"Added vim polyglot a collection of language packs for vim
Plug 'sheerun/vim-polyglot'
"Autocorrects 4,000 common typos
Plug 'chip/vim-fat-finger'
"Add proper markdown syntax and indentation plugin
Plug 'gabrielelana/vim-markdown'
"Added color picker plugin
Plug 'KabbAmine/vCoolor.vim'
"Add Tern for autocompletion
function! BuildTern(info)
  if a:info.status == 'installed' || a:info.force
    !npm install
  endif
endfunction
Plug 'ternjs/tern_for_vim',{'do':function('BuildTern')}
"Add Gundo - undo plugin for vim
Plug 'sjl/gundo.vim'
"Tim pope's surround plugin allows . to repeat more actions
Plug 'tpope/vim-repeat'
"Added yankstack a lighter weight version of yankring
Plug 'maxbrunsfeld/vim-yankstack'
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator'
" A fun start up sceen for vim
Plug 'mhinz/vim-startify'
"FZF improved wrapper by June Gunn + the man who maintains syntastic
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" Autoformatter
Plug 'Chiel92/vim-autoformat'
"Add a GitGutter to track new lines re git file
Plug 'airblade/vim-gitgutter'
"Plug to create diff window and Gstatus window on commit
Plug 'rhysd/committia.vim'
"Vimux i.e send commands to a tmux split
Plug 'benmills/vimux'
"Vim signature re-added because I need to see my bloody marks
Plug 'kshenoy/vim-signature'
"Adds cursor change and focus events to tmux vim
Plug 'sjl/vitality.vim'
"Better indentation in JS
" Plug 'vim-scripts/JavaScript-Indent', { 'for': 'javascript' }
"Added June Gunn's alignment plugin
Plug 'junegunn/vim-easy-align'
"Github dashboard for vim
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }
"Start up time monitor
" Plug 'tweekmonster/startuptime.vim'
"Database manipulation in vim
Plug 'vim-scripts/dbext.vim'
"Capslock without a capslock key in vim
Plug 'tpope/vim-capslock'
"ES-lint fix
Plug 'josudoey/vim-eslint-fix'
"Google in vim
Plug 'szw/vim-g'

"Text Objects =====================
"Text object library plugin for defining your own text objects
Plug 'kana/vim-textobj-user'
"Text obj for comments
Plug 'glts/vim-textobj-comment'
" Add text objects form camel cased strings (should be native imho)
Plug 'bkad/CamelCaseMotion' "uses a prefix of the leader key to implement text objects e.g. ci<leader>w will change all of one camelcased word
" Add text object for indented code = 'i' i.e dii delete inner indented block
Plug 'michaeljsmith/vim-indent-object'
"Very handy plugins and functionality by Tpope (ofc)
Plug 'tpope/vim-unimpaired'
"Peace and Quiet thanks JGunn
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
" All encompasing v
Plug 'terryma/vim-expand-region'
"Moar textobjs
Plug 'wellle/targets.vim'
"Function text object js
Plug 'thinca/vim-textobj-function-javascript'
"Block object courtesy of JGunn
" Plug 'rhysd/vim-textobj-anyblock'


"Coding tools =======================
"Add JSDocs plugin
Plug 'heavenshell/vim-jsdoc'
"Add Tagbar Plugin
Plug 'majutsushi/tagbar'
"Add Plugin to manage tag files
Plug 'ludovicchabant/vim-gutentags'
"Vim HARDMODE ----------------------
Plug 'wikitopian/hardmode'

"Visuals ===============================
" toggles line numbering depending on current mode
" Plug 'myusuf3/numbers.vim'
"Filetype Plugins ======================
"Add better markdown previewer
Plug 'shime/vim-livedown'


"Status/bufferline =====================
"Added vim airline
Plug 'vim-airline/vim-airline'
"Added airline themes"
Plug 'vim-airline/vim-airline-themes'


"Themes ===============================
" A plugin for managing vim themes
Plug 'reedes/vim-thematic'
"vim sialoquent theme
Plug 'davidklsn/vim-sialoquent'
"Colorsheme solarized 8
Plug 'lifepillar/vim-solarized8'
"Colorscheme - OneDark
Plug 'joshdick/onedark.vim'
" Add new theme trial purposes ofc
Plug 'rhysd/vim-color-spring-night'
"Added oceanic next theme
Plug 'mhartington/oceanic-next'
"Quantum theme
Plug 'tyrannicaltoucan/vim-quantum'

"Added SyntaxComplete for more syntax completion
Plug 'vim-scripts/SyntaxComplete'
" NVIM colorscheme
" Plug 'rakr/vim-one'
"Vim obsession Tpope's amazing plugin for managing sessions
" Plug 'tpope/vim-obsession'
"Closes tags with > command
" Plug 'alvan/vim-closetag'

"Add file type icons to vim
Plug 'ryanoasis/vim-devicons' " This Plugin must load after the others


call plug#end()

filetype plugin indent on

"Added built in match it plugin to vim
packadd! matchit

"!!!This line is key to making vim work in tmux
" if !has('gui_running') && !has('nvim')
"   set term=screen-256color
" endif

syntax enable
"}}}
"====================================================================================
"Leader bindings
"====================================================================================

"Remap leader key
let mapleader = ","
"Local leader key
let maplocalleader = "\<space>"
"--------------------------------------------------------------------------------------------------
"Plugin Mappings
"--------------------------------------------------------------------------------------------------{{{
"-----------------------------------------------------------
"     ALE
"-----------------------------------------------------------
let g:ale_sign_column_always = 1
let g:ale_sign_error         = '✖️'
let g:ale_sign_warning       = '⚠️'
" '>>'
" highlight clear ALEErrorSign
" highlight clear ALEWarningSig
let g:ale_set_highlights = 0
nmap <silent> <C-/> <Plug>(ale_previous_wrap)
nmap <silent> <C-\> <Plug>(ale_next_wrap)

"-----------------------------------------------------------
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <C-F> :Autoformat<CR>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vnoremap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" nnoremap ¬ :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>
set conceallevel=1
let g:javascript_conceal_arrow_function = "⇒"


let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  " Additional settings
  setlocal spell

  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    startinsert
  end

  " Scroll the diff window from insert mode
  " Map <C-n> and <C-p>
  imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
  imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)

endfunction


"Toggle Tagbar
nnoremap <leader>2 :TagbarToggle<CR>

"Vimux ==========================================================
"Tell vimux to run commands in a new split
let VimuxUseNearest = 1
nnoremap <F5> :call VimuxRunCommand('browse')<CR>
" Prompt for a command to run
nnoremap <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
nnoremap <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
nnoremap <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
nnoremap <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
nnoremap <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
nnoremap <Leader>vz :call VimuxZoomRunner()<CR>



"Vim-Signature ==================================================

let g:SignatureMarkTextHLDynamic=1
nnoremap [1 :call signature#marker#Goto('next', 1, v:count)
nnoremap ]1 :call signature#marker#Goto('prev', 1, v:count)
"NERDTree
" =============================================
" Ctrl+N to toggle Nerd Tree
nnoremap <C-N> :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
let g:NERDTreeDirArrowExpandable      = '├'
let g:NERDTreeDirArrowCollapsible     = '└'
let NERDTreeQuitOnOpen                = 1
let NERDTreeMinimalUI                 = 1
let NERDTreeDirArrows                 = 1
let NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeShowBookmarks           = 1
let NERDTreeAutoDeleteBuffer          = 1
let NERDTreeShowHidden                = 1 "Show hidden files by default
let NERDTreeChDirMode                 = 2

"===================================================
"EasyMotion mappings
"===================================================
let g:EasyMotion_do_mapping = 0 "Disable default mappings
" Use uppercase target labels and type as a lower case
" let g:EasyMotion_use_upper  1
" type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1
" keep cursor column when jumping
let g:EasyMotion_startofline = 0
"Use easy motion to search
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" Jump to anwhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)
map <leader>f <Plug>(easymotion-f)
nmap <leader>f <Plug>(easymotion-overwin-f)
" Bidirectional & within line 't' motion
" omap t <Plug>(easymotion-bd-tl)
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"Mapped yank stack keys
let g:yankstack_map_keys = 0
let g:yankstack_yank_keys = ['y', 'd']
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste


"add Vcoolor color picker mapping
let g:vcoolor_map = '§'
"=======================================================================
"                    EMMET for Vim
"=======================================================================
"Use emmet only for html and css files - Great config option although having
"emmet when writing jsx is super helpful, so I just changed the bindings
" let g:user_emmet_install_global = 0
" augroup Emmet
"   au!
" autocmd Filetype html,css EmmetInstall
" autocmd Filetype html,css imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
" augroup END
"Emmet for vim leader keymap
let g:user_emmet_leader_key     = "<s-tab>"
let g:user_emmet_expandabbr_key = '<C-y>'

"Add mapping for Gundo vim
nnoremap <leader>u :GundoToggle<CR>


"Set up libraries to highlight with library syntax highlighter
" let g:used_javascript_libs = 'underscore,jquery,angularjs,react,jasmine,chai,handlebars'
"}}}
"====================================================================================
"Autocommands
"==================================================================================={{{
" Close help and git window by pressing q.
augroup quickfix_menu_quit
  au!
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

  "this is is intended to stop insert mode bindings slowing down <bs> and <cr>
  augroup Map_timings
    au!
    autocmd InsertEnter * set timeoutlen=200
    autocmd InsertLeave * set timeoutlen=500
  augroup END



  augroup CheckOutsideTime - "excellent function but implemented by terminus
    autocmd!
    " automatically check for changed files outside vim
    autocmd WinEnter,BufRead,BufEnter,FocusGained * silent! checktime
  augroup end

  " Disable paste.
  augroup Cancel_Paste
    au!
    autocmd InsertLeave *
          \ if &paste | set nopaste | echo 'nopaste' | endif
  augroup END

  augroup reload_vimrc
    autocmd!
    autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
  augroup END

  " automatically leave insert mode after 'updatetime' milliseconds of inaction
  au! InsertEnter * let updaterestore=&updatetime | set updatetime=10000
  au! InsertLeave * let &updatetime=updaterestore

  "Saves files on switching tabs i.e losing focus
  au FocusLost * :wa
  augroup VimResizing
    au!
    "Command below makes the windows the same size on resizing !? Why?? because
    "its tidier
    autocmd VimResized * wincmd =
    autocmd FocusLost * :wa
    " autocmd VimResized * :redraw! | :echo 'Redrew'
  augroup END


  augroup filetype_completion
    au!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=tern#Complete
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  augroup END


  augroup filetype_javascript
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
    autocmd FileType javascript :iabbrev <buffer> elif else if(){<CR>}<esc>3hi
    autocmd FileType javascript :iabbrev <buffer> iff if(){<CR>}<esc>hi

    autocmd FileType javascript :iabbrev <buffer> els else {<CR>}<esc>hi
    autocmd FileType javascript :iabbrev <buffer> cons console.log()

    autocmd FileType javascript :iabbrev <buffer> und undefined


    "don't use cindent for javascript
    autocmd Filetype javascript setlocal nocindent
    "Folding autocommands for javascript
    " autocmd FileType javascript,javascript.jsx setlocal foldmethod=indent foldlevel=1
    " autocmd Filetype javascript setlocal foldlevelstart=1
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
    autocmd BufNewFile,BufRead *.md :onoremap <buffer>ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd BufNewFile,BufRead *.md :onoremap <buffer>ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
    autocmd BufNewFile,BufRead *.md :onoremap <buffer>aa :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>
    autocmd BufNewFile,BufRead *.md :onoremap <buffer>ia :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>
  augroup END

  augroup filetype_vim
    "Vimscript file settings -------------------------
    au!
    autocmd FileType vim setlocal foldmethod=marker
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
  "}}}
  "====================================================================================
  "Spelling
  "====================================================================================

  " Set spellfile to location that is guaranteed to exist, can be symlinked to
  " Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
  set spellfile=$HOME/.vim-spell-en.utf-8.add

  " Autocomplete with dictionary words when spell check is on
  set complete+=kspell
  "Add spell checking local
  " setlocal spell spelllang=en_us
  "-----------------------------------------------------------------------------------
  "Mappings
  "-----------------------------------------------------------------------------------{{{

  " nnoremap <CR> G
  nnoremap <BS> gg
  "Change operator arguments to a character representing the desired motion
  nnoremap ; :
  nnoremap : ;

  nnoremap [Alt]   <Nop>
  xnoremap [Alt]   <Nop>
  " nmap    e  [Alt]
  " xmap    e  [Alt]
  " Like gv, but select the last changed text.
  nnoremap gi  `[v`]
  " Specify the last changed text as {motion}.
  " vnoremap <silent> gi  :<C-u>normal gc<CR>
  " onoremap <silent> gi  :<C-u>normal gc<CR>"`
  " Capitalize.
  nnoremap gu <ESC>gUiw`]
  inoremap <C-u> <ESC>gUiw`]a

  " Smart }."
  nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
  onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
  xnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
  function! ForwardParagraph()
    let cnt = v:count ? v:count : 1
    let i = 0
    while i < cnt
      if !search('^\s*\n.*\S','W')
        normal! G$
        return
      endif
      let i = i + 1
    endwhile
  endfunction
  " Select rectangle.
  xnoremap r <C-v>
  " 'quote'
  " onoremap aq  a'
  " xnoremap aq  a'
  " onoremap iq  i'
  " xnoremap iq  i'

  " \"double quote"
  " onoremap ad  a"
  " xnoremap ad  a"
  " onoremap id  i"
  " xnoremap id  i"

  " <angle>
  onoremap aa  a>
  xnoremap aa  a>
  onoremap ia  i>
  xnoremap ia  i>
  "Change two vertically split windows to horizontal splits
  nnoremap <LocalLeader>h <C-W>t <C-W>K
  nnoremap <LocalLeader>v <C-W>t <C-W>H
  "Change two horizontally split windows to vertical splits

  "Select txt that has just been read or pasted in
  nnoremap gV `[V`]

  "Bubbling text a la vimcasts - http://vimcasts.org/episodes/bubbling-text/
  " Better bubbling a la Tpope's unimpaired vim
  nmap ˚ [e
  nmap ∆ ]e
  vmap ˚ [egv
  vmap ∆ ]egv


  " Line completion - native vim
  inoremap ç <C-X><C-L>

  "Replace current word with last deleted word
  nnoremap S diw"0P

  " make . work with visually selected lines
  vnoremap . :norm.<CR>

  "Maps moving to match as moving and visually selecting along the way
  " nnoremap % v%
  nnoremap <LocalLeader>s :update<CR>
  inoremap ß <esc>:update<CR>

  "This mapping alternates between variants of number and relative number
  nnoremap <F4> :exec &nu==&rnu? "se nu!" : "se rnu!"<CR>
  "This mapping allows yanking all of a line without taking the new line
  "character as well can be with our without spaces
  vnoremap <silent> al :<c-u>norm!0v$h<cr>
  vnoremap <silent> il :<c-u>norm!^vg_<cr>
  onoremap <silent> al :norm val<cr>
  onoremap <silent> il :norm vil<cr>

  "ctrl-o in insert mode allows you to perform one normal mode command then
  "returns to insert mode
  " inoremap <C-j> <Down>
  inoremap ∆ <Down>
  inoremap <C-h> <left>
  inoremap ˚ <up>
  inoremap <C-l> <right>

  " select last paste in visual mode
  " nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

  nnoremap <F6> :! open %<CR>
  "nnoremap <F3> :!open -a safari %<CR>

  "automatically at present
  set pastetoggle=<F2>
  "time out on mapping after half a second, time out on key codes after a tenth
  "of a second
  set timeout timeoutlen=500 ttimeoutlen=100

  " Remap jumping to the lask spot you were editing previously to bk as this is
  " easier form me to remember
  nnoremap bk `.

  " Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$
  nnoremap <leader>sw :b#<CR>
  "--------------------------------------------
  " FZF bindings
  "--------------------------------------------
  nnoremap <silent> <localleader>o :Buffers<CR>
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-j> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)

  " Launch file search using FZF
  nnoremap <C-P> :FZFR <CR>
  nnoremap \ :Ag<CR>
  "--------------------------------------------

  " Zoom current split
  nnoremap <leader>1 <C-W><Bar>
  " nnoremap  <leader>2 <C-W>_
  " Quick find/replace
  nnoremap <Leader>[ :%s/<C-r><C-w>/
  vnoremap <Leader>[ "zy:%s/<C-r><C-o>"/

  "This allows me to use control-f to jump out of a newly matched pair (courtesty
  "of delimitmate)
  imap <C-F> <C-g>g
  "--------------------------------------------
  "Absolutely fantastic function from stoeffel/.dotfiles which allows you to
  "repeat macros across a visual range
  "--------------------------------------------
  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
  "--------------------------------------------

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv
  "Help Command - vertical split
  command! -complete=help -nargs=1 H call VerticalHelp(<f-args>)
  function! VerticalHelp(topic)
    execute "vertical botright help " . a:topic
    execute "vertical resize 78"
  endfunction
  "--------------------------------------------
  "Fugitive bindings
  nnoremap <leader>gs :Gstatus<CR>
  nnoremap <leader>gd :Gdiff<CR>
  nnoremap <leader>gc :Gcommit<CR>
  nnoremap <leader>gp :Gpush<CR>
  "--------------------------------------------
  "Remap back tick for jumping to marks more quickly
  nnoremap ' `
  nnoremap ` '

  nnoremap rs ^d0
  nnoremap qa :wqa<CR>
  " clean up any trailing whitespace
  nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
  "Save all files
  "open a new file in the same directory
  nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

  "Open command line window
  nnoremap <localleader>c :<c-f>

  nnoremap <localleader>l :redraw!<cr>
  "--------------------------------------------
  " Window resizing bindings
  "--------------------------------------------
  "
  "Create a horizontal split
  nnoremap _ :sp<CR>
  "Create a vertical split
  nnoremap \| :vsp<CR>
  " Resize window vertically  - shrink
  nnoremap <down> 15<c-w>-
  " Resize window vertically - grow
  nnoremap <up>ff 15<c-w>+
  " Increase window size horizontally
  nnoremap <left> 15<c-w>>
  " Decrease window size horizontally
  nnoremap <right> 15<c-w><
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
  nnoremap <leader>r <C-W>R
  "--------------------------------------------

  nnoremap <leader>x :lclose<CR>
  "Indent a page of HTML (?works for other code)
  nnoremap <C-G> gg=G<CR>

  "map window keys to leader - Interfere with tmux navigator
  " noremap <C-h> <c-w>h
  " noremap <C-j> <c-w>j
  " noremap <C-k> <c-w>k
  " noremap <C-l> <c-w>l


  "Remap arrow keys to do nothing
  " nnoremap <up> <nop>
  " nnoremap <down> <nop>
  " nnoremap <left> <nop>
  " nnoremap <right> <nop>
  inoremap <up> <nop>
  inoremap <down> <nop>
  inoremap <left> <nop>
  inoremap <right> <nop>
  nnoremap j gj
  nnoremap k gk

  "key mappings
  "Remaps the binding to increment numbers to <leader>a and to decrement to å

  nnoremap <silent> <Leader>a <C-A>
  nnoremap <silent> å <C-X>

  "Moves cursor back to the start of a line
  inoremap <C-B> <C-O>I
  "Remaps native ctrl h - emulates backspace to ctrl d
  inoremap <C-D> <C-H>
  "Remaps native ctrl k - deleting to the end of a line to control e
  " inoremap <C-Q> <C-K>

  " Map jk to esc key - using jk prevents jump that using ii causes
  inoremap jk <ESC>
  nnoremap jk <ESC>

  " Yank text to the OS X clipboard
  noremap <localleader>y "*y
  noremap <localleader>yy "*Y


  "Maps K and J to a 10 k and j but @= makes the motions multipliable - not
  "a word I know
  noremap K  @='10k'<CR>
  noremap J  @='10j'<CR>

  "This line opens the vimrc in a vertical split
  nnoremap <leader>ev :vsplit $MYVIMRC<cr>
  nnoremap <localleader>ev :e $MYVIMRC<cr>

  "This line allows the current file to source the vimrc allowing me use bindings as they're added
  nnoremap <leader>sv :source $MYVIMRC<cr>
  "This maps leader quote (single or double to wrap the word in quotes)
  nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
  nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

  nnoremap <leader>< viw<esc>a ><esc>bi<<esc>lel
  " Remap going to beginning and end of lines
  " move to beginning/end of line
  nnoremap H ^
  nnoremap L $

  "Map Q to remove a CR
  nnoremap Q J

  "Terminal mappings to allow changing windows with Alt-h,j,k,l
  if has("nvim")
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
  endif


  "Add neovim terminal escape with ESC mapping
  if has("nvim")
    :tnoremap <ESC> <C-\><C-n>
  endif
  "}}}

  "===================================================================================
  "Mouse
  "==================================================================================={{{
  set mousehide

  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  "Stop mouse scrolling
  if !has('nvim')
    " set  mouse=c
    set mouse=a "this is the command that works for mousepad
    "Disable this to allow scrolling in vim
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
  "}}}
  "====================================================================================
  "Buffer and Tab settings
  "===================================================================================={{{
  " This allows buffers to be hidden if you've modified a buffer.
  " This is almost a must if you wish to use buffers in this way.
  set nohidden


  " To open a new empty buffer
  " This replaces :tabnew which I used to bind to this mapping
  nnoremap <leader>n :enew<cr>
  " Opens a new tab
  nnoremap <localleader>n :tabnew<CR>

  " Shared bindings from Solution #1 from earlier
  nmap <leader>bq :bp <BAR> bd #<cr>

  " Close the current buffer and move to the previous one
  " This replicates the idea of closing a tab
  nnoremap ,q :bp <BAR> bd #<CR>

  " " Show all open buffers and their status
  " nmap <leader>bl :ls<CR>

  "}}}
  " ----------------------------------------------------------------------------
  " Message output on vim actions
  " ----------------------------------------------------------------------------

  set shortmess=at
  " set shortmess+=mnrxoOta
  " set shortmess-=f                      " (file x of x) instead of just (x of x)
  if has('patch-7.4.314')
    set shortmess+=c                    " Disable 'Pattern not found' messages
  endif

  " ----------------------------------------------------------------------------
  " Window splitting and buffers
  " ----------------------------------------------------------------------------
  " Set minimal width for current window.
  set winwidth=30
  set splitbelow "Open a horizontal split below current window
  set splitright "Open a vertical split to the right of the window
  set fillchars=vert:│                  " Vertical sep between windows (unicode)- ⣿
  " reveal already opened files from the quickfix window instead of opening new
  " buffers
  set switchbuf=useopen

  " ----------------------------------------------------------------------------
  " Diffing
  " ----------------------------------------------------------------------------{{{

  " Note this is += since fillchars was defined in the window config
  set fillchars+=diff:⣿
  set diffopt=vertical                  " Use in vertical diff mode
  set diffopt+=filler                   " blank lines to keep sides aligned
  set diffopt+=iwhite                   " Ignore whitespace changes
  "}}}
  " ----------------------------------------------------------------------------{{{
  "             Format options
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

  set nrformats-=octal " never use octal when <C-x> or <C-a>"
  "}}}
  " ----------------------------------------------------------------------------
  " Vim Path
  " ----------------------------------------------------------------------------
  "Vim searches recursively through all directories and subdirectories
  set path+=**
  " set autochdir

  " ----------------------------------------------------------------------------
  " Wild and file globbing stuff in command mode
  " ----------------------------------------------------------------------------{{{
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

  "}}}
  " ----------------------------------------------------------------------------
  " Display
  " --------------------------------------------------------------------------{{{
  " This prevents a scratch buffer from being opened
  set completeopt-=preview
  set title                             " wintitle = filename - vim
  " Match parentheses coloring
  " highlight MatchParen  guibg=#658494 gui=bold

  "Add relative line numbers and relative = absolute line numbers i.e current
  "lines shows absolute and all others are relative
  set ttyfast " Improves smoothness of redrawing when there are multiple windows

  set relativenumber
  set number

  set linespace=4
  "relative add set relativenumber to show numbers relative to the cursor
  set numberwidth=5
  "Turns on smart indent which can help indent files like html natively
  set smartindent
  set wrap
  " This should cause lines to wrap around words rather than random characters
  set linebreak
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
  " set laststatus=2

  " Turns on lazyredraw which postpones redrawing for macros and command
  " execution
  set lazyredraw

  " Use visual bell when there are errors not audio beep
  set visualbell
  "Reset color on quitting vim
  " au VimLeave * !echo -ne""\033[0m"
  "Setting the t_ variables if a further step to ensure 24bit colors
  if has('termguicolors')
    " && !has('gui_running')
    set termguicolors
    " set vim-specific sequences for rgb colors
    "super important for truecolor support in vim
    let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
    " set t_8b="^[[48;2;%lu;%lu;%lum"
    " set t_8f="^[[38;2;%lu;%lu;%lum"
  endif
  "}}}
  "================================================================================
  "Whitespace
  "================================================================================
  " ------------------------------------
  " Command line
  " ------------------------------------
  "Show commands being input
  set showcmd
  " Set command line height to two lines
  set cmdheight=2

  "-----------------------------------------------------------------
  "Abbreviations
  "-----------------------------------------------------------------
  iabbrev w@ www.akin-sowemimo.com

  if &statusline ==# ''
    set statusline=
  endif

  "------------------------------------
  "  Tab line
  "------------------------------------
  "Setting show tabline causes tabline to redraw without highlighting
  set showtabline=2
  "fugitive plugin
  let g:EditorConfig_exclude_patterns = ['fugitive://.*']

  "-----------------------------------------------------------------
  "Plugin configurations
  "-----------------------------------------------------------------{{{
  let g:github_dashboard = {
        \'username': 'Akin909',
        \'password': $GITHUB_TOKEN
        \}
  nnoremap <F1> :GHDashboard! Akin909<CR>

".vimrc
function! PrettyFile()
  if &filetype=="javascript"
    if exists('g:loaded_Beautifier')
      call JsBeautify()
    endif
    if exists('g:loaded_ESLintFix')
      call ESLintFix()
    endif
  end
endfunction

"pretty the file before saving.
autocmd BufWritePre * execute 'call PrettyFile()'


  " let g:vitality_insert_cursor = 0
  "------------------------------------
  " Goyo
  "------------------------------------
  nnoremap <F3> :Goyo<CR>
  function! s:goyo_enter()
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    set noshowmode
    set noshowcmd
    set scrolloff=999
  endfunction

  function! s:goyo_leave()
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    set showmode
    set showcmd
    set scrolloff=5
  endfunction

  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()

  " Goyo
  function! s:auto_goyo()
    if &ft == 'markdown' && winnr('$') == 1
      Goyo 80
    elseif exists('#goyo')
      Goyo!
    endif
  endfunction

  function! s:goyo_markdown_leave()
    if winnr('$') < 2
      silent! :q
    endif
  endfunction

  "Not Working as intended at the moment as ?Loading Ultisnips on opening
  "insert mode cancels goyo
  augroup goyo_markdown
    autocmd!
    autocmd BufNewFile,BufRead * call s:auto_goyo()
    autocmd! User GoyoLeave nested call s:goyo_leave()
  augroup END

  let g:markdown_fenced_languages = ['javascript', 'sql']

  let g:UltiSnipsSnippetDirectories=["UltiSnips", "mySnippets"]
  let g:UltiSnipsExpandTrigger="<C-J>"
  " let g:UltiSnipsExpandTrigger="<c-tab>"
  let g:UltiSnipsJumpForwardTrigger="<C-J>"
  let g:UltiSnipsListSnippets="<s-tab>"
  let g:UltiSnipsJumpBackwardTrigger="<C-K>"
  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"

  " should markdown preview get shown automatically upon opening markdown
  " buffer
  let g:livedown_autorun = 1
  " should the browser window pop-up upon previewing
  let g:livedown_open = 1
  " the port on which Livedown server will run
  let g:livedown_port = 1337
  nnoremap gm :LivedownToggle<CR>

  let delimitMate_expand_cr = 1
  let delimitMate_expand_space = 0
  let delimitMate_jump_expansion = 1
  let delimitMate_balance_matchpairs = 1

  nnoremap <F9> <Esc>:call ToggleHardMode()<CR>

  let g:textobj_comment_no_default_key_mappings = 1
  xmap ac <Plug>(textobj-comment-a)
  omap ac <Plug>(textobj-comment-a)
  xmap ic <Plug>(textobj-comment-i)
  omap ic <Plug>(textobj-comment-i)

  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }

  " Customize fzf colors to match your color scheme
  let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }


  "This  function makes FZF start from the root of a git dir
  function! s:find_root()
    for vcs in ['.git', '.svn', '.hg']
      let dir = finddir(vcs.'/..', ';')
      if !empty(dir)
        execute 'FZF' dir
        return
      endif
    endfor
    FZF
  endfunction

  command! FZFR call s:find_root()

  let g:jsdoc_allow_input_prompt = 1
  let g:jsdoc_input_description = 1
  let g:jsdoc_enable_es6 = 1
  nmap <silent> co <Plug>(jsdoc)
  " nmap <silent> co ?function<cr>:noh<cr><Plug>(jsdoc)


  let g:vimjs#smartcomplete = 1
  " Disabled by default. Enabling this will let vim complete matches at any location
  " e.g. typing 'document' will suggest 'document' if enabled.
  let g:vimjs#chromeapis = 1
  " Disabled by default. Toggling this will enable completion for a number of Chrome's JavaScript extension APIs

  set updatetime=250

  " after a re-source, fix syntax matching issues (concealing brackets):
  if exists('NERDTree')
    if exists('g:loaded_webdevicons')
      call webdevicons#refresh()
    endif
  endif

  let g:startify_session_dir = '~/.vim/session'
  let g:startify_session_autoload = 1
  let g:startify_session_persistence = 1
  let g:startify_change_to_vcs_root = 1

  "Rebound git commands to manipulate hunks that are staged to allow comment
  "object to work
  omap ig <Plug>GitGutterTextObjectInnerPending
  omap ag <Plug>GitGutterTextObjectOuterPending
  xmap ig <Plug>GitGutterTextObjectInnerVisual
  xmap ag <Plug>GitGutterTextObjectOuterVisual

  "This sets default mapping for camel case text object
  call camelcasemotion#CreateMotionMappings('<leader>')

  function! WrapForTmux(s)
    if !exists('$TMUX')
      return a:s
    endif

    let tmux_start = "\<Esc>Ptmux;"
    let tmux_end = "\<Esc>\\"

    return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
  endfunction

  let &t_SI .= WrapForTmux("\<Esc>[?2004h")
  let &t_EI .= WrapForTmux("\<Esc>[?2004l")

  function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

  " View the entire list of buffers open
  nmap <leader>o :BuffergatorToggle<cr>



  "   Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1
  "   saves on moving pane but only the currently opened buffer if changed
  let g:tmux_navigator_save_on_switch = 2
  "   filenames like *.xml, *.html, *.xhtml, ...
  let g:closetag_filenames = "*.js,*.html,*.xhtml,*.phtml"


  " remap alt-H,J to change buffers
  nnoremap ¬ :bprev<CR>
  nnoremap ˙ :bnext<CR>

  "=============================================================
  "               Airline
  "=============================================================
  " 'obsession'
  let g:airline_extensions = ['branch','tabline','ale']
  let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
  let g:airline_detect_iminsert                  = 1
  let g:airline_detect_crypt                     = 0 " https://github.com/vim-airline/vim-airline/issues/792
  let g:airline_powerline_fonts                  = 1
  let g:airline#extensions#tabline#enabled       = 1
  " let g:airline#extensions#tagbar#enabled = 1
  let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
  let g:airline#extensions#tabline#show_tabs     = 1
  let g:airline#extensions#tabline#tab_nr_type   = 2 " Show # of splits and tab #
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#show_tab_type = 1
  " Makes airline tabs rectangular
  let g:airline_left_sep = ' '
  let g:airline_right_sep = ' '
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'

  let g:airline#extensions#tabline#right_sep = ''
  let g:airline#extensions#tabline#right_alt_sep = '|'
  "This defines the separators for airline changes them from the default arrows
  let g:airline_left_alt_sep = ''
  let g:airline_right_alt_sep = ''

  " configure whether close button should be shown: >
  let g:airline#extensions#tabline#show_close_button = 1

  " determine whether inactive windows should have the left section collapsed to
  " only the filename of that buffer.  >
  let g:airline_inactive_collapse=1
  " * configure symbol used to represent close button >
  " let g:airline#extensions#tabline#close_symbol = 'X'
  " * configure pattern to be ignored on BufAdd autocommand >
  " fixes unnecessary redraw, when e.g. opening Gundo window
  let airline#extensions#tabline#ignore_bufadd_pat =
        \ '\c\vgundo|undotree|vimfiler|tagbar|nerd_tree'

  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <localleader>1 <Plug>AirlineSelectTab1
  nmap <localleader>2 <Plug>AirlineSelectTab2
  nmap <localleader>3 <Plug>AirlineSelectTab3
  nmap <localleader>4 <Plug>AirlineSelectTab4
  nmap <localleader>5 <Plug>AirlineSelectTab5
  nmap <localleader>6 <Plug>AirlineSelectTab6
  nmap <localleader>7 <Plug>AirlineSelectTab7
  nmap <localleader>8 <Plug>AirlineSelectTab8
  nmap <localleader>9 <Plug>AirlineSelectTab9
  nmap <localleader>- <Plug>AirlineSelectPrevTab
  nmap <localleader>+ <Plug>AirlineSelectNextTab

  "Remaps native insert mode paste binding to alt-p
  inoremap π <C-R>0
  inoremap … <C-R><C-P>0

  "}}}
  "-----------------------------------------------------------
  "Colorscheme
  "-----------------------------------------------------------
  let g:thematic#themes = {
        \ 'quantum' : { 'background': 'dark',
        \               'colorscheme':'quantum',
        \               'airline-theme': 'quantum',
        \                },
        \ 'onedark' : { 'colorscheme':'onedark',
        \               'airline-theme': 'onedark',
        \                 'background': 'dark',
        \                },
        \ 'solarized' :{ 'background': 'dark',
        \                'colorscheme': 'solarized8_dark_high',
        \                 'airline-theme': 'solarized',
        \                },
        \ 'sialoquent' :{'colorscheme': 'sialoquent',
        \                 'airline-theme': 'bubblegum',
        \                },
        \ 'oceanic-next' :{'colorscheme': 'OceanicNext',
        \                 'airline-theme': 'oceanicnext',
        \                },
        \ 'spring-night' :{'colorscheme': 'spring-night',
        \                 'airline-theme': 'spring_night',
        \                },
        \}


  let g:thematic#defaults = {
        \ 'laststatus': 2,
        \ }
  "Set color Scheme
  let g:thematic#theme_name = 'quantum'
  nnoremap <F10> :ThematicNext<CR>


  fun! Solarized8Contrast(delta)
    let l:schemes = map(["_low", "_flat", "", "_high"], '"solarized8_".(&background).v:val')
    exe "colors" l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
  endf
  let g:solarized_visibility="high"
  let g:solarized_statusline="normal"

  nnoremap <F8> :<c-u>call Solarized8Contrast(-v:count1)<cr>
  nnoremap <F7> :<c-u>call Solarized8Contrast(+v:count1)<cr>
  " endif

  let g:gitgutter_sign_modified = '•'
  let g:gitgutter_sign_added    = '❖'
  "highlight GitGutterAdd guifg = '#A3E28B'

  "Sets no highlighting for conceal
  hi Conceal ctermbg=none ctermfg=none guifg=NONE guibg=NONE


  " Spring Night ==============================================
  " This variable needs to be set, and set to nothing to maintain a light
  " contrast
  let g:spring_night_high_contrast=[]
  " The theme is set by thematic plugin but the above line is needed to ensure it
  " renders properly

  " remap arrow keys
  nnoremap <Leader><Leader> :bprev<CR>
  nnoremap <Leader>. :bnext<CR>

  " ----------------------------------------------------------------------------
  " Tabbing - overridden by editorconfig, after/ftplugin
  " ----------------------------------------------------------------------------{{{
  set expandtab                         " default to spaces instead of tabs
  set shiftwidth=2                      " softtabs are 2 spaces for expandtab

  " Alignment tabs are two spaces, and never tabs. Negative means use same as
  " shiftwidth (so the 2 actually doesn't matter).
  set softtabstop=-2

  " real tabs render width. Applicable to HTML, PHP, anything using real tabs.
  " I.e., not applicable to JS.
  set tabstop=8

  " use multiple of shiftwidth when shifting indent levels.
  " this is OFF so block comments don't get fudged when using \">>" and \"<<"
  set noshiftround

  " When on, a <Tab> in front of a line inserts blanks according to
  " 'shiftwidth'. 'tabstop' or 'softtabstop' is used in other places.
  set smarttab

  "Add vim sensible config options

  if !has('nvim')
    set complete-=i
    set autoindent
  endif

  " Use <C-I> to clear the highlighting of :set hlsearch.
  " if maparg('<C-I>', 'n') ==# ''
  "   nnoremap <silent> <C-I> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-I>
  " endif
  "
  set display+=lastline

  if &encoding ==# 'latin1' && has('gui_running')
    set encoding=utf-8
  endif
  scriptencoding utf-8

  " if &listchars ==# 'eol:$'
  "   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  " endif




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


  "Turn swap files off - FOR GOD's SAKE they are ruining my life
  set noswapfile
  "This saves all back up files in a vim backup directory
  set backupdir=~/.vim/.backup//
  " set directory=~/.vim/.swp//
  set undofile
  set undodir=~/.vim/.undo//

  if has("vms")
    set nobackup
  else
    set backup
  endif
  set history=50
  "}}}
  " ----------------------------------------------------------------------------
  " Match and search
  " ----------------------------------------------------------------------------
  " Sets a case insensitive search except when using Caps
  set ignorecase
  set smartcase
  set wrapscan " Searches wrap around the end of the file
  set nohlsearch " -functionality i.e. search highlighting done by easy motion
  " hi Search guibg=LightGreen  ctermbg=NONE
  " ---------------------------------------------------------------------
  " Cursor
  " ---------------------------------------------------------------------{{{

  " Set cursorline to the focused window only and change and previously color/styling of cursor line depending on mode
  augroup highlight_follows_focus
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
  augroup END

  augroup highlight_follows_vim
    autocmd!
    autocmd FocusGained * set hi cursorline
    autocmd FocusLost * set nocursorline
  augroup END
  " Show context around current cursor position
  "As this is set to a large number the cursor will remain in the middle of the
  "page on scroll (8 ) was the previous value
  set scrolloff=20
  set sidescrolloff=16

  " Stops some cursor movements from jumping to the start of a line
  set nostartofline
  "}}}

