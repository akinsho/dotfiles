"-----------------------------------------------------------
"PLUGINS
"-----------------------------------------------------------
" Plug Setup {{{1
"=====================

" auto-install vim-plug
if has("nvim")
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup VimPlug
      au!
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  endif
  call plug#begin('~/.config/nvim/plugged')
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup VimPlug
      au!
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  endif
  call plug#begin('~/.vim/plugged')
endif


function! Cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

" function! BuildTern(info)
"   if a:info.status ==# 'installed' || a:info.force
"     !npm install && npm install -g tern
"   endif
" endfunction
" Plug 'ternjs/tern_for_vim', {'do':function('BuildTern')}
" Plug 'carlitux/deoplete-ternjs',
"   \{'do': 'npm install -g tern' }
" Code completion

" Deoplete  {{{1
"NVIM ====================================
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
  if !exists('g:gui_oni')
    Plug 'itchyny/lightline.vim'
      \ | Plug 'mengelbrecht/lightline-bufferline'
      \ | Plug 'maximbaz/lightline-ale'
    Plug 'airblade/vim-rooter'
    Plug 'Shougo/echodoc.vim'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'copy/deoplete-ocaml', { 'for': ['ocaml', 'reason'] }
    Plug 'wokalski/autocomplete-flow', {
          \ 'for': ['javascript', 'javascript.jsx'] }
    Plug 'Shougo/neco-vim', { 'for': 'vim' },
    Plug 'roxma/nvim-yarp', Cond(!has('nvim'))
    Plug 'roxma/vim-hug-neovim-rpc', Cond(!has('nvim'))
    Plug 'zchee/deoplete-go', { 'for' : 'go', 'do': 'make'}
    Plug 'ujihisa/neco-look', { 'for': ['markdown', 'gitcommit'] }
    Plug 'zchee/deoplete-zsh'
    Plug 'scrooloose/nerdtree'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'kristijanhusak/vim-js-file-import', { 'for':['javascript.jsx','javascript'] }
    Plug 'autozimu/LanguageClient-neovim', {
          \ 'branch': 'next',
          \ 'do': 'bash install.sh',
          \ }
  let g:modified_symbol = '✎ ' "Local version of the plugin
endif
" CORE {{{1
"================================
Plug 'mhartington/nvim-typescript', Cond(!exists('g:gui_oni'),  {
      \ 'for': ['typescript'], 'do': './install.sh'
      \ })
Plug 'w0rp/ale', Cond(!exists('g:gui_oni'))
Plug 'SirVer/ultisnips'
Plug 'mattn/emmet-vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'cohama/lexima.vim' 
Plug 'kennykaye/vim-relativity'
"TMUX {{{1
"============================
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator', Cond(!has('gui_running'))
"Utilities {{{1
"============================
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger'
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/deleft.vim'
Plug 'AndrewRadev/splitjoin.vim'
"TPOPE {{{1
"====================================
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
" ===========================
"Syntax {{{1
"============================
Plug 'ianks/vim-tsx' 
Plug 'Yggdroot/indentLine', Cond(!exists('g:gui_oni'))
Plug 'fatih/vim-go', Cond(!exists('g:gui_oni'), {
      \ 'do': ':GoUpdateBinaries', 'for': ['go']
      \ })
Plug 'sheerun/vim-polyglot'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'othree/javascript-libraries-syntax.vim',
       \ { 'for':[ 'javascript', 'typescript' ] }
Plug 'styled-components/vim-styled-components', {
      \ 'branch': 'main',
      \ 'for': [
      \ 'javascript.jsx',
      \ 'typescript.tsx',
      \ 'typescript',
      \ 'javascript'
      \ ] }
"Git {{{1
" ==============================
Plug 'lambdalisue/gina.vim'
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit', { 'on': ['Magit', 'MagitOnly'] }
" Text Objects {{{1
" =====================
Plug 'chaoren/vim-wordmotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
Plug 'haya14busa/vim-operator-flashy'
Plug 'kana/vim-textobj-user'
      \ | Plug 'rhysd/vim-textobj-conflict'
      \ | Plug 'kana/vim-operator-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'kana/vim-textobj-function'
      \ | Plug 'whatyouhide/vim-textobj-xmlattr'
      \ | Plug 'thinca/vim-textobj-function-javascript'
      " \  | Plug 'vimtaku/vim-textobj-keyvalue'
"Search Tools {{{1
"=======================
Plug 'RRethy/vim-illuminate'
Plug 'kshenoy/vim-signature'
Plug 'tomtom/tcomment_vim'
Plug 'kassio/neoterm'
Plug 'dyng/ctrlsf.vim', { 'on': ['CtrlSF'] }
Plug 'mhinz/vim-sayonara',    { 'on': 'Sayonara' }
Plug 'rizzatti/dash.vim',     Cond(has('mac'), { 'on': 'Dash' })
Plug 'takac/vim-hardtime',    Cond(!exists('g:gui_oni'), { 'on': ['HardTimeToggle', 'HardTimeOn'] })
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':'markdown' })

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
Plug 'chrisbra/csv.vim',       Cond(!exists('g:gui_oni'), { 'for': 'csv' })
Plug 'jxnblk/vim-mdx-js', { 'for': 'mdx'}
Plug 'heavenshell/vim-jsdoc', { 'on': 'JSDoc' }

"Themes  {{{1
"===============================
if !exists('g:gui_oni')
  Plug 'joshdick/onedark.vim'
  Plug 'haishanh/night-owl.vim'
endif
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
else
  runtime! macros/matchit.vim
endif

" Load immediately {{{1
call plug#load('vim-fat-finger')
"}}}
