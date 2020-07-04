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
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup VimPlug
      au!
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  endif
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
" that it is in the runtimepath
function PluginLoaded(plugin_name) abort
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
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-rooter'
Plug 'mattn/emmet-vim', { 'for': [
      \ 'html',
      \ 'javascript',
      \ 'typescript',
      \ 'javascriptreact',
      \ 'typescriptreact',
      \ ]}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      \ | Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator', Cond(exists('$TMUX'))
if has('nvim')
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
endif
"--------------------------------------------------------------------------------
" Utilities {{{1
"--------------------------------------------------------------------------------
Plug 'vimwiki/vimwiki', {
      \ 'on':  ['VimwikiIndex', 'VimwikiTabIndex'],
      \ 'for': ['vimwiki', 'markdown']
      \ }
Plug 'chip/vim-fat-finger', {'on': [], 'for': []}
Plug 'arecarn/vim-fold-cycle'
Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF', 'CtrlSFOpen', 'CtrlSFToggle']}
" https://github.com/iamcco/markdown-preview.nvim/issues/50
Plug 'iamcco/markdown-preview.nvim', {
      \ 'do': {-> mkdp#util#install()},
      \ 'for': ['markdown']
      \ }
Plug 'cohama/lexima.vim'
Plug 'mbbill/undotree', {'on': ['UndotreeToggle']} " undo plugin for vim
Plug 'psliwka/vim-smoothie'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'vim-test/vim-test', { 'on': ['TestFile', 'TestNearest', 'TestLatest'] }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'AndrewRadev/tagalong.vim', {'for': [
      \ 'typescriptreact',
      \ 'javascriptreact',
      \ 'reason',
      \ 'html',
      \ 'typescript',
      \ 'javascript'
      \ ]}
Plug 'stsewd/gx-extended.vim'
"--------------------------------------------------------------------------------
" Optional plugins
"--------------------------------------------------------------------------------
if has('mac')
  " We're not in kansas(linux) anymore
  Plug 'embear/vim-localvimrc'
endif

if has('nvim')
  Plug 'rafcamlet/nvim-luapad', { 'on': ['LuaPad'] }
endif
"--------------------------------------------------------------------------------
" Profiling
"--------------------------------------------------------------------------------
" Both are quite useful but their commands overlap so must use
" one or the other
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
" Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }
"--------------------------------------------------------------------------------
" TPOPE {{{1
"--------------------------------------------------------------------------------
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
"sets searchable path for filetypes like go so 'gf' works
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dadbod', { 'on': ['DB'] }
      \ | Plug 'kristijanhusak/vim-dadbod-ui', { 'on': ['DBUI', 'DBUIToggle'] }
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
"--------------------------------------------------------------------------------
" Text Objects {{{1
"--------------------------------------------------------------------------------
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'svermeulen/vim-subversive'
""---------------------------------------------------------------------------//
" Deprecated: Word transposition mappings from in favour of the plugin below:
" http://superuser.com/questions/290360/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449
""---------------------------------------------------------------------------//
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
Plug 'kshenoy/vim-signature'
Plug 'junegunn/goyo.vim', { 'for': ['vimwiki','markdown'] }
"--------------------------------------------------------------------------------
" Filetype Plugins {{{1
"--------------------------------------------------------------------------------
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'mhinz/vim-crates', {'for': ['rust', 'toml']}
"--------------------------------------------------------------------------------
" Themes  {{{1
"--------------------------------------------------------------------------------
" NOTE: vim-one has a MUCH better startup time than onedark
Plug 'rakr/vim-one' " alternative one dark with a light theme
"--------------------------------------------------------------------------------
" Alternatives color schemes {{{2
"--------------------------------------------------------------------------------
" Plug 'joshdick/onedark.vim' " More actively maintained that vim-one
" Plug 'kaicataldo/material.vim'
" Plug 'haishanh/night-owl.vim'
" Plug 'patstockwell/vim-monokai-tasty'
" Plug 'flrnd/candid.vim'

"--------------------------------------------------------------------------------
" Personal plugins  {{{1
"--------------------------------------------------------------------------------
if has('nvim')
  Plug 'Akin909/nvim-bufferline.lua'
  if !has('mac')
    " Plug '~/Desktop/Coding/nvim-bufferline.lua'
  endif
else
  " vim-devicons must be loaded before vim buffet in order for icons to be used
  Plug 'bagrat/vim-buffet'
endif

call plug#end()
if has('patch-7.4.1649') && !has('nvim') " NeoVim loads matchit by default
  packadd! matchit
endif

" Disable unnecessary default plugins
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1

" Lazy load plugins like vim fat finger
" because it otherwise takes 80ms ie. the slowest
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

augroup LazyLoadPlugins
  autocmd!
  autocmd CursorHold,CursorHoldI * call s:lazy_load_plugins()
augroup END

function s:install_missing_plugins() abort
  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall --sync | q
  endif
endfunction

" Install any missing plugins on vim enter or on writing this file
augroup AutoInstallPlugins
  autocmd!
  autocmd VimEnter * call s:install_missing_plugins()
  execute 'autocmd BufWritePost '. g:vim_dir . '/configs/plugins.vim' .
	\ ' call <SID>install_missing_plugins()'
augroup END

function! s:scroll_preview(down)
  silent! wincmd P
  if &previewwindow
    execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
    wincmd p
  endif
endfunction

function! s:setup_extra_keys()
  nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
  nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
  nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
  nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
  nmap <silent> <buffer> <c-j> <c-n>o
  nmap <silent> <buffer> <c-k> <c-p>o
endfunction

augroup PlugDiffExtra
  autocmd!
  autocmd FileType vim-plug call s:setup_extra_keys()
augroup END
" vim:foldmethod=marker
