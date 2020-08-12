" spell-checker:disable
" NOTE: this file is way too cumbersome to spellcheck
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
"--------------------------------------------------------------------------------
" Utilities {{{1
"--------------------------------------------------------------------------------
Plug 'vimwiki/vimwiki', {
      \ 'on':  ['VimwikiIndex', 'VimwikiTabIndex'],
      \ 'for': ['vimwiki', 'markdown']
      \ }
Plug 'junegunn/vim-easy-align', {'for': ['vim']}
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
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'vim-test/vim-test', { 'on': ['TestFile', 'TestNearest', 'TestLatest'] }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'AndrewRadev/tagalong.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'
"--------------------------------------------------------------------------------
" Experimental
"--------------------------------------------------------------------------------
Plug 'puremourning/vimspector'
"--------------------------------------------------------------------------------
" Optional plugins
"--------------------------------------------------------------------------------
if has('mac')
  " We're not in Kansas(Linux) anymore
  Plug 'embear/vim-localvimrc'
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
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
"sets searchable path for filetypes like go so 'gf' works
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-projectionist'
" Plug 'tpope/vim-dadbod', { 'on': ['DB'] }
" Plug 'kristijanhusak/vim-dadbod-ui', { 'on': ['DBUI', 'DBUIToggle'] }
"--------------------------------------------------------------------------------
" Syntax {{{1
"--------------------------------------------------------------------------------
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
"--------------------------------------------------------------------------------
" Git {{{1
"--------------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
" TODO re-add this once https://github.com/rhysd/conflict-marker.vim/pull/11 is merged
" Plug 'rhysd/conflict-marker.vim'
Plug 'kdheepak/lazygit.nvim'
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
Plug 'mhinz/vim-crates', {'for': ['rust', 'toml']}
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
"--------------------------------------------------------------------------------
" Dev plugins  {{{1
"--------------------------------------------------------------------------------
if has('nvim')
  if !has('mac')
    " Plugin for visualising the tree sitter tree whilst developing
    Plug 'nvim-treesitter/playground'
    Plug 'rafcamlet/nvim-luapad', { 'on': ['LuaPad'] }
  endif
  if $DEVELOPING
    Plug '~/Desktop/Coding/nvim-bufferline.lua'
    Plug '~/Desktop/Coding/nvim-web-devicons'
    Plug '~/Desktop/Coding/nvim-tree.lua'
    Plug '~/Desktop/Coding/nvim-treesitter'
    " TODO remove this once rhysd/conflict-marker.vim#11 is merged
    Plug '~/Desktop/Coding/conflict-marker.vim'
  else
    Plug 'akinsho/nvim-bufferline.lua', { 'branch': 'dev' }
    " TODO remove this once rhysd/conflict-marker.vim#11 is merged
    Plug 'akinsho/conflict-marker.vim', { 'branch': 'update-conflict-highlight-autocmds' }
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'
  endif
else
  " vim-devicons must be loaded before vim buffet in order for icons to be used
  Plug 'ryanoasis/vim-devicons'
  Plug 'bagrat/vim-buffet'
endif

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

augroup LazyLoadPlugins
  autocmd!
  autocmd CursorHold,CursorHoldI * call s:lazy_load_plugins()
  " if we are lazy loading vimwiki we should set the filetype
  " when we enter an associated file. this will force vim plug to
  " load the plugin
  autocmd BufEnter *.wiki set filetype=vimwiki
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

nnoremap <silent><leader>pi :PlugInstall<CR>
nnoremap <silent><leader>ps :PlugStatus<CR>
nnoremap <silent><leader>pc :PlugClean<CR>
nnoremap <silent><leader>pu :PlugUpdate<CR>
" vim:foldmethod=marker
