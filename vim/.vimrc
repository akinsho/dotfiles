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
if filereadable(expand('~/Dotfiles/vim/configs/plugins.vim'))
  source $HOME/Dotfiles/vim/configs/plugins.vim
endif

"-----------------------------------------------------------------------
syntax enable

"-----------------------------------------------------------------------
"Leader bindings
"-----------------------------------------------------------------------
let g:mapleader = ',' "Remap leader key
let g:maplocalleader = '\<space>' "Local leader key

"-----------------------------------------------------------------------
" General Settings
"-----------------------------------------------------------------------
if filereadable(expand('~/Dotfiles/vim/configs/general.vim'))
  source $HOME/Dotfiles/vim/configs/general.vim
endif

" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
if filereadable(expand('~/Dotfiles/vim/configs/configurations.vim'))
  source $HOME/Dotfiles/vim/configs/configurations.vim
endif

""---------------------------------------------------------------------------//
" Home-made Plugins
""---------------------------------------------------------------------------//
source $HOME/Dotfiles/vim/plugins/grep.vim
source $HOME/Dotfiles/vim/plugins/togglelist.vim

"-----------------------------------------------------------------------
" Mappings
"-----------------------------------------------------------------------
if filereadable(expand('~/Dotfiles/vim/configs/mappings.vim'))
  source $HOME/Dotfiles/vim/configs/mappings.vim
endif

