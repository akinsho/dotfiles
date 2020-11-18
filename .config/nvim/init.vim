" ________  ___  __    ___  ________   ________           ________  ________  ________   ________ ___  ________
" |\   __  \|\  \|\  \ |\  \|\   ___  \|\   ____\         |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\
" \ \  \|\  \ \  \/  /|\ \  \ \  \\ \  \ \  \___|_        \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|
" \ \   __  \ \   ___  \ \  \ \  \\ \  \ \_____  \        \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___
"  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \        \ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \
"   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \        \ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
"    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\        \|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|
"                                        \|_________|
" Each section of my config has been separated out into subsections in ./configs/
filetype off " required  Prevents potential side-effects from system ftdetects scripts

"---------------------------------------------------------------------------//
" Config Loader
"---------------------------------------------------------------------------//
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

" WARNING: Hard coding the location of my dotfiles is brittle
let g:dotfiles = strlen($DOTFILES) ? $DOTFILES : '~/.dotfiles'
let g:vim_dir = g:dotfiles . '/.config/nvim'

function! VimrcMessage(msg, ...) abort
  let hl = 'WarningMsg'
  if a:0 " a:0 is the number of optional args provided
    let hl = a:1
  endif
  execute 'echohl '. hl
  echom a:msg
  echohl none
endfunction

" stolen from ThePrimegean's video
" https://www.youtube.com/watch?v=9L4sW047oow
if has('nvim-0.5')
  command! -nargs=? ResetLuaPlugin lua require"devtools".reset_package(<q-args>)
endif
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
" :h runtime - this fuzzy maches files within vim's runtime path
runtime configs/preload.vim
runtime configs/general.vim
runtime configs/plugins.vim
runtime configs/highlight.vim
runtime configs/mappings.vim
runtime configs/autocommands.vim

if has('nvim-0.5')
  lua require('statusline')
  lua require('lsp')
endif

runtime! configs/plugins/*.vim
"-----------------------------------------------------------------------
" Local vimrc
"-----------------------------------------------------------------------
if filereadable(fnamemodify('~/.vimrc.local', ':p'))
  source ~/.vimrc.local
endif
"---------------------------------------------------------------------------//
