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
" vim-devicons must be loaded before vim buffet in order for icons to be used
Plug 'ryanoasis/vim-devicons' , Cond(!has('gui_running'))
Plug 'bagrat/vim-buffet'
Plug 'airblade/vim-rooter'
Plug 'mattn/emmet-vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'honza/vim-snippets'
"============================
"TMUX {{{1
"============================
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator', Cond(!has('gui_running'))
"============================
"Utilities {{{1
"============================
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown'] }
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
Plug 'psliwka/vim-smoothie'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'janko/vim-test'
Plug 'norcalli/nvim-colorizer.lua'
" =====================
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
Plug 'tpope/vim-dadbod'
      \ | Plug 'kristijanhusak/vim-dadbod-ui'
" ===========================
"Syntax {{{1
"============================
Plug 'Akin909/vim-dune', { 'for': ['dune']} " syntax highlighting for ocaml/reason dune files
Plug 'Yggdroot/indentLine'
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': ['go'] }
Plug 'sheerun/vim-polyglot'
" =============================
"Git {{{1
" ==============================
Plug 'rhysd/conflict-marker.vim'
Plug 'lambdalisue/gina.vim'
" Text Objects {{{1
" =====================
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/splitjoin.vim'
""---------------------------------------------------------------------------//
" Deprecated: Word transposition mappings from in favour of the plugin below:
" http://superuser.com/questions/290360/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449
""---------------------------------------------------------------------------//
Plug 'AndrewRadev/sideways.vim'
Plug 'dstein64/vim-win'
Plug 'AndrewRadev/tagalong.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
      \ | Plug 'kana/vim-operator-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'inside/vim-textobj-jsxattr'
"=======================
"Search Tools {{{1
"=======================
Plug 'dyng/ctrlsf.vim' "TODO try CocSearch instead
Plug 'junegunn/vim-peekaboo'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/goyo.vim', Cond(!exists('g:gui_oni'),{ 'for':['vimwiki','markdown'] })
"=======================
"Filetype Plugins {{{1
"======================
Plug 'chrisbra/csv.vim', Cond(!exists('g:gui_oni'), { 'for': 'csv' })
Plug 'mhinz/vim-crates', {'for': ['rust', 'toml']}
"=======================
"Themes  {{{1
"=======================
Plug 'rakr/vim-one'
Plug 'haishanh/night-owl.vim'
Plug 'patstockwell/vim-monokai-tasty'
" Colorscheme Ideas
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
endif
" vim:foldmethod=marker
