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

function! BuildComposer(info)
  if a:info.status !=# 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

function! CocInstall(info)
  call coc#add_extension(
        \ 'coc-json',
        \ 'coc-tsserver',
        \ 'coc-rls',
        \ 'coc-snippets',
        \ 'coc-emmet',
        \ 'coc-highlight',
        \ 'coc-css',
        \ 'coc-eslint',
        \ 'coc-prettier'
        \ )
  call coc#util#install()
endfunction
"================================
" CORE {{{1
"================================
  if !exists('g:gui_oni')
    Plug 'Shougo/neco-vim', { 'for': 'vim' },
    Plug 'neoclide/coc-neco', { 'for': 'vim' },
    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': function('CocInstall')}
    Plug 'itchyny/lightline.vim'
      \ | Plug 'maximbaz/lightline-ale'
      \ | Plug 'mengelbrecht/lightline-bufferline'
    Plug 'airblade/vim-rooter'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'scrooloose/nerdtree'
    Plug 'ludovicchabant/vim-gutentags'
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
Plug 'vimwiki/vimwiki', { 'on': ['VimwikiIndex', 'VimwikiDiaryIndex', 'VimwikiIndexMakeDiaryNote']}
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
Plug 'yuttie/comfortable-motion.vim'
"TPOPE {{{1
"====================================
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-scriptease'
" ===========================
"Syntax {{{1
"============================
Plug 'ianks/vim-tsx', { 'for': ['typescript', 'typescript.tsx'] } 
Plug 'Yggdroot/indentLine', Cond(!exists('g:gui_oni'))
Plug 'fatih/vim-go', Cond(!exists('g:gui_oni'), {'do': ':GoUpdateBinaries', 'for': ['go'] })
Plug 'sheerun/vim-polyglot'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'styled-components/vim-styled-components', { 'branch': 'develop',
      \ 'for': ['javascript.jsx', 'typescript.tsx', 'typescript', 'javascript']}
"Git {{{1
" ==============================
Plug 'christoomey/vim-conflicted'
Plug 'rhysd/conflict-marker.vim'
Plug 'lambdalisue/gina.vim'
Plug 'airblade/vim-gitgutter'
" Text Objects {{{1
" =====================
Plug 'chaoren/vim-wordmotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
Plug 'haya14busa/vim-operator-flashy'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'kana/vim-textobj-user'
      \ | Plug 'kana/vim-operator-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'kana/vim-textobj-function'
      \ | Plug 'whatyouhide/vim-textobj-xmlattr'
      \ | Plug 'thinca/vim-textobj-function-javascript'
"Search Tools {{{1
"=======================
Plug 'RRethy/vim-illuminate'
Plug 'kshenoy/vim-signature'
Plug 'kassio/neoterm', { 'on': ['Ttoggle', 'Tnew', 'Tmap', 'T'] }
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':'markdown' })
Plug 'mhinz/vim-sayonara',    { 'on': 'Sayonara' }
Plug 'takac/vim-hardtime'
"======================
" Docs - Platform specific docs apps
"======================
if has('mac')
  Plug 'rizzatti/dash.vim',     { 'on': 'Dash' }
elseif g:os ==? 'linux'
  Plug 'KabbAmine/zeavim.vim',  { 'on': 'Zeavim' }
endif
"Filetype Plugins {{{1
"======================
Plug 'euclio/vim-markdown-composer',
      \ Cond(!exists('g:gui_oni'), { 'for': 'markdown', 'do': function('BuildComposer') })
Plug 'heavenshell/vim-jsdoc', {
      \ 'for': ['javascript','javascript.jsx', 'typescript', 'typescript.tsx'],
      \ 'on': 'JSDoc'
      \ }
Plug 'chrisbra/csv.vim',       Cond(!exists('g:gui_oni'), { 'for': 'csv' })
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
endif

" Load immediately {{{1
call plug#load('vim-fat-finger')
"}}}
" vim:foldmethod=marker
