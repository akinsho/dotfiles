"-----------------------------------------------------------
"PLUGINS
"-----------------------------------------------------------
"=====================
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

"================================
" CORE {{{1
"================================
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
      \ | Plug 'dsznajder/vscode-es7-javascript-react-snippets'
Plug 'itchyny/lightline.vim'
      \ | Plug 'mengelbrecht/lightline-bufferline'
Plug 'airblade/vim-rooter'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-icons'
Plug 'kristijanhusak/defx-git'
Plug 'mattn/emmet-vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'janko-m/vim-test', {
      \ 'on': ['TestNearest', 'TestVisit', 'TestSuite', 'TestLast', 'TestFile']}
Plug 'honza/vim-snippets'
"TMUX {{{1
"============================
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator', Cond(!has('gui_running'))
"Utilities {{{1
"============================
" Plug 'yardnsm/vim-import-cost', { 'do': 'yarn install' }
" Plug 'kamykn/spelunker.vim'
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger'
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'yuttie/comfortable-motion.vim'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'takac/vim-hardtime'
"TPOPE {{{1
"====================================
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
" ===========================
"Syntax {{{1
"============================
Plug 'Akin909/vim-dune', { 'for': ['dune']} " syntax highlighting for ocaml/reason dune files
Plug 'Yggdroot/indentLine', Cond(!exists('g:gui_oni'))
Plug 'fatih/vim-go', Cond(!exists('g:gui_oni'), {'do': ':GoUpdateBinaries', 'for': ['go'] })
Plug 'sheerun/vim-polyglot'
"Git {{{1
" ==============================
Plug 'lambdalisue/gina.vim'
Plug 'rhysd/conflict-marker.vim'
" Text Objects {{{1
" =====================
Plug 'AndrewRadev/tagalong.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'kana/vim-textobj-user'
      \ | Plug 'kana/vim-operator-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'inside/vim-textobj-jsxattr'
"Search Tools {{{1
"=======================
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'kshenoy/vim-signature'
Plug 'kassio/neoterm', { 'on': ['Ttoggle', 'Tnew', 'Tmap', 'T'] }
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':['vimwiki','markdown'] })
"Filetype Plugins {{{1
"======================
Plug 'iamcco/markdown-preview.nvim', {
      \ 'do': 'cd app & yarn install',
      \ 'for': 'markdown', 'on': 'MarkdownPreview'
      \ }
Plug 'heavenshell/vim-jsdoc', {
      \ 'for': ['javascript','javascript.jsx', 'typescript', 'typescript.tsx'],
      \ 'on': 'JSDoc'
      \ }
Plug 'chrisbra/csv.vim', Cond(!exists('g:gui_oni'), { 'for': 'csv' })
"Themes  {{{1
"===============================
Plug 'rakr/vim-one'
Plug 'haishanh/night-owl.vim'
Plug 'jacoborus/tender.vim'
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
endif

" Load immediately {{{1
call plug#load('vim-fat-finger')
""}}}
" vim:foldmethod=marker
