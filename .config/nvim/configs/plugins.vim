"--------------------------------------------------------------------------------
"PLUGINS
"--------------------------------------------------------------------------------

"--------------------------------------------------------------------------------
" Plug Setup {{{1
"--------------------------------------------------------------------------------
" auto-install vim-plug
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
if has("nvim")
  let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
  if !filereadable(autoload_plug_path)
    silent execute '!curl -fLo ' . autoload_plug_path . ' --create-dirs
          \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  unlet autoload_plug_path
  call plug#begin(stdpath('data') . '/plugged')
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

" SOURCE: https://github.com/junegunn/vim-plug/pull/875
" Check if the files is in the plugs map but also IMPORTANTLY
" that it is in the runtime path
function! PluginLoaded(plugin_name) abort
  return has_key(g:plugs, a:plugin_name) && stridx(&rtp, g:plugs[a:plugin_name].dir)
endfunction

function! Cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction
"--------------------------------------------------------------------------------
" CORE {{{1
"--------------------------------------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator', Cond(exists('$TMUX'))
"--------------------------------------------------------------------------------
" Utilities {{{1
"--------------------------------------------------------------------------------
Plug 'chip/vim-fat-finger', {'on': [], 'for': []}
Plug 'arecarn/vim-fold-cycle'
" https://github.com/iamcco/markdown-preview.nvim/issues/50
Plug 'iamcco/markdown-preview.nvim', {
      \ 'do': ':call mkdp#util#install()',
      \ 'for': ['markdown']
      \ }
Plug 'cohama/lexima.vim'
Plug 'mbbill/undotree', {'on': ['UndotreeToggle']} " undo plugin for vim
Plug 'psliwka/vim-smoothie'
Plug 'moll/vim-bbye'
Plug 'vim-test/vim-test', { 'on': ['TestFile', 'TestNearest', 'TestSuite'] }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'AndrewRadev/tagalong.vim', {'for': ['typescriptreact', 'javascriptreact', 'html']}
Plug 'liuchengxu/vim-which-key'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'itchyny/vim-highlighturl'
" TODO marks are currently broken in neovim i.e. deleted marks are resurrected on restarting nvim
" so disable mark related plugins. Remove this guard when this problem is fixed
if !has('nvim')
  Plug 'kshenoy/vim-signature'
endif
"--------------------------------------------------------------------------------
" Knowledge and task management
"--------------------------------------------------------------------------------
Plug 'vimwiki/vimwiki'
"--------------------------------------------------------------------------------
" Optional plugins
"--------------------------------------------------------------------------------
if has('mac')
  " We're not in Kansas(Linux) anymore
  Plug 'embear/vim-localvimrc'
  " we use rainbow on mac as we aren't using treesitter yet
  Plug 'luochen1990/rainbow'
endif
"--------------------------------------------------------------------------------
" Profiling
"--------------------------------------------------------------------------------
" Both are quite useful but their commands overlap so must use
" one or the other
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
"--------------------------------------------------------------------------------
" TPOPE {{{1
"--------------------------------------------------------------------------------
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
" sets searchable path for filetypes like go so 'gf' works
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-sleuth'
"--------------------------------------------------------------------------------
" Syntax {{{1
"--------------------------------------------------------------------------------
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
"--------------------------------------------------------------------------------
" Git {{{1
"--------------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'rhysd/conflict-marker.vim'
Plug 'kdheepak/lazygit.nvim', {'on': 'LazyGit'}
"--------------------------------------------------------------------------------
" Text Objects {{{1
"--------------------------------------------------------------------------------
Plug 'AndrewRadev/splitjoin.vim'
Plug 'svermeulen/vim-subversive'
""---------------------------------------------------------------------------//
" Deprecated: Word transposition mappings from in favour of the plugin below:
" http://superuser.com/questions/290360/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449
""---------------------------------------------------------------------------//
Plug 'AndrewRadev/dsf.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'chaoren/vim-wordmotion'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
      \ | Plug 'kana/vim-operator-user'
      \ | Plug 'glts/vim-textobj-comment'
      \ | Plug 'inside/vim-textobj-jsxattr'
"--------------------------------------------------------------------------------
" Search Tools {{{1
"--------------------------------------------------------------------------------
Plug 'justinmk/vim-sneak'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/goyo.vim', { 'for': ['vimwiki','markdown'] }
"--------------------------------------------------------------------------------
" Dev plugins  {{{1
"--------------------------------------------------------------------------------
if has('nvim')
  if !has('mac')
    Plug 'lukas-reineke/format.nvim'
    " Plugin for visualising the tree sitter tree whilst developing
    Plug 'nvim-treesitter/playground', {'on': 'TSPlaygroundToggle'}
    Plug 'rafcamlet/nvim-luapad', { 'on': ['Luapad'] }
    Plug 'p00f/nvim-ts-rainbow'
    Plug 'nvim-treesitter/nvim-treesitter'
  endif
  if $DEVELOPING
    Plug '~/Desktop/Coding/nvim-toggleterm.lua'
    Plug '~/Desktop/Coding/nvim-bufferline.lua'
    Plug '~/Desktop/Coding/nvim-web-devicons'
    Plug '~/Desktop/Coding/nvim-treesitter'
    Plug '~/Desktop/Coding/dependency-assist.nvim'
    Plug '~/Desktop/Coding/nvim-tree.lua'
  else
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'akinsho/nvim-toggleterm.lua'
    Plug 'akinsho/nvim-bufferline.lua'
    Plug 'akinsho/dependency-assist.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
  endif
else
  " vim-devicons must be loaded before vim buffet in order for icons to be used
  Plug 'ryanoasis/vim-devicons'
  Plug 'bagrat/vim-buffet'
endif
"--------------------------------------------------------------------------------
" Themes  {{{1
"--------------------------------------------------------------------------------
" vim-one has a MUCH better startup time than onedark and has a light theme
Plug 'rakr/vim-one'
" More actively maintained that vim-one
" Plug 'joshdick/onedark.vim'
"--------------------------------------------------------------------------------
" Alternatives color schemes {{{2
"--------------------------------------------------------------------------------
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'kaicataldo/material.vim'
" Plug 'haishanh/night-owl.vim'
" Plug 'patstockwell/vim-monokai-tasty'
" Plug 'flrnd/candid.vim'
" Plug 'chuling/ci_dark'
" Plug 'tomasiser/vim-code-dark'

" Disable netrw
let g:loaded_netrwPlugin = 0

call plug#end()

" cfilter plugin allows filter down an existing quickfix list
packadd! cfilter
packadd! matchit

" Lazy load plugins like vim fat finger
" because it otherwise takes 80ms i.e. the slowest
" thing to load blocking vim startup time
"
" NOTE: these can't be lazy loaded using vim-plug's mechanism
" because there is no specific filetype or command I want to
" trigger these for
function s:lazy_load_plugins() abort
  let lazy_plugins = ['vim-fat-finger']
  for p in lazy_plugins
    call plug#load(p)
  endfor
endfunction

function s:install_missing_plugins() abort
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall --sync | q
  endif
endfunction

" Install any missing plugins on vim enter or on writing this file
augroup AutoInstallPlugins
  autocmd!
  autocmd VimEnter * call <SID>install_missing_plugins()
  autocmd BufWritePost <buffer> call <SID>install_missing_plugins()
augroup END

function! s:setup_extra_keys()
  nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
  nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
endfunction

augroup PlugDiffExtra
  autocmd!
  autocmd FileType vim-plug call s:setup_extra_keys()
augroup END

nnoremap <silent><leader>pi :PlugInstall<CR>
nnoremap <silent><leader>ps :PlugStatus<CR>
nnoremap <silent><leader>pc :PlugClean<CR>
nnoremap <silent><leader>pu :PlugUpdate<CR>
" vim:foldmethod=marker
