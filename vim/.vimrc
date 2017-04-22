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
"PLUGINS {{{
"-----------------------------------------------------------
"This will autoinstall vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"set the runtime path to include Vundle and initialise
call plug#begin('~/.vim/plugged')

if !has('nvim')
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer' }
else
  Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
endif
" Ale  Async Linting as you type
Plug 'w0rp/ale'
"Added vim snippets for code autofilling
Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'isRuslan/vim-es6'
  Plug 'epilande/vim-react-snippets'
"Added nerdtree filetree omnitool : )
Plug 'scrooloose/nerdtree'
"Added emmet vim plugin
Plug 'mattn/emmet-vim'
"Add delimitmate
Plug 'Raimondi/delimitMate'
"Added node.vim plugin
Plug 'moll/vim-node', { 'for':'javascript'}
"Added easy motions
Plug 'easymotion/vim-easymotion'
" "Add Tern for autocompletion
function! BuildTern(info)
if a:info.status == 'installed' || a:info.force
  !npm install
endif
endfunction
Plug 'ternjs/tern_for_vim',{'do':function('BuildTern')}
" A fun start up sceen for vim
Plug 'mhinz/vim-startify'
"FZF improved wrapper by June Gunn + the man who maintains syntastic
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" Autoformatter
Plug 'sbdchd/neoformat'
"Added June Gunn's alignment plugin
Plug 'junegunn/vim-easy-align', { 'on': [ '<Plug>(EasyAlign)' ] }
"Capslock without a capslock key in vim
Plug 'tpope/vim-capslock'
"Go for Vim
Plug 'fatih/vim-go',{ 'for': 'go', 'do': ':GoInstallBinaries' }
"css related

"TMUX ============================
if executable("tmux")
"Vimux i.e send commands to a tmux split
Plug 'benmills/vimux'
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator'
endif

"Utilities============================
"Adds cursor change and focus events to tmux vim
Plug 'sjl/vitality.vim'
"Add Gundo - undo plugin for vim
Plug 'sjl/gundo.vim',{'on':'GundoToggle'}
"Autocorrects 4,000 common typos
Plug 'chip/vim-fat-finger'
"Highlighting for substitution in Vim
Plug 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
"Underlines instances of word under the cursor
Plug 'itchyny/vim-cursorword'
"Peace and Quiet thanks JGunn
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }

"TPOPE ====================================
"Very handy plugins and functionality by Tpope (ofc)
Plug 'tpope/vim-surround'
" Add fugitive git status and command plugins
Plug 'tpope/vim-fugitive'
" Adds file manipulation functionality
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
"Tim pope's surround plugin allows . to repeat more actions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'


"Syntax ============================
"Added vim polyglot a collection of language packs for vim
Plug 'sheerun/vim-polyglot'
"Added javascript lib - syntax highlighting for popular libraries
Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript'}
"Added Editor Config plugin to maintain style choices
Plug 'editorconfig/editorconfig-vim'
"Add proper markdown syntax and indentation plugin
Plug 'plasticboy/vim-markdown', { 'for':'markdown'}

"Marks =============================
"Vim signature re-added because I need to see my bloody marks
Plug 'kshenoy/vim-signature'

"Git ===============================
"Git repo  manipulation plugin
Plug 'gregsexton/gitv',{'on':'Gitv'}
"Github dashboard for vim
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }
"Add a GitGutter to track new lines re git file
Plug 'airblade/vim-gitgutter'
"Plug to create diff window and Gstatus window on commit
Plug 'rhysd/committia.vim'

"Text Objects =====================
"Text object library plugin for defining your own text objects
Plug 'kana/vim-textobj-user'
"Text obj for comments
Plug 'glts/vim-textobj-comment'
"Conflict marker text objects
Plug 'rhysd/vim-textobj-conflict'
" Add text objects form camel cased strings (should be native imho)
Plug 'bkad/CamelCaseMotion' "uses a prefix of the leader key to implement text objects e.g. ci<leader>w will change all of one camelcased word
" Add text object for indented code = 'i' i.e dii delete inner indented block
Plug 'michaeljsmith/vim-indent-object'
" All encompasing v
Plug 'terryma/vim-expand-region'
"Moar textobjs
Plug 'wellle/targets.vim'


"Search Tools =======================
Plug 'inside/vim-search-pulse'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'wincent/ferret'

"Coding tools =======================
"Add JSDocs plugin
Plug 'heavenshell/vim-jsdoc'
"Vim HARDMODE ----------------------
Plug 'wikitopian/hardmode'
"Add Tagbar Plugin
Plug 'majutsushi/tagbar', { 'on': [ 'TagbarToggle' ] }
"Add Plugin to manage tag files
Plug 'ludovicchabant/vim-gutentags'

"Filetype Plugins ======================
"Add better markdown previewer
Plug 'shime/vim-livedown'


"Themes ===============================
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
"Quantum theme
" Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'tyrannicaltoucan/vim-quantum'

"Add file type icons to vim
Plug 'ryanoasis/vim-devicons' " This Plugin must load after the others


"Plugins I think I need yet never use ===============================
"Need this for styled components
" Plug 'fleischie/vim-styled-components' "in Alpha ergo Buggy AF ATM
" "Start up time monitor
" Plug 'tweekmonster/startuptime.vim'
"Codi - A REPL in vim
" Plug 'metakirby5/codi.vim'

call plug#end()

filetype plugin indent on

"Added built in match it plugin to vim the longer command a la tpope only loads
"this the user has not already installed a new version of matchit
" packadd! matchit
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

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
"PLUGIN MAPPINGS {{{
"--------------------------------------------------------------------------------------------------
"--------------------------------------------
" FZF bindings
"--------------------------------------------
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Use ripgrep instead of ag:
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
" Advanced customization using autoload functions
" Replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

nnoremap <silent> <localleader>o :Buffers<CR>

" Launch file search using FZF
nnoremap <C-P> :FZFR <CR>
nnoremap \ :Rg<CR>
nnoremap <space>\ :Find<space>

"This allows me to use control-f to jump out of a newly matched pair (courtesty
"of delimitmate)
imap <C-F> <C-g>g

nnoremap gm :LivedownToggle<CR>

nnoremap <F9> <Esc>:call ToggleHardMode()<CR>

let g:textobj_comment_no_default_key_mappings = 1
xmap ac <Plug>(textobj-comment-a)
omap ac <Plug>(textobj-comment-a)
xmap ic <Plug>(textobj-comment-i)
omap ic <Plug>(textobj-comment-i)
"--------------------------------------------
" Use formatprg when available
let g:neoformat_try_formatprg = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
"-----------------------------------------------------------
"     ALE
"-----------------------------------------------------------
let g:ale_echo_msg_format = '%linter%: %s [%severity%]'
let g:ale_sign_column_always = 1
let g:ale_sign_error         = '✖️'
let g:ale_sign_warning       = '⚠️'
let g:ale_linters            = {'jsx': ['stylelint', 'eslint']}
let g:ale_linter_aliases     = {'jsx': 'css'}
let g:ale_set_highlights = 0
nmap <silent> <C-/> <Plug>(ale_previous_wrap)
nmap <silent> <C-\> <Plug>(ale_next_wrap)

imap <C-L> <C-O><Plug>CapsLockToggle
"--------------------------------------------
"Fugitive bindings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gb :Gbrowse<CR> " Open current file on github.com
vnoremap <leader>gb :Gbrowse<CR> " Make it work in Visual mode to open with highlighted linenumbers
" Push the repository of the currently opened file
" nnoremap <leader>gp :call VimuxRunCommandInDir("git push", 0)<CR>
"--------------------------------------------
" JSX
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

let g:gitgutter_sign_modified = '•'
let g:gitgutter_eager = 0
let g:gitgutter_sign_added    = '❖'
let g:gitgutter_sign_column_always = 1
let g:gitgutter_eager              = 0
let g:gitgutter_grep_command = 'ag --nocolor'

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <C-F> :Neoformat<CR>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vnoremap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

set conceallevel=1
let g:javascript_conceal_arrow_function = "⇒"
let g:javascript_plugin_jsdoc           = 1

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
let VimuxUseNearest = 0
let VimuxResetSequence = ""

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
"NERDTree
" =============================================
" Ctrl+N to toggle Nerd Tree
nnoremap <C-N> :NERDTreeToggle<CR>
nnoremap <localleader>nf :NERDTreeFind<CR>

let g:NERDTreeHijackNetrw             = 0 "Off as it messes with startify's autoload session
let g:NERDTreeAutoDeleteBuffer        = 1
let g:NERDTreeDirArrowExpandable      = '├'
let g:NERDTreeDirArrowCollapsible     = '└'
let NERDTreeQuitOnOpen                = 1
let NERDTreeMinimalUI                 = 1
let NERDTreeDirArrows                 = 1
let NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeShowBookmarks           = 1
let NERDTreeAutoDeleteBuffer          = 1
let NERDTreeShowHidden                = 1 "Show hidden files by default

"===================================================
" Vim-Over - Highlight substitution parameters
"===================================================
nnoremap <localleader>/ <esc>:OverCommandLine<CR>:%s/
"===================================================
" Incsearch
"===================================================
let g:vim_search_pulse_mode = 'cursor_line'

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <leader>/ incsearch#go(<SID>config_easyfuzzymotion())

function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

" noremap <silent><expr> / incsearch#go(<SID>config_fuzzyall())
" noremap <silent><expr> ? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
" noremap <silent><expr> g? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" incsearch and vim search pulse
let g:vim_search_pulse_disable_auto_mappings = 1
let g:incsearch#auto_nohlsearch = 1

" Next or previous match is followed by a Pulse
map n <Plug>(incsearch-nohl-n)<Plug>Pulse
map N <Plug>(incsearch-nohl-N)<Plug>Pulse
map <leader>* <Plug>(incsearch-nohl-*)<Plug>Pulse
map <leader># <Plug>(incsearch-nohl-#)<Plug>Pulse
map g* <Plug>(incsearch-nohl-g*)<Plug>Pulse
map g# <Plug>(incsearch-nohl-g#)<Plug>Pulse

" Pulses the first match after hitting the enter keyan
augroup inc_search
  autocmd!
  autocmd! User IncSearchExecute
  autocmd User IncSearchExecute :call search_pulse#Pulse()
augroup END
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
" nmap s <Plug>(easymotion-s)
" Jump to anwhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"=======================================================================
"                    EMMET for Vim
"=======================================================================
"Emmet for vim leader keymap
let g:user_emmet_leader_key     = "<s-tab>"
let g:user_emmet_expandabbr_key = '<C-y>'

"Add mapping for Gundo vim
nnoremap <leader>u :GundoToggle<CR>

"Set up libraries to highlight with library syntax highlighter
let g:used_javascript_libs = 'underscore,jquery,angularjs,react,jasmine,chai,handlebars,requirejs'
"}}}
"====================================================================================
"AUTOCOMMANDS {{{
"===================================================================================
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

"this is is intended to stop insert mode bindings slowing down <bs> and <cr>
augroup Map_timings
  autocmd!
  autocmd InsertEnter * set timeoutlen=200
  autocmd InsertLeave * set timeoutlen=500
augroup END

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
  autocmd FileType go nmap <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
augroup END

augroup CheckOutsideTime - "excellent function but implemented by terminus
  autocmd!
  " automatically check for changed files outside vim
  autocmd WinEnter,BufRead,BufEnter,FocusGained * silent! checktime
  "Saves all files on switching tabs i.e losing focus, ignoring warnings about untitled buffers
  au FocusLost * silent! wa
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
augroup END

" automatically leave insert mode after 'updatetime' milliseconds of inaction
augroup updating_time
  autocmd!
  autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=10000
  autocmd InsertLeave * let &updatetime=updaterestore
augroup END

augroup VimResizing
  autocmd!
  "Command below makes the windows the same size on resizing !? Why?? because
  "its tidier
  autocmd VimResized * wincmd =
  autocmd FocusLost * :wa
  " autocmd VimResized * :redraw! | :echo 'Redrew'
augroup END

augroup filetype_completion
  autocmd!
  autocmd FileType css,scss,sass,stylus,less setl omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript,javascript.jsx,jsx setlocal omnifunc=tern#Complete
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup END

augroup filetype_javascript
  autocmd!
  "PRETTIER FOR VIM  ================
  autocmd FileType javascript.jsx,javascript setlocal formatprg=prettier\ --stdin\ --single-quote\ --trailing-comma\ es5
  autocmd BufWritePre *.js Neoformat
  "==================================
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
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
augroup END

augroup FileType_html
  autocmd!
  "for emmet
  autocmd FileType html imap <buffer><expr><tab> <sid>expand_html_tab()
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
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
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

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  " Set syntax highlighting for specific file types
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

if exists("*mkdir") "auto-create directories for new files
  augroup makedir
    autocmd!
    au BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
  augroup END
endif
augroup END

"Close vim if only window is a Nerd Tree
augroup NERDTree
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

augroup Toggle_number
  autocmd!
  " toggle relativenumber according to mode
  autocmd InsertEnter * set relativenumber!
  autocmd InsertLeave * set relativenumber
augroup END

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'
"}}}
"====================================================================================
"Spelling
"====================================================================================
" Someone elses color scheme, the default is really bad
highlight clear SpellBad
highlight SpellBad term=standout term=underline cterm=italic ctermfg=Red
highlight clear SpellCap
highlight SpellCap term=standout term=underline cterm=italic ctermfg=Blue
highlight clear SpellLocal
highlight SpellLocal term=standout term=underline cterm=italic ctermfg=Blue
highlight clear SpellRare
highlight SpellRare term=standout term=underline cterm=italic ctermfg=Blue
" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git.
set spellfile=$HOME/.vim-spell-en.utf-8.add
set fileformats=unix,dos,mac
" Autocomplete with dictionary words when spell check is on
set complete+=kspell
"Add spell checking local
" setlocal spell spelllang=en_us

"MAPPINGS =================================================
source ~/Dotfiles/vim/mappings.vim
"===================================================================================
"Mouse {{{
"===================================================================================
set mousehide
set mouse=a "this is the command that works for mousepad
if !has('nvim')
  set ttymouse=xterm2
endif

" Swap iTerm2 cursors in [n]vim insert mode when using tmux, more here https://gist.github.com/andyfowler/1195581
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


if !has('nvim')
function! ToggleMouse()
  " check if mouse is enabled
  if &mouse == 'a'
    " disable mouse
    set mouse=
  else
    " enable mouse everywhere
    set mouse=a
  endif
endfunc
"Try being more lenient
" noremap <ScrollWheelUp>      <nop>
" noremap <S-ScrollWheelUp>    <nop>
" noremap <C-ScrollWheelUp>    <nop>
" noremap <ScrollWheelDown>    <nop>
" noremap <S-ScrollWheelDown>  <nop>
" noremap <C-ScrollWheelDown>  <nop>
" noremap <ScrollWheelLeft>    <nop>
" noremap <S-ScrollWheelLeft>  <nop>
" noremap <C-ScrollWheelLeft>  <nop>
" noremap <ScrollWheelRight>   <nop>
" noremap <S-ScrollWheelRight> <nop>
" noremap <C-ScrollWheelRight> <nop>
nnoremap <F7> :call ToggleMouse()<CR>
endif
"}}}
"====================================================================================
"Buffer and Tab settings {{{
"====================================================================================
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set nohidden

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        exec t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>

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
set shortmess+=t                      " truncate file messages at start
set shortmess+=mnrxoOt
set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=O                      " file-read message overwrites previous
set shortmess+=T                      " truncate non-file messages in middle
set shortmess+=W                      " don't echo "[w]"/"[written]" when writing
" set shortmess+=a                      " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
" set shortmess+=I                      " no splash screen
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
if has('folding')
  if has('windows')
set fillchars=vert:│                  " Vertical sep between windows (unicode)- ⣿
set fillchars+=fold:-
  endif
  set foldmethod=indent
  set foldlevelstart=99
  set foldnestmax=3           " deepest fold is 3 levels
endif
" reveal already opened files from the quickfix window instead of opening new
" buffers
" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
catch
endtry

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
set path+=** "Vim searches recursively through all directories and subdirectories
" set autochdir

" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode {{{
" ----------------------------------------------------------------------------
" Use faster grep alternatives if possible
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
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
set wildignore+=*.*~,*~
set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

"}}}
" ----------------------------------------------------------------------------
" Display {{{
" --------------------------------------------------------------------------
set emoji
if has('linebreak') "Causes wrapped line to keep same indentation
" This should cause lines to wrap around words rather than random characters
set linebreak
  let &showbreak='↳ ' " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
  if exists('&breakindentopt')
    set breakindentopt=shift:2 
  endif
endif

" LIST =============================================================
set list                              " show whitespace
" set listchars=nbsp:⦸                  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
" set listchars+=tab:▷┅                 " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                      " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
set listchars+=tab:▹\ ,
set listchars+=extends:»              " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«             " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)
set listchars+=eol:\ 
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
" =====================================================================
" STATUS LINE --------------------
" see statuline.vim file
source ~/Dotfiles/vim/statusline.vim
"-----------------------------------
" highlight MatchParen  guibg=#658494 gui=bold "Match parentheses Coloring

set magic " For regular expressions turn magic on
set completeopt-=preview " This prevents a scratch buffer from being opened
set title                             " wintitle = filename - vim
set ttyfast " Improves smoothness of redrawing when there are multiple windows
if has('+relativenumber') "Add relative line numbers and relative = absolute line numbers i.e current
  set relativenumber
endif
set number
set linespace=4
set numberwidth=5
"Turns on smart indent which can help indent files like html natively
set smartindent
set wrap
set textwidth=79
"Use one space, not two, after punctuation
set nojoinspaces
set autowrite "Automatically :write before running commands
set backspace=2 "Back space deletes like most programs in insert mode
if has('vim')
  if has('+signcolumn')
    set signcolumn=yes "enables column that shows signs and error symbols
  endif
endif
set ruler
set incsearch
set lazyredraw " Turns on lazyredraw which postpones redrawing for macros and command execution
if exists('&belloff')
  set belloff=all                     " never ring the bell for any reason
endif
if has('termguicolors') " Don't need this in xterm-256color, but do need it inside tmux. (See `:h xterm-true-color`.)
  set termguicolors " set vim-specific sequences for rgb colors super important for truecolor support in vim
  if &term =~# 'tmux-256color' "Setting the t_ variables is a further step to ensure 24bit colors
    let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
  endif
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

"fugitive plugin
let g:EditorConfig_core_mode = 'external_command' " Speed up editorconfig plugin
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"-----------------------------------------------------------
"Plugin configurations "{{{
"-----------------------------------------------------------------
noremap <F4> :Gitv<CR>

let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:tern_show_argument_hints='on_hold'
let g:tern_map_keys                    = 1
let g:tern_show_signature_in_pum       = 1
" Stop folding markdown please
let g:vim_markdown_folding_disabled    = 1

let g:github_dashboard = {
    \'username': 'Akin909',
    \'password': $GITHUB_TOKEN
    \}
nnoremap <F1> :GHDashboard! Akin909<CR>

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
    Goyo 100
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

let g:vim_markdown_fenced_languages =['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=json', 'ruby', 'sass', 'scss=sass', 'xml', 'html', 'python', 'stylus=css', 'less=css', 'sql']
let g:vim_markdown_toml_frontmatter = 1

let g:UltiSnipsSnippetDirectories=["UltiSnips", "mySnippets"]
let g:UltiSnipsExpandTrigger="<C-J>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsListSnippets="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
let g:UltiSnipsEditSplit="vertical" "If you want :UltiSnipsEdit to split your window.

let g:livedown_autorun = 1 " should markdown preview get shown automatically upon opening markdown buffer
let g:livedown_open = 1 " should the browser window pop-up upon previewing
let g:livedown_port = 1337 " the port on which Livedown server will run

let delimitMate_expand_cr          = 1
let delimitMate_expand_space       = 1
let delimitMate_jump_expansion     = 1
let delimitMate_balance_matchpairs = 1


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

"JS Docs plugin
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1
nmap <silent> co <Plug>(jsdoc)

let g:vimjs#smartcomplete = 1 " Disabled by default. Enabling this will let vim complete matches at any location e.g. typing 'document' will suggest 'document' if enabled.
let g:vimjs#chromeapis = 1 " Disabled by default. Toggling this will enable completion for a number of Chrome's JavaScript extension APIs


if exists('NERDTree') " after a re-source, fix syntax matching issues (concealing brackets):
  if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
  endif
endif

let g:startify_session_dir = '~/.vim/session'
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_sort = 1
let g:startify_list_order = ['sessions', 'files', 'dir', 'bookmarks', 'commands']

" =========================================================================

"This sets default mapping for camel case text object
call camelcasemotion#CreateMotionMappings('<leader>')

"   Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
"   saves on moving pane but only the currently opened buffer if changed
let g:tmux_navigator_save_on_switch = 2

"Remaps native insert mode paste binding to alt-p
inoremap ð <C-R>0
inoremap … <C-R><C-P>0

"}}}
""""""""""""""""""""""""""""""""""""""""""""""""""
" => HELPER FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""
" for better tab response for emmet
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
    " expand anything emmet thinks is expandable.
    if emmet#isExpandable()
        return "\<C-y>,"
    endif
    " return a regular tab character
    return "\<tab>"
  endfunction

" Function to use f to search backwards and forwards courtesy of help docs
" [WIP] see section H getpwd()
" function FindChar()
"   let c = nr2char(getchar())
"   while col('.') < col('$') - 1
"     normal l
"     if getline('.')[col('.') - 1] ==? c
"       break
"     endif
"   endwhile
" endfunction

" function GetKey()
"   let c = getchar()
"   while c == "\<CursorHold>"
"     let c = getchar()
"   endwhile
"   return c
" endfunction

" nmap f :call GetKey()<CR>

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

"Currently stalls vim!!!
function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
"-----------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------
"Set color Scheme
" colorscheme deep-space
colorscheme quantum


" Comments in ITALICS YASSSSS!!!
highlight Comment cterm=italic

"Sets no highlighting for conceal
hi Conceal ctermbg=none ctermfg=none guifg=NONE guibg=NONE

"---------------------------------------------------------------------
" CORE FUNCTIONALITY
"---------------------------------------------------------------------
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
if !has('nvim')
  set complete-=i
  set autoindent
endif
" Use <C-I> to clear the highlighting of :set hlsearch.
" if maparg('<C-I>', 'n') ==# ''
"   nnoremap <silent> <C-I> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-I>
" endif
set display+=lastline
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif
scriptencoding utf-8

" =======================================================
"  DICTIONARY
" =======================================================
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set autoread " reload files if they were edited elsewhere

set history=1000
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

" set directory=~/.vim/.swp//
if has ('persistent_undo')
  if exists('$SUDO_USER')
    set noundofile "Dont add root owned files which I will need to sudo to remove
  else
    set undodir=~/.vim/.undo//
    set undodir+=~/local/.vim/tmp/undo
    set undodir+=.
    set undofile
  endif
endif

if has("vms")
  set nobackup
else
  set backup
endif
"}}}
" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------
" hi Search guibg=LightGreen  ctermbg=NONE
" Sets a case insensitive search except when using Caps
set ignorecase
set smartcase
set wrapscan " Searches wrap around the end of the file
set nohlsearch " -functionality i.e. search highlighting done by easy motion and incsearch

" ----------------------------------------------------------------------------
" CURSOR  "{{{
" ----------------------------------------------------------------------------
" Set cursorline to the focused window only and change and previously color/styling of cursor line depending on mode
augroup highlight_follows_focus
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
  autocmd FocusGained * set hi cursorline
  autocmd FocusLost * set nocursorline
augroup END

augroup highlight_follows_vim
  autocmd!
augroup END

set scrolloff=10 " Show context around current cursor position i.e. cursor lines remaining whilst moving up or down As this is set to a large number the cursor will remain in the middle of the page on scroll (8 ) was the previous value
set sidescrolloff=10
set nostartofline " Stops some cursor movements from jumping to the start of a line

"}}}
" ----------------------------------------------------------------------------

