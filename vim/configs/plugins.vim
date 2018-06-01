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

" Deoplete  {{{1
"NVIM ====================================
  if !exists('g:gui_oni')
    Plug 'itchyny/lightline.vim'
    Plug 'ap/vim-buftabline'
    Plug 'airblade/vim-rooter'
    Plug 'Shougo/echodoc.vim'
    Plug 'mhartington/nvim-typescript', {'do': function('DoRemote')}
    Plug 'Xuyuanp/nerdtree-git-plugin'
    function! BuildTern(info)
      if a:info.status ==# 'installed' || a:info.force
        !npm install && npm install -g tern
      endif
    endfunction
    Plug 'ternjs/tern_for_vim', {'do':function('BuildTern')}
    Plug 'carlitux/deoplete-ternjs',
      \{'do': 'npm install -g tern' }
    " Code completion
    Plug 'Shougo/neco-vim',      { 'for': 'vim' },
    Plug 'wokalski/autocomplete-flow', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
    Plug 'roxma/nvim-yarp', Cond(!has('nvim'))
    Plug 'roxma/vim-hug-neovim-rpc', Cond(!has('nvim'))
    Plug 'zchee/deoplete-go',          { 'for' : 'go', 'do': 'make'}
    Plug 'ujihisa/neco-look',          { 'for': 'markdown' }
    Plug 'pbogut/deoplete-elm',        { 'for': 'elm' },
    Plug 'scrooloose/nerdtree'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'kristijanhusak/vim-js-file-import'
  let g:buftabline_modified_symbol = '✎ ' "Local version of the plugin
endif
" Plug 'autozimu/LanguageClient-neovim',{ 'do': function('DoRemote')}
" CORE {{{1
"================================
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'
Plug 'mattn/emmet-vim'
Plug 'cohama/lexima.vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'

"TMUX {{{1
"============================
"Navigate panes in vim and tmux with the same bindings
Plug 'christoomey/vim-tmux-navigator'
"Utilities {{{1
"============================
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} " undo plugin for vim
Plug 'chip/vim-fat-finger' "Autocorrects 4,000 common typos
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/splitjoin.vim'
" Plug 'vimwiki/vimwiki', { 'on': [
"       \'<Plug>(VimwikiTab)',
"       \'<Plug>(VimwikiIndex)'
"       \] }
" Plug 'junegunn/vim-easy-align',
"       \{ 'on': [ '<Plug>(EasyAlign)' ] }
" Plug 'embear/vim-localvimrc'
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

"Syntax {{{1
"============================
Plug 'ianks/vim-tsx'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'othree/javascript-libraries-syntax.vim',
       \ { 'for':[ 'javascript', 'typescript' ] }
 Plug 'styled-components/vim-styled-components',
"Git {{{1
" ==============================
Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'sodapopcan/vim-twiggy'
Plug 'jreybert/vimagit', { 'on': ['Magit', 'MagitOnly'] }
"Text Objects {{{1
"=====================
Plug 'chaoren/vim-wordmotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
Plug 'haya14busa/vim-operator-flashy'
Plug 'kana/vim-textobj-user'
       \ | Plug 'kana/vim-operator-user'
       \ | Plug 'glts/vim-textobj-comment'
       \ | Plug 'kana/vim-textobj-function'
       \ | Plug 'thinca/vim-textobj-function-javascript'
       \ | Plug 'whatyouhide/vim-textobj-xmlattr'

"Search Tools {{{1
"=======================
Plug 'rizzatti/dash.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'kshenoy/vim-signature'
Plug 'tomtom/tcomment_vim'
Plug 'kassio/neoterm',        Cond(has('nvim'))
Plug 'junegunn/goyo.vim',     Cond(!exists('g:gui_oni'),{ 'for':'markdown' })
Plug 'mhinz/vim-sayonara',    { 'on': 'Sayonara' }
Plug 'takac/vim-hardtime',    Cond(!exists('g:gui_oni'), { 'on': ['HardTimeToggle', 'HardTimeOn'] })

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
Plug 'heavenshell/vim-jsdoc'

"Themes  {{{1
"===============================
Plug 'joshdick/onedark.vim'
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
