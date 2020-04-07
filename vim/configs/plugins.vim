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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
      \ | Plug 'mengelbrecht/lightline-bufferline'
Plug 'airblade/vim-rooter'
Plug 'mattn/emmet-vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
"TMUX {{{1
"============================
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator', Cond(!has('gui_running'))
"Utilities {{{1
"============================
Plug 'liuchengxu/vista.vim'
Plug 'vimwiki/vimwiki'
Plug 'cohama/lexima.vim'
Plug 'mbbill/undotree', {'on': ['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger', {'on': [], 'for': []}
" We lazy load vim fat finger because it otherwise takes 80ms ie. the slowest
" thing to load blocking vim startup time
augroup Lazy_load_fat_fingers
    autocmd!
    autocmd CursorHold,CursorHoldI * call plug#load('vim-fat-finger')
          \ | autocmd! Lazy_load_fat_fingers
augroup end
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'psliwka/vim-smoothie'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
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
"sets searchable path for filetypes like go so 'gf' works
Plug 'tpope/vim-apathy'
" ===========================
"Syntax {{{1
"============================
Plug 'Akin909/vim-dune', { 'for': ['dune']} " syntax highlighting for ocaml/reason dune files
Plug 'Yggdroot/indentLine'
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': ['go'] }
Plug 'sheerun/vim-polyglot'
"Git {{{1
" ==============================
Plug 'rhysd/conflict-marker.vim'
Plug 'lambdalisue/gina.vim'
" Text Objects {{{1
" =====================
Plug 'AndrewRadev/tagalong.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
Plug 'kana/vim-textobj-user'
      \ | Plug 'kana/vim-operator-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'inside/vim-textobj-jsxattr'
"Search Tools {{{1
"=======================
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':['vimwiki','markdown'] })
"Filetype Plugins {{{1
"======================
Plug 'kkoomen/vim-doge'
Plug 'chrisbra/csv.vim', Cond(!exists('g:gui_oni'), { 'for': 'csv' })
"Themes  {{{1
"===============================
Plug 'rakr/vim-one'
Plug 'haishanh/night-owl.vim'
Plug 'jacoborus/tender.vim'
Plug 'patstockwell/vim-monokai-tasty'
" Colorscheme Ideas
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
endif
" vim:foldmethod=marker
