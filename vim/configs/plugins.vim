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
  if !exists('g:gui_oni')
    Plug 'Shougo/neco-vim', { 'for': 'vim' },
    Plug 'neoclide/coc-neco', { 'for': 'vim' },
    Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
    Plug 'itchyny/lightline.vim'
      \ | Plug 'maximbaz/lightline-ale'
      \ | Plug 'mengelbrecht/lightline-bufferline'
    Plug 'airblade/vim-rooter'
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
    " NOTE: these are slow in large repositories
    Plug 'kristijanhusak/defx-icons'
    Plug 'kristijanhusak/defx-git'
    Plug 'kristijanhusak/vim-js-file-import', {'for':['javascript.jsx','javascript']}
endif
Plug 'w0rp/ale', Cond(!exists('g:gui_oni'))
Plug 'SirVer/ultisnips'
Plug 'mattn/emmet-vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'cohama/lexima.vim'
Plug 'janko-m/vim-test', { 'on': ['TestNearest', 'TestVisit', 'TestSuite', 'TestLast', 'TestFile']}
"TMUX {{{1
"============================
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator', Cond(!has('gui_running'))
"Utilities {{{1
"============================
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger'
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'yuttie/comfortable-motion.vim'
Plug 'mhinz/vim-sayonara',    { 'on': 'Sayonara' }
Plug 'takac/vim-hardtime'
Plug 'Shougo/echodoc.vim'
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
Plug 'Akin909/vim-dune' " syntax highlighting for ocaml/reason dune files
Plug 'Yggdroot/indentLine', Cond(!exists('g:gui_oni'))
Plug 'fatih/vim-go', Cond(!exists('g:gui_oni'), {'do': ':GoUpdateBinaries', 'for': ['go'] })
Plug 'jparise/vim-graphql'
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main',
      \ 'for': ['javascript.jsx', 'typescript.tsx', 'typescript', 'javascript']}
"Git {{{1
" ==============================
Plug 'whiteinge/diffconflicts'
Plug 'lambdalisue/gina.vim'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'
Plug 'rhysd/git-messenger.vim', Cond(has('nvim-0.4.0'))
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
      \ | Plug 'kana/vim-textobj-function', { 'for': ['vim', 'c', 'java'] }
      \ | Plug 'whatyouhide/vim-textobj-xmlattr'
      \ | Plug 'coderifous/textobj-word-column.vim'
      \ | Plug 'machakann/vim-textobj-functioncall'
"Search Tools {{{1
"=======================
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'RRethy/vim-illuminate'
Plug 'kshenoy/vim-signature'
Plug 'kassio/neoterm', { 'on': ['Ttoggle', 'Tnew', 'Tmap', 'T'] }
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':['vimwiki','markdown'] })
"Filetype Plugins {{{1
"======================
Plug 'lambdalisue/vim-backslash' 
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'heavenshell/vim-jsdoc', {
      \ 'for': ['javascript','javascript.jsx', 'typescript', 'typescript.tsx'],
      \ 'on': 'JSDoc'
      \ }
Plug 'chrisbra/csv.vim', Cond(!exists('g:gui_oni'), { 'for': 'csv' })
"Themes  {{{1
"===============================
if !exists('g:gui_oni')
  Plug 'joshdick/onedark.vim'
  " Plug 'haishanh/night-owl.vim'
  " Plug 'kaicataldo/material.vim'
endif
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
endif

" Load immediately {{{1
call plug#load('vim-fat-finger')
"}}}
" vim:foldmethod=marker
