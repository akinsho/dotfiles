"-----------------------------------------------------------
"PLUGINS {{{
"-----------------------------------------------------------
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

call plug#begin('~/.vim/plugged')
"NVIM ====================================
" Deoplete
" ----------------------------------------
Plug 'Shougo/deoplete.nvim',        Cond(has('nvim'), { 'do': ':UpdateRemotePlugins' })
Plug 'carlitux/deoplete-ternjs',    Cond(has('nvim'), { 'do': 'npm install -g tern' })
Plug 'mhartington/nvim-typescript', Cond(has('nvim'))
Plug 'ujihisa/neco-look',           Cond(has('nvim'), { 'for': 'markdown' }) "English completion
Plug 'Shougo/neco-vim',             Cond(has('nvim'))
Plug 'zchee/deoplete-go',           Cond(has('nvim'), { 'do': 'make'})
Plug 'pbogut/deoplete-elm',         Cond(has('nvim'))
Plug 'wellle/tmux-complete.vim'
Plug 'ervandew/supertab'
"================================{{{
Plug 'maralla/completor.vim', Cond(!has('nvim'))
Plug 'Quramy/tsuquyomi',      Cond(!has('nvim'))
Plug 'w0rp/ale' " Ale  Async Linting as you type
Plug 'SirVer/ultisnips'
Plug 'Shougo/echodoc.vim'
Plug 'scrooloose/nerdtree', {'on':['NERDTreeFind', 'NERDTreeToggle']}
Plug 'mattn/emmet-vim'
Plug 'cohama/lexima.vim'
Plug 'easymotion/vim-easymotion'
function! BuildTern(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install
  endif
endfunction
Plug 'ternjs/tern_for_vim', {'do':function('BuildTern')}
Plug 'mhinz/vim-startify'
if !has('gui_running')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  | Plug 'junegunn/fzf.vim'
endif
Plug 'junegunn/vim-easy-align', { 'on': [ '<Plug>(EasyAlign)' ] }
"}}}
"TMUX ============================
Plug 'christoomey/vim-tmux-navigator' "Navigate panes in vim and tmux with the same bindings
"Utilities ============================{{{
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} "Add Gundo - undo plugin for vim
Plug 'chip/vim-fat-finger', { 'on':[] } "Autocorrects 4,000 common typos
augroup load_fat_finger
  autocmd!
  autocmd InsertEnter * call plug#load('vim-fat-finger')
        \| autocmd! load_fat_finger
augroup END
Plug 'junegunn/vim-peekaboo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"}}}
"TPOPE ===================================={{{
"Very handy plugins and functionality by Tpope (ofc)
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive' " Add fugitive git status and command plugins
Plug 'tpope/vim-eunuch' " Adds file manipulation functionality
Plug 'tpope/vim-repeat' " . to repeat more actions
Plug 'tpope/vim-abolish'
"}}}
"Syntax ============================{{{
Plug 'ianks/vim-tsx'
Plug 'sheerun/vim-polyglot'
Plug 'othree/javascript-libraries-syntax.vim', { 'for':['javascript', 'typescript'] }
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/dbext.vim'
Plug 'ElmCast/elm-vim', {'for': 'elm'}
Plug 'ap/vim-css-color', { 'for': [
      \ 'typescript.tsx'
      \ ,'javascript.jsx'
      \ , 'css'
      \ , 'javascript'
      \ , 'typescript'
      \ ] }
"}}}
"Git ==============================={{{
Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'jreybert/vimagit'
"}}}
" Clojure =========================
"   Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"   Plug 'guns/vim-sexp'
"   Plug 'guns/vim-clojure-highlight'
"   let g:clojure_fold = 1
"   let g:sexp_filetypes = ''
"   Plug 'tpope/vim-salve'
"   let g:salve_auto_start_repl = 1
"Text Objects ====================={{{
Plug 'tommcdo/vim-exchange'
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'bkad/CamelCaseMotion'
Plug 'kana/vim-textobj-function'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
"}}}
"Search Tools =======================
Plug 'dyng/ctrlsf.vim'
Plug 'kopischke/vim-fetch' "Allows GF to open vim at a specific line
Plug 'airblade/vim-rooter'
"Coding tools ======================={{{
Plug 'matze/vim-move'
Plug 'kshenoy/vim-signature'
Plug 'janko-m/vim-test'
Plug 'scrooloose/nerdcommenter'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'KabbAmine/vCoolor.vim', { 'on': ['VCoolor', 'VCase'] }
Plug 'othree/jspc.vim', {'for': ['javascript', 'typescript']}
Plug 'kassio/neoterm', Cond(has('nvim'))
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
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' } "Go for Vim
"}}}
"Themes =============================== {{{
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons' " This Plugin must load after the others - Add file type icons to vim
call plug#end()

" Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript'  }
""---------------------------------------------------------------------------//
" Colorscheme ideas
""---------------------------------------------------------------------------//
" Plug 'rakr/vim-one'
" Plug 'mhartington/oceanic-next'
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif
"}}}
