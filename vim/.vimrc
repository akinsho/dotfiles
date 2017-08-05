" ________  ___  __    ___  ________   ________           ________  ________  ________   ________ ___  ________
"|\   __  \|\  \|\  \ |\  \|\   ___  \|\   ____\         |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\
"\ \  \|\  \ \  \/  /|\ \  \ \  \\ \  \ \  \___|_        \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|
" \ \   __  \ \   ___  \ \  \ \  \\ \  \ \_____  \        \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___
"  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \        \ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \
"   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \        \ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
"    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\        \|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|
"                                        \|_________|


"Sections of this vimrc can be folded or unfolded using za, they are marked with 3 curly braces


set nocompatible "IMproved, required
filetype off " required  Prevents potential side-effects
" from system ftdetects scripts
"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------
source $HOME/Dotfiles/vim/configs/plugins.vimrc
"-----------------------------------------------------------------------
syntax enable
"-----------------------------------------------------------------------
"Leader bindings
"-----------------------------------------------------------------------
let mapleader = "," "Remap leader key
let maplocalleader = "\<space>" "Local leader key
"-----------------------------------------------------------------------
" General Settings
"-----------------------------------------------------------------------
source $HOME/Dotfiles/vim/configs/general.vimrc
" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
source $HOME/Dotfiles/vim/configs/configurations.vimrc
"-----------------------------------------------------------------------
" Mappings
"-----------------------------------------------------------------------
source $HOME/Dotfiles/vim/configs/mappings.vim
"-----------------------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------------------
set background=dark
"colorscheme nova
colorscheme quantum
if has('nvim')
  let g:terminal_color_0  = '#ffffff'
  let g:terminal_color_15 = '#eeeeec'
endif
