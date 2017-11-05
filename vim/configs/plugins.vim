"-----------------------------------------------------------
"PLUGINS
"-----------------------------------------------------------
" Plug Setup ===================== {{{
"This will autoinstall vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup VimPlug
    au!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

function! Cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.vim/plugged')
"}}}
" Deoplete  ============================={{{
" Code completion
Plug 'Shougo/deoplete.nvim',        { 'do': function('DoRemote') }
Plug 'Shougo/neco-vim',             { 'for': 'vim' },
Plug 'Shougo/echodoc.vim'
"NVIM ====================================
if !exists('g:gui_oni')
  Plug 'mhartington/nvim-typescript', Cond(has('nvim'),{'do': function('DoRemote')})
  Plug 'carlitux/deoplete-ternjs',
        \{'do': 'npm install -g tern' }
endif
Plug 'roxma/nvim-yarp',
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'zchee/deoplete-go',          { 'for' : 'go', 'do': 'make'}
Plug 'ujihisa/neco-look',          { 'for': 'markdown' }
Plug 'pbogut/deoplete-elm',        { 'for': 'elm' },
Plug 'Galooshi/vim-import-js',     { 'do': 'npm install -g import-js' }
Plug 'wokalski/autocomplete-flow', { 'for': ['javascript', 'javascript.jsx'] }
" Plug 'autozimu/LanguageClient-neovim',
"       \{ 'do': function('DoRemote') }
" 'for': ['javascript', 'typescript', 'rust'],
"}}}
" CORE ================================ {{{
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree'
      \ | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mattn/emmet-vim'
Plug 'cohama/lexima.vim'
Plug 'easymotion/vim-easymotion'
function! BuildTern(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install && npm install -g tern
  endif
endfunction
Plug 'ternjs/tern_for_vim', {'do':function('BuildTern')}
Plug 'mhinz/vim-startify'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        \ | Plug 'junegunn/fzf.vim'
"}}}
"TMUX ============================ {{{
Plug 'christoomey/vim-tmux-navigator' "Navigate panes in vim and tmux with the same bindings
"}}}
"Utilities ============================{{{
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger' "Autocorrects 4,000 common typos
if has('gui_running') || exists('g:gui_oni')
  Plug 'yuttie/comfortable-motion.vim'
endif
Plug 'junegunn/vim-easy-align', { 'on': [ '<Plug>(EasyAlign)' ] }
if !exists('g:gui_oni')
  Plug 'itchyny/lightline.vim'
endif
Plug 'ap/vim-buftabline'
Plug 'vimwiki/vimwiki'
Plug 'ludovicchabant/vim-gutentags'
"}}}
"TPOPE ===================================={{{
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
"}}}
"Syntax ============================{{{
Plug 'Quramy/vim-js-pretty-template'
Plug 'jparise/vim-graphql'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'ianks/vim-tsx'
Plug 'othree/javascript-libraries-syntax.vim',
      \ { 'for':[ 'javascript', 'typescript' ] }
Plug 'ap/vim-css-color'
Plug 'hail2u/vim-css-syntax'
Plug 'styled-components/vim-styled-components',
      \{ 'branch': 'rewrite', 'for': ['typescript.tsx', 'javascript.jsx'] }
"Git ==============================={{{
Plug 'shuber/vim-promiscuous', { 'on': ['Promiscuous'] }
Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'jreybert/vimagit', { 'on': ['Magit', 'MagitOnly'] }
"}}}
"Text Objects ====================={{{
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'chaoren/vim-wordmotion'
Plug 'terryma/vim-expand-region'
Plug 'kana/vim-textobj-user'
      \ | Plug 'whatyouhide/vim-textobj-xmlattr'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'kana/vim-textobj-function'
      \ | Plug 'thinca/vim-textobj-function-javascript'
Plug 'kana/vim-operator-user'
      \ | Plug 'haya14busa/vim-operator-flashy'
" "}}}
"Search Tools ======================={{{
Plug 'dyng/ctrlsf.vim'
Plug 'janko-m/vim-test'
Plug 'keith/investigate.vim'
Plug 'kshenoy/vim-signature'
Plug 'scrooloose/nerdcommenter'
Plug 'mhinz/vim-sayonara',    { 'on': 'Sayonara' }
Plug 'kassio/neoterm',        Cond(has('nvim'))
Plug 'junegunn/goyo.vim',     { 'for':'markdown' }
Plug 'KabbAmine/vCoolor.vim', { 'on': ['VCoolor', 'VCase'] }
Plug 'takac/vim-hardtime',    { 'on': ['HardTimeToggle', 'HardTimeOn'] }
"}}}
"Filetype Plugins ======================{{{
function! BuildComposer(info)
  if a:info.status !=# 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
Plug 'euclio/vim-markdown-composer',
      \ Cond(!has('gui_vimr'), { 'for': 'markdown', 'do': function('BuildComposer') })
Plug 'fatih/vim-go',           { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'chrisbra/csv.vim',       { 'for': 'csv' }
"}}}
"Themes =============================== {{{
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
Plug 'joshdick/onedark.vim'
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
else
  runtime! macros/matchit.vim
endif
"}}}

" Load immediately {{{
call plug#load('vim-fat-finger')
" }}}
