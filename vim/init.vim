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

""---------------------------------------------------------------------------//
" Config Loader
""---------------------------------------------------------------------------//
augroup vimrc "Ensure all autocommands are cleared
  autocmd!
augroup END

" The operating system is assigned to a global variable that
" that can be used elsewhere for conditional system based logic
" TODO: find out if a better alternative is `if has('mac') or if has('linux')`
let g:os = substitute(system('uname'), "\n", "", "")

if g:os == "Linux"
  let g:open_command = 'xdg-open'
elseif g:os == "Darwin"
  let g:open_command = 'open'
endif

let g:gui_neovim_running = has('gui_running') || has('gui_vimr') || exists('g:gui_oni')
let g:dotfiles = $DOTFILES
let g:disable_relativity = 1

" Environment variables aren't consisitently available on guis so dont use them
" If possible or default to the literal string if possible
if g:gui_neovim_running
    let g:dotfiles = '~/Dotfiles'
endif

function! s:safely_source(arg) abort
    try
        exe 'source ' . a:arg
        return 1
    catch
        echohl WarningMsg
        echom 'Error ->' . v:exception
        echom 'Could not load'. a:arg
        echohl none
        return 0
    endtry
endfunction

function! s:load_configs(settings_dir) abort
  let s:plugins = split(globpath(a:settings_dir, '*.vim'), '\n')
  let s:loaded = 0
  let s:errors = 0
  for fpath in s:plugins
    let s:inactive = match(fpath ,"inactive")
    if s:inactive == -1
      let s:result = s:safely_source(fpath)
      if s:result == 0
        let s:errors += 1
      endif
      let s:loaded += s:result
    endif
  endfor
  echom 'loaded ' . s:loaded . ' configs successfully! ' . s:errors . ' errors'
endfunction

if !exists('g:gui_oni')
  " alternatives: black
  let g:term_win_highlight = {
        \"guibg": "#22252B",
        \"ctermbg":"BLACK",
        \}
else
  let g:term_win_highlight = {
        \"guibg": "black",
        \"ctermbg":"black",
        \}
endif

"-----------------------------------------------------------------------
"Leader bindings
"-----------------------------------------------------------------------
let g:mapleader      = ',' "Remap leader key
let g:maplocalleader = "\<space>" "Local leader key MUST BE DOUBLE QUOTES
"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------
call s:safely_source(g:dotfiles . '/vim/configs/plugins.vim')
"-----------------------------------------------------------------------
" Essential Settings - Taken care of by Vim Plug
"---------------------------------------------------------------------------//
filetype plugin indent on
syntax enable
" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
let s:files = [
  \ '/vim/configs/general.vim',
  \ '/vim/configs/highlight.vim',
  \ '/vim/configs/mappings.vim',
  \ '/vim/configs/autocommands.vim',
  \ '/vim/configs/open-changed-files.vim',
  \ '/vim/configs/utils.vim',
  \ '/vim/plugin/token.vim'
  \]

for file in s:files
  call s:safely_source(g:dotfiles . file)
endfor

call s:load_configs(g:dotfiles . '/vim/configs/plugins')

"NOTE: Order Matters here as this works like an after overwriting Settings for oni
if exists('g:gui_oni')
  call s:safely_source(g:dotfiles . '/vim/gui/oni.vim')
endif
"---------------------------------------------------------------------------//
