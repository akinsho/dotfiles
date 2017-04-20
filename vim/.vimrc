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
" Snippets are separated from the engine. Add this if you want them:
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
"Added color picker plugin
" Plug 'KabbAmine/vCoolor.vim'
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
Plug 'junegunn/vim-easy-align'
"Capslock without a capslock key in vim
Plug 'tpope/vim-capslock'
"Go for Vim
Plug 'fatih/vim-go',{ 'for': 'go', 'do': ':GoInstallBinaries' }
"css related
"Colors for hexcode in vim
Plug 'gorodinskiy/vim-coloresque', {'for': ['css', 'scss']}


"TMUX ============================
if executable("tmux")
"Vimux i.e send commands to a tmux split
Plug 'benmills/vimux'
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator'
endif

"Utilities============================
" Buffers in the tabline because ....why... tabs
Plug 'ap/vim-buftabline'
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

"TPOPE ====================================
"Added vim surround for enclosing with parens
Plug 'tpope/vim-surround'
" Add fugitive git status and command plugins
Plug 'tpope/vim-fugitive'
" Adds file manipulation functionality
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
"Tim pope's surround plugin allows . to repeat more actions
Plug 'tpope/vim-repeat'
"Very handy plugins and functionality by Tpope (ofc)
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
"Peace and Quiet thanks JGunn
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
" All encompasing v
Plug 'terryma/vim-expand-region'
"Moar textobjs
Plug 'wellle/targets.vim'


"Search Tools =======================
Plug 'inside/vim-search-pulse'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

"Coding tools =======================
"Add JSDocs plugin
Plug 'heavenshell/vim-jsdoc'
"Add Tagbar Plugin
Plug 'majutsushi/tagbar'
"Add Plugin to manage tag files
Plug 'ludovicchabant/vim-gutentags'
"Vim HARDMODE ----------------------
Plug 'wikitopian/hardmode'

"Filetype Plugins ======================
"Add better markdown previewer
Plug 'shime/vim-livedown'


"Themes ===============================
Plug 'rhysd/try-colorscheme.vim'
"Quantum theme
" Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'tyrannicaltoucan/vim-quantum'
" Plug 'KeitaNakamura/neodark.vim'

"Add file type icons to vim
Plug 'ryanoasis/vim-devicons' " This Plugin must load after the others


"Plugins I think I need yet never use ===============================
"Need this for styled components
" Plug 'fleischie/vim-styled-components' "in Alpha ergo Buggy AF ATM
" "Start up time monitor
" Plug 'tweekmonster/startuptime.vim'
"vim sialoquent theme
" Plug 'davidklsn/vim-sialoquent'
"Colorscheme - OneDark
" Plug 'joshdick/onedark.vim'
"Codi - A REPL in vim
" Plug 'metakirby5/codi.vim'


call plug#end()

filetype plugin indent on

"Added built in match it plugin to vim
packadd! matchit
" if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
"   runtime! macros/matchit.vim
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
"PLUGIN MAPPINGS {{{
"--------------------------------------------------------------------------------------------------
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



let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_added    = '❖'
let g:gitgutter_sign_column_always = 1
let g:gitgutter_eager              = 0
let g:gitgutter_grep_command = 'ag --nocolor'
"-----------------------------------------------------------
" Colorizer
"-----------------------------------------------------------



vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <C-F> :Neoformat<CR>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vnoremap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" nnoremap ¬ :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>
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


let g:NERDTreeHijackNetrw             = 1
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
map * <Plug>(incsearch-nohl-*)<Plug>Pulse
map # <Plug>(incsearch-nohl-#)<Plug>Pulse
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

" Jump to anwhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
" nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-overwin-f2)

map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)



"add Vcoolor color picker mapping
let g:vcoolor_map = '<F8>'
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
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript,javascript.jsx setlocal omnifunc=tern#Complete
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

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git.
set spellfile=$HOME/.vim-spell-en.utf-8.add
set fileformats=unix,dos,mac
" Autocomplete with dictionary words when spell check is on
set complete+=kspell
"Add spell checking local
" setlocal spell spelllang=en_us
"-----------------------------------------------------------------------------------
"MAPPINGS {{{
"-----------------------------------------------------------------------------------
" Emacs like keybindings for the command line (:) are better
" and you cannot use Vi style-binding here anyway, because ESC
" just closes the command line and using Home and End..
" remap arrow keys
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>


nnoremap <Leader><Leader> :update<CR>
nnoremap <Leader>h :bprev<CR>
nnoremap <Leader>l :bnext<CR>
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
" onoremap aa  a>
" xnoremap aa  a>
" onoremap ia  i>
" xnoremap ia  i>
"Change two vertically split windows to horizontal splits
nnoremap <LocalLeader>h <C-W>t <C-W>K
nnoremap <LocalLeader>v <C-W>t <C-W>H
"Change two horizontally split windows to vertical splits

"Select txt that has just been read or pasted in
nnoremap gV `[V`]

"Bubbling text a la vimcasts - http://vimcasts.org/episodes/bubbling-text/
" Better bubbling a la Tpope's unimpaired vim
nmap ë [e
nmap ê ]e
vmap ë [egv
vmap ê ]egv


" Line completion - native vim
inoremap ç <C-X><C-L>

"Replace current word with last deleted word
nnoremap S diw"0P

" make . work with visually selected lines
vnoremap . :norm.<CR>


" nnoremap ó :update<CR>
inoremap ó <C-O>:update<CR>

"This mapping alternates between variants of number and relative number
" nnoremap <F4> :exec &nu==&rnu? "se nu!" : "se rnu!"<CR>
"This mapping allows yanking all of a line without taking the new line
"character as well can be with our without spaces
vnoremap <silent> al :<c-u>norm!0v$h<cr>
vnoremap <silent> il :<c-u>norm!^vg_<cr>
onoremap <silent> al :norm val<cr>
onoremap <silent> il :norm vil<cr>

"ctrl-o in insert mode allows you to perform one normal mode command then
"returns to insert mode
" inoremap <C-j> <Down>
inoremap ê <Down>
inoremap è <left>
inoremap ë <up>
inoremap ì <right>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

nnoremap <F6> :! open %<CR>
"nnoremap <F3> :!open -a safari %<CR>

"automatically at present
set pastetoggle=<F2>
"time out on mapping after half a second, time out on key codes after a tenth
"of a second
set timeout timeoutlen=500 ttimeoutlen=100

" Remap jumping to the last spot you were editing previously to bk as this is
" easier form me to remember
nnoremap bk `.

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
nnoremap <leader>sw :b#<CR>
"--------------------------------------------
" FZF bindings
"--------------------------------------------
" Advanced customization using autoload functions
" inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
" Replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

" Mapping selecting mappings
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

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
" Push the repository of the currently opened file
" nnoremap <leader>gp :call VimuxRunCommandInDir("git push", 0)<CR>
"--------------------------------------------
"Remap back tick for jumping to marks more quickly
nnoremap ' `
nnoremap ` '

nnoremap rs ^d0
"Save all files
nnoremap qa :wqa<CR>
" clean up any trailing whitespace - neoformat does this
" nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
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
nnoremap <up> 15<c-w>+
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
"Indent a page 
nnoremap <C-G>f gg=G<CR>

"map window keys to leader - Interfere with tmux navigator
" noremap <C-h> <c-w>h
" noremap <C-j> <c-w>j
" noremap <C-k> <c-w>k
" noremap <C-l> <c-w>l


"Remap arrow keys to do nothing
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk


"Moves cursor back to the start of a line
inoremap <C-B> <C-O>I
"Remaps native ctrl h - emulates backspace to ctrl d
inoremap <C-D> <C-H>
"Remaps native ctrl k - deleting to the end of a line to control e
" inoremap <C-Q> <C-K>

" Map jk to esc key - using jk prevents jump that using ii causes
" inoremap jk <ESC>:w<CR>
inoremap jk <ESC>
inoremap ;; <End>;<Esc>:w<CR>

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

"Add neovim terminal escape with ESC mapping
if has("nvim")
:tnoremap <ESC> <C-\><C-n>
endif
"}}}

"===================================================================================
"Mouse {{{
"===================================================================================
set mousehide
set mouse=a "this is the command that works for mousepad
if !has('nvim')
  set ttymouse=xterm2
endif

set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
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
set fillchars=vert:│                  " Vertical sep between windows (unicode)- ⣿
" reveal already opened files from the quickfix window instead of opening new
" buffers
set switchbuf=useopen

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

set nrformats-=octal " never use octal when <C-x> or <C-a>"
"}}}
" ----------------------------------------------------------------------------
" Vim Path
" ----------------------------------------------------------------------------
"Vim searches recursively through all directories and subdirectories
set path+=**
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
" set wildignore+=*.*~,*~
set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

"}}}
" ----------------------------------------------------------------------------
" Display {{{
" --------------------------------------------------------------------------
set emoji

if has('linebreak') "Causes wrapped line to keep same indentation
  let &showbreak='↳ ' " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
  if exists('&breakindentopt')
    set breakindentopt=shift:2 
  endif
endif

" LIST =============================================================
" set list                              " show whitespace
" set listchars=nbsp:⦸                  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
" set listchars+=tab:▷┅                 " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
"                                       " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
" set listchars+=extends:»              " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
" set listchars+=precedes:«             " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
" set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
" =====================================================================

" =====================================================================
"Status Line - DIY STATUS (AND TABLINE no longer being used) stolen from https://gabri.me/blog/diy-vim-statusline
" =====================================================================
" if &statusline ==# ''
" set statusline=
" endif

let g:currentmode={
    \ 'n'  : 'Normal ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'Visual ',
    \ 'V'  : 'V·Line ',
    \ '' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'Insert ',
    \ 'R'  : 'Replace ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" Automatically change the statusline color depending on mode - requires gui colors as using termguicolors
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine guibg=#425762'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine guibg=#5f5fd7'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine guibg=#005f87'
  else
    exe 'hi! StatusLine ctermfg=006'
  endif
  return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
  endfunction

" Always display the status line even if only one window is displayed
set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=%8*\ [%n]                                " buffernr
set statusline+=%8*\ %{GitInfo()}                        " Git Branch name
set statusline+=%8*\ %<%.20F\ %{ReadOnly()}\ %m\ %w\        " File+path .20 prefix is for the degree of truncation
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%9*\ %=                                  " Space
set statusline+=%8*\ %y\                                 " FileType
" set statusline+=%7*\ %{(&fenc!=''?&fenc:&enc)}\ %{&ff}\ " Encoding & Fileformat, No current use for this info
set statusline+=%8*\ %-3(%{FileSize()}%)                 " File size
set statusline+=%0*\ %3p%%\ \ %l\ of\ %1L\      " The numbers after the % represent degrees of padding
set statusline+=%{ale#statusline#Status()}\ 

hi User1 ctermfg=007
hi User2 ctermfg=008
hi User3 ctermfg=008
hi User4 ctermfg=008
hi User5 ctermfg=008
hi User7 ctermfg=008
hi User8 ctermfg=008
hi User9 ctermfg=007
" =========================================================
" MyTabLine {{{
" =========================================================
" This is an attempt to emulate the default Vim-7 tabs as closely as possible but with numbered tabs.

set showtabline=2
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " set up some oft-used variables
      let tab = i + 1 " range() starts at 0
      let winnr = tabpagewinnr(tab) " gets current window of current tab
      let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
      let bufnr = buflist[winnr - 1] " current buffer number
      let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

      let s .= '%' . tab . 'T' " start a tab
      let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
      let s .= ' ' . tab " current tab number
      let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
      if n > 1
        let s .= ':' . n " if there's more than one, add a colon and display the count
      endif
      let bufmodified = getbufvar(bufnr, "&mod")
      if bufmodified
        let s .= ' +'
      endif
      if bufname != ''
        let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
      else
        let s .= ' [No Name] '
      endif
    endfor
    let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
    let s .= '%T' " resets tab page number?
    let s .= '%=' " seperate left-aligned from right-aligned
    let s .= '%#TabLine#' " set highlight for the 'X' below
    let s .= '%999XX' " places an 'X' at the far-right
    return s
  endfunction
  " set tabline=%!MyTabLine()
endif
"===============================================================================================}}}

set number                            " show line numbers in gutter
" This prevents a scratch buffer from being opened
set completeopt-=preview
set title                             " wintitle = filename - vim
" Match parentheses coloring
" highlight MatchParen  guibg=#658494 gui=bold

"lines shows absolute and all others are relative
set ttyfast " Improves smoothness of redrawing when there are multiple windows

"Add relative line numbers and relative = absolute line numbers i.e current
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

" Turns on lazyredraw which postpones redrawing for macros and command
" execution
set lazyredraw


if exists('&belloff')
  set belloff=all                     " never ring the bell for any reason
endif


if has('termguicolors')
  " Don't need this in xterm-256color, but do need it inside tmux.
  " (See `:h xterm-true-color`.)
  set termguicolors
  " set vim-specific sequences for rgb colors
  "super important for truecolor support in vim
"Setting the t_ variables is a further step to ensure 24bit colors
  if &term =~# 'tmux-256color'
    let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
  endif
endif
"}}}
" ----------------------------------------------------------------------------

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

let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh','javascript=js','sql=sql']
let g:vim_markdown_toml_frontmatter = 1

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

let delimitMate_expand_cr          = 1
let delimitMate_expand_space       = 1
let delimitMate_jump_expansion     = 1
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

"JS Docs plugin
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1
nmap <silent> co <Plug>(jsdoc)


let g:vimjs#smartcomplete = 1
" Disabled by default. Enabling this will let vim complete matches at any location
" e.g. typing 'document' will suggest 'document' if enabled.
let g:vimjs#chromeapis = 1
" Disabled by default. Toggling this will enable completion for a number of Chrome's JavaScript extension APIs


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
let g:startify_list_order = ['sessions', 'files', 'dir', 'bookmarks', 'commands']

let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
let g:buftabline_separators = 1


nmap <localleader>1 <Plug>BufTabLine.Go(1)
nmap <localleader>2 <Plug>BufTabLine.Go(2)
nmap <localleader>3 <Plug>BufTabLine.Go(3)
nmap <localleader>4 <Plug>BufTabLine.Go(4)
nmap <localleader>5 <Plug>BufTabLine.Go(5)
nmap <localleader>6 <Plug>BufTabLine.Go(6)
nmap <localleader>7 <Plug>BufTabLine.Go(7)
nmap <localleader>8 <Plug>BufTabLine.Go(8)
nmap <localleader>9 <Plug>BufTabLine.Go(9)
nmap <localleader>0 <Plug>BufTabLine.Go(10)


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


"   Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
"   saves on moving pane but only the currently opened buffer if changed
let g:tmux_navigator_save_on_switch = 2



"Remaps native insert mode paste binding to alt-p
inoremap ð <C-R>0
inoremap … <C-R><C-P>0

"}}}
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

" Add dictionary to vim's autocompletion
set complete+=k
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

" =======================================================
"  DICTIONARY
" =======================================================
set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words


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
  set backupdir=~/local/.vim/tmp/backup
  set backupdir+=~/.vim/tmp/backup    " keep backup files out of the way
  set backupdir+=.
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
set history=50
"}}}
" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------
" hi Search guibg=LightGreen  ctermbg=NONE
" Sets a case insensitive search except when using Caps
set ignorecase
set smartcase
set wrapscan " Searches wrap around the end of the file
set nohlsearch " -functionality i.e. search highlighting done by easy motion

" ----------------------------------------------------------------------------
" CURSOR  "{{{
" ----------------------------------------------------------------------------


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
" ----------------------------------------------------------------------------

