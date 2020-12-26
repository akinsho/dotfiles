" -------------------------------------------------------------------------------
"       _/_/    _/    _/
"    _/    _/  _/  _/      Akin Sowemimo's dotfiles
"   _/_/_/_/  _/_/         https://github.com/akinsho
"  _/    _/  _/  _/
" _/    _/  _/    _/
" -------------------------------------------------------------------------------

filetype off

augroup vimrc "Ensure all autocommands are cleared
  autocmd!
augroup END

" The operating system is assigned to a global variable that
" that can be used elsewhere for conditional system based logic
if has('mac')
  let g:open_command = 'open'
elseif has('unix')
  let g:open_command = 'xdg-open'
endif

function! PluginLoaded(plugin_name) abort
  return !empty(glob('~/.local/share/nvim/site/pack/packer/*/'.a:plugin_name))
endfunction

" WARNING: Hard coding the location of my dotfiles is brittle
let g:dotfiles = strlen($DOTFILES) ? $DOTFILES : '~/.dotfiles'
let g:vim_dir = g:dotfiles . '/.config/nvim'
"-----------------------------------------------------------------------
"Leader bindings
"-----------------------------------------------------------------------
let g:mapleader      = ',' "Remap leader key
let g:maplocalleader = "\<space>" "Local leader key MUST BE DOUBLE QUOTES
"-----------------------------------------------------------------------
" Essential Settings - Taken care of by Vim Plug
"-----------------------------------------------------------------------
filetype plugin indent on
syntax enable
" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
" Order matters here as the plugins should be loaded before the other setup
" :h runtime - this fuzzy matches files within vim's runtime path
if has('nvim-0.5')
  lua require("as.plugins")
endif

runtime configs/general.vim
runtime configs/highlight.vim
runtime configs/mappings.vim
runtime configs/autocommands.vim

if has('nvim-0.5')
  lua require('as')
endif

runtime! configs/plugins/*.vim
"-----------------------------------------------------------------------
" Local vimrc
"-----------------------------------------------------------------------
if filereadable(fnamemodify('~/.vimrc.local', ':p'))
  source ~/.vimrc.local
endif
"---------------------------------------------------------------------------//
