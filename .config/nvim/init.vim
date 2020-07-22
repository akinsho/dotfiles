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

let g:gui_neovim_running = has('gui_running') || has('gui_vimr') || exists('g:gui_oni')
" WARNING: Hard coding the location of my dotfiles is brittle
let g:dotfiles = strlen($DOTFILES) ? $DOTFILES : '~/.dotfiles'
let g:vim_dir = g:dotfiles . '/.config/nvim'

function! VimrcMessage(msg) abort
  echohl WarningMsg
  echom a:msg
  echohl none
endfunction

function! s:safely_source(arg) abort
  try
    execute 'source ' . a:arg
    return 1
  catch
    call VimrcMessage('Error ->' . v:exception)
    call VimrcMessage('Could not load'. a:arg )
    return 0
  endtry
endfunction

let g:dotfiles_plugins_loaded = 0
let g:dotfiles_plugins_errored = 0

function! s:load_plugin_configs(settings_dir) abort
  let plugins = split(globpath(a:settings_dir, '*.vim'), '\n')
  let loaded = 0
  let errors = 0
  for fpath in plugins
    let s:inactive = match(fpath ,"inactive")
    if s:inactive == -1
      let s:result = s:safely_source(fpath)
      if s:result == 0
        let errors += 1
        let g:dotfiles_plugins_errored += 1
      endif
      let loaded += s:result
      let g:dotfiles_plugins_loaded += s:result
    endif
  endfor
endfunction

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

"-----------------------------------------------------------------------
" Local vimrc
"-----------------------------------------------------------------------
let s:vimrc_local=$HOME.'/.vimrc.local'
if filereadable(s:vimrc_local)
  call s:safely_source(s:vimrc_local)
endif
" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
"  Order matters here as the plugins should be loaded before the other setup
let s:config_files = [
    \ '/configs/plugins.vim',
    \ '/configs/general.vim',
    \ '/configs/highlight.vim',
    \ '/configs/mappings.vim',
    \ '/configs/autocommands.vim',
    \ '/configs/statusline.vim'
    \]

for file in s:config_files
  call s:safely_source(g:vim_dir . file)
endfor

call s:load_plugin_configs(g:vim_dir . '/configs/plugins')

if has('nvim')
  luafile $DOTFILES/.config/nvim/init.lua
endif
"---------------------------------------------------------------------------//
