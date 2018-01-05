"-----------------------------------------------------------
"PLUGINS
"-----------------------------------------------------------
" Plug Setup {{{1
"=====================
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

" Deoplete  {{{1
"=============================
" Code completion
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'Shougo/neco-vim',      { 'for': 'vim' },
Plug 'Shougo/echodoc.vim',   Cond(!exists('g:gui_oni'))
"NVIM ====================================
Plug 'mhartington/nvim-typescript', Cond(!exists('g:gui_oni'),{'do': function('DoRemote')})
Plug 'carlitux/deoplete-ternjs',
      \{'do': 'npm install -g tern' }
  Plug 'wokalski/autocomplete-flow', { 'for': ['javascript', 'javascript.jsx'] }
  if !exists('g:gui_oni')
  Plug 'itchyny/lightline.vim'
  Plug 'ap/vim-buftabline'
  let g:buftabline_modified_symbol = '✎ ' "Local version of the plugin
endif
Plug 'roxma/nvim-yarp', Cond(!has('nvim'))
Plug 'roxma/vim-hug-neovim-rpc', Cond(!has('nvim'))
Plug 'zchee/deoplete-go',          { 'for' : 'go', 'do': 'make'}
Plug 'ujihisa/neco-look',          { 'for': 'markdown' }
Plug 'pbogut/deoplete-elm',        { 'for': 'elm' },
Plug 'Galooshi/vim-import-js',     { 'do': 'npm install -g import-js' }
Plug 'autozimu/LanguageClient-neovim', Cond(!exists('g:gui_oni'), { 'do': function('DoRemote')})
" CORE {{{1
"================================
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree'
      \ | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mattn/emmet-vim'
Plug 'cohama/lexima.vim' ", Cond(!exists('g:gui_oni'))
Plug 'easymotion/vim-easymotion'
function! BuildTern(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install && npm install -g tern
  endif
endfunction
Plug 'ternjs/tern_for_vim', {'do':function('BuildTern')}
Plug 'mhinz/vim-startify' ", Cond(!exists('g:gui_oni'))
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      \ | Plug 'junegunn/fzf.vim'

"TMUX {{{1
"============================
Plug 'christoomey/vim-tmux-navigator' "Navigate panes in vim and tmux with the same bindings
"Utilities {{{1
"============================
Plug 'embear/vim-localvimrc'
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger' "Autocorrects 4,000 common typos
if has('gui_running') || exists('g:gui_oni')
  Plug 'yuttie/comfortable-motion.vim'
endif
Plug 'junegunn/vim-easy-align',
      \{ 'on': [ '<Plug>(EasyAlign)' ] }
Plug 'vimwiki/vimwiki', { 'on': [
      \'<Plug>(VimwikiTab)',
      \'<Plug>(VimwikiIndex)'
      \] }
Plug 'ludovicchabant/vim-gutentags'
"TPOPE {{{1
"====================================
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'

"Syntax {{{1
"============================
Plug 'ianks/vim-tsx'
Plug 'jparise/vim-graphql'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'othree/javascript-libraries-syntax.vim',
      \ { 'for':[ 'javascript', 'typescript' ] }
Plug 'ap/vim-css-color', Cond(!exists('g:gui_oni'))
Plug 'hail2u/vim-css-syntax'
Plug 'c0r73x/neotags.nvim', {'do': function('DoRemote')}
" Plug 'styled-components/vim-styled-components',
"       \{ 'branch': 'rewrite', 'for': ['typescript.tsx'] }
"Git {{{1
"===============================
Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'jreybert/vimagit', { 'on': ['Magit', 'MagitOnly'] }
"Text Objects {{{1
"=====================
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'chaoren/vim-wordmotion'
Plug 'terryma/vim-expand-region'
Plug 'kana/vim-textobj-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'kana/vim-textobj-function'
      \ | Plug 'thinca/vim-textobj-function-javascript'
      \ | Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'kana/vim-operator-user'
      \ | Plug 'haya14busa/vim-operator-flashy'
"
"Search Tools {{{1
"=======================
Plug 'dyng/ctrlsf.vim'
Plug 'keith/investigate.vim'
Plug 'kshenoy/vim-signature'
Plug 'scrooloose/nerdcommenter'
Plug 'kassio/neoterm',        Cond(has('nvim'))
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':'markdown' })
Plug 'mhinz/vim-sayonara',    { 'on': 'Sayonara' }
Plug 'takac/vim-hardtime',    { 'on': ['HardTimeToggle', 'HardTimeOn'] }
" Plug 'janko-m/vim-test', { 'on':[ 'TestNearest', 'TestSuite' ] }

"Filetype Plugins {{{1
"======================
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
      \ Cond(!exists('g:gui_oni'), { 'for': 'markdown', 'do': function('BuildComposer') })
Plug 'fatih/vim-go',           { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'chrisbra/csv.vim',       { 'for': 'csv' }

"Themes  {{{1
"===============================
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
else
  runtime! macros/matchit.vim
endif
" Load immediately {{{1
call plug#load('vim-fat-finger')
"}}}

