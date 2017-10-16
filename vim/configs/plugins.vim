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

call plug#begin('~/.vim/plugged')
"}}}
" Deoplete  ============================={{{
"NVIM ====================================
if has('nvim')
  " Code completion
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'ajh17/VimCompletesMe'
endif
Plug 'mhartington/nvim-typescript', Cond(has('nvim'), {'do': ':UpdateRemotePlugins'})
Plug 'zchee/deoplete-go',           Cond(has('nvim'), { 'for' : 'go', 'do': 'make'})
Plug 'carlitux/deoplete-ternjs',    Cond(has('nvim'),
      \ { 'for': ['javascript', 'typescript'],  'do': 'npm install -g tern' })
Plug 'ujihisa/neco-look',           Cond(has('nvim'), { 'for': 'markdown' }) "English completion
Plug 'Shougo/neco-vim',             Cond(has('nvim'), { 'for': 'vim' })
Plug 'pbogut/deoplete-elm',         Cond(has('nvim'), { 'for': 'elm' })
Plug 'wellle/tmux-complete.vim'   , Cond(exists('$TMUX'))
"}}}
" CORE ================================ {{{
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips'
Plug 'Shougo/echodoc.vim'
Plug 'scrooloose/nerdtree'
      \ | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mattn/emmet-vim'
Plug 'cohama/lexima.vim'
Plug 'easymotion/vim-easymotion'
function! BuildTern(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install
  endif
endfunction
Plug 'ternjs/tern_for_vim', Cond(has('nvim'), {'do':function('BuildTern')})
Plug 'mhinz/vim-startify'
if !has('gui_running')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        \ | Plug 'junegunn/fzf.vim'
endif
"}}}
"TMUX ============================ {{{
Plug 'christoomey/vim-tmux-navigator' "Navigate panes in vim and tmux with the same bindings
"}}}
"Utilities ============================{{{
Plug 'mbbill/undotree',{'on':['UndotreeToggle']} "Add Gundo - undo plugin for vim
Plug 'chip/vim-fat-finger', { 'on':[] } "Autocorrects 4,000 common typos
Plug 'yuttie/comfortable-motion.vim'
augroup load_fat_finger
  autocmd!
  autocmd InsertEnter * call plug#load('vim-fat-finger')
        \| autocmd! load_fat_finger
augroup END
Plug 'junegunn/vim-easy-align', { 'on': [ '<Plug>(EasyAlign)' ] }
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'vimwiki/vimwiki'
Plug 'itchyny/calendar.vim'
"}}}
"TPOPE ===================================={{{
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
"}}}
"Syntax ============================{{{
Plug 'Yggdroot/indentLine'
Plug 'hail2u/vim-css-syntax', { 'for': ['css', 'sass', 'scss', 'less', 'jsx', 'tsx'] }
Plug 'sheerun/vim-polyglot'
Plug 'ianks/vim-tsx', { 'for': ['typescript.tsx'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for':[
      \ 'javascript',
      \ 'typescript'
      \ ] }
Plug 'editorconfig/editorconfig-vim'
Plug 'ap/vim-css-color', { 'for': [  'vim',  'css',  'javascript',  'typescript' ] }
Plug 'styled-components/vim-styled-components', { 'branch': 'rewrite' }
"}}}
"Git ==============================={{{
Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'jreybert/vimagit', { 'on': ['Magit', 'MagitOnly'] }
"}}}
"Text Objects ====================={{{
Plug 'tommcdo/vim-exchange'
Plug 'bkad/CamelCaseMotion'
Plug 'wellle/targets.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'terryma/vim-expand-region'
Plug 'kana/vim-textobj-user'
      \ | Plug 'whatyouhide/vim-textobj-xmlattr'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'kana/vim-textobj-function'
      \ | Plug 'thinca/vim-textobj-function-javascript'
"}}}
"Search Tools ======================={{{
Plug 'dyng/ctrlsf.vim'
Plug 'kopischke/vim-fetch' "Allows GF to open vim at a specific line
"}}}
"Coding tools ======================={{{
Plug 'janko-m/vim-test'
Plug 'keith/investigate.vim'
Plug 'kshenoy/vim-signature'
Plug 'scrooloose/nerdcommenter'
Plug 'kassio/neoterm',        Cond(has('nvim'))
Plug 'takac/vim-hardtime', { 'on': ['HardTimeToggle', 'HardTimeOn'] }
Plug 'junegunn/goyo.vim',     { 'for':'markdown' }
Plug 'KabbAmine/vCoolor.vim', { 'on': ['VCoolor', 'VCase'] }
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
Plug 'euclio/vim-markdown-composer', { 'for': 'markdown', 'do': function('BuildComposer') }
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
"}}}
"Themes =============================== {{{
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'joshdick/onedark.vim'
Plug 'ryanoasis/vim-devicons'

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
else
  runtime! macros/matchit.vim
endif
" Don't use netrw at all
" let g:loaded_netrwPlugin = 1
"}}}
" Plug 'rstacruz/vim-xtract'
" Plug 'idanarye/vim-merginal'
