" ________  ___  __    ___  ________   ________           ________  ________  ________   ________ ___  ________
"|\   __  \|\  \|\  \ |\  \|\   ___  \|\   ____\         |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\
"\ \  \|\  \ \  \/  /|\ \  \ \  \\ \  \ \  \___|_        \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|
" \ \   __  \ \   ___  \ \  \ \  \\ \  \ \_____  \        \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___
"  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \        \ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \
"   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \        \ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
"    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\        \|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|
"                                        \|_________|
" Each section of my config has been separated out into subsections in
" ./configs/
filetype off " required  Prevents potential side-effects from system ftdetects scripts
"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------
if filereadable(expand($DOTFILES.'/vim/configs/plugins.vim'))
  source $DOTFILES/vim/configs/plugins.vim
endif

"-----------------------------------------------------------------------
syntax enable
"-----------------------------------------------------------------------
"Leader bindings
"-----------------------------------------------------------------------
let g:mapleader      = ',' "Remap leader key

let g:maplocalleader = "\<space>" "Local leader key MUST BE DOUBLE QUOTES
"-----------------------------------------------------------------------
" General Settings
"-----------------------------------------------------------------------
if filereadable(expand($DOTFILES.'/vim/configs/general.vim'))
  source $DOTFILES/vim/configs/general.vim
endif

" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
if filereadable(expand($DOTFILES.'/vim/configs/configurations.vim'))
  source $DOTFILES/vim/configs/configurations.vim
endif

"-----------------------------------------------------------------------
" Mappings
"-----------------------------------------------------------------------
if filereadable(expand($DOTFILES.'/vim/configs/mappings.vim'))
  source $DOTFILES/vim/configs/mappings.vim
endif

""---------------------------------------------------------------------------//
" AUTOCOMMANDS
""---------------------------------------------------------------------------//
source $DOTFILES/vim/configs/autocommands.vim
source $DOTFILES/vim/nerdtree.vim
""---------------------------------------------------------------------------//
" Essential Settings - Taken care of by Vim Plug
""---------------------------------------------------------------------------//
filetype plugin indent on
