"-----------------------------------------------------------
"PLUGINS {{{
"-----------------------------------------------------------
"This will autoinstall vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

"set the runtime path to include Vundle and initialise
call plug#begin('~/.vim/plugged')

if !has('nvim')
  if has('unix')
    if empty($SSH_CONNECTION)
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer' }
    endif
  endif
endif
"NVIM ====================================
" Deoplete
" ----------------------------------------
Plug 'Shougo/deoplete.nvim', Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })
Plug 'carlitux/deoplete-ternjs', Cond(has('nvim'), { 'do': 'npm install -g tern' })
Plug 'mhartington/nvim-typescript', Cond(has('nvim'))
Plug 'ujihisa/neco-look' "English completion
Plug 'ervandew/supertab', Cond(has('nvim'))
"================================
Plug 'w0rp/ale' " Ale  Async Linting as you type
Plug 'SirVer/ultisnips' 
Plug 'Shougo/echodoc.vim'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim' "Added emmet vim plugin
Plug 'Raimondi/delimitMate' "Add delimitmate
Plug 'easymotion/vim-easymotion' "Added easy motions
function! BuildTern(info)
  if a:info.status == 'installed' || a:info.force
    !npm install
  endif
endfunction
Plug 'ternjs/tern_for_vim',{'do':function('BuildTern')}
Plug 'mhinz/vim-startify'
if !has('gui_running')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  | Plug 'junegunn/fzf.vim'
endif
Plug 'ctrlpvim/ctrlp.vim', Cond(has('gui_running'))
Plug 'tpope/vim-capslock'
Plug 'junegunn/vim-easy-align', { 'on': [ '<Plug>(EasyAlign)' ] }

"TMUX ============================
if executable("tmux")
  Plug 'christoomey/vim-tmux-navigator' "Navigate panes in vim and tmux with the same bindings
endif

"Utilities ============================
Plug 'sjl/gundo.vim',{'on':'GundoToggle'} "Add Gundo - undo plugin for vim
Plug 'chip/vim-fat-finger', { 'on':[] } "Autocorrects 4,000 common typos
augroup load_fat_finger
  autocmd!
  autocmd InsertEnter * call plug#load('vim-fat-finger')
        \| autocmd! load_fat_finger
augroup END
" Plug 'itchyny/vim-cursorword'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"TPOPE ====================================
"Very handy plugins and functionality by Tpope (ofc)
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Add fugitive git status and command plugins
Plug 'tpope/vim-eunuch' " Adds file manipulation functionality
Plug 'tpope/vim-repeat' " . to repeat more actions
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"Syntax ============================
" Plug 'HerringtonDarkholme/yats.vim', { 'for':'typescript' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript'  }
Plug 'sheerun/vim-polyglot'
Plug 'othree/javascript-libraries-syntax.vim', { 'for':['javascript', 'typescript'] }
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/dbext.vim'
Plug 'lilydjwg/colorizer', { 'on': 'Colorize' }
" Plug 'fleischie/vim-styled-components'
"Git ===============================
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/committia.vim'
"Text Objects =====================
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'bkad/CamelCaseMotion'
Plug 'michaeljsmith/vim-indent-object'
Plug 'terryma/vim-expand-region'
Plug 'wellle/targets.vim'
"Search Tools =======================
Plug 'dyng/ctrlsf.vim', { 'on': ['CtrlSF', 'CtrlSFPrompt', 'CtrlSFToggle'] }
"Coding tools =======================
Plug 'janko-m/vim-test'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'scrooloose/nerdcommenter'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
" Color picker
Plug 'KabbAmine/vCoolor.vim', { 'on': ['VCoolor', 'VCase'] }
"Git -------------------------------
Plug 'christoomey/vim-conflicted'
Plug 'lambdalisue/gina.vim'
Plug 'jreybert/vimagit'

if !has('gui_running')
  Plug 'othree/jspc.vim', {'for': ['javascript', 'typescript']}
endif
"Filetype Plugins ======================
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' } "Go for Vim

"Themes ===============================
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'trevordmiller/nova-vim'
Plug 'ryanoasis/vim-devicons' " This Plugin must load after the others - Add file type icons to vim
call plug#end()

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

