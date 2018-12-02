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

function! LoadConfigs(s) abort
    let s:plugins = split(globpath(a:s, '*.vim'), '\n')
    let l:loaded = 0
    for fpath in s:plugins
        let s:inactive = match(fpath ,"inactive")
        if s:inactive == -1
            try
                exe 'source ' fpath
                let l:loaded += 1
            catch
                echohl WarningMsg
                echom 'Error: ----->' . v:exception
                echom 'Could not load '.fpath
                echohl none
            endtry
        endif
    endfor
    " echohl WarningMsg
    " echom l:loaded . ' plugin configs successfully loaded'
    " echohl none
endfunction

" This could be refactored to be used with the above if I was less lazy/more clever
function! Source(arg) abort
    try
        exe 'source ' . g:dotfiles . a:arg
    catch
        echohl WarningMsg
        echom 'Error: ----->' . v:exception
        echom 'Could not load'.a:arg
        echohl none
    endtry
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
call Source('/vim/configs/plugins.vim')
"-----------------------------------------------------------------------
" Essential Settings - Taken care of by Vim Plug
"---------------------------------------------------------------------------//
filetype plugin indent on
syntax enable
" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
let s:settings = g:dotfiles . '/vim/configs/plugins'
call Source('/vim/configs/general.vim')
call Source('/vim/configs/highlight.vim')
call Source('/vim/configs/mappings.vim')
call Source('/vim/configs/autocommands.vim')
call Source('/vim/configs/open-changed-files.vim')
" FIXME: these two things should not be being sourced manually here
" I need to figure out how to create symlinks from here to the correct
" directories if they don't already exist
call Source('/vim/configs/utils.vim') "Previously autoloaded but difficult to port
call Source('/vim/plugin/token.vim')
call LoadConfigs(s:settings)
"NOTE: Order Matters here as this works like an after overwriting Settings for oni
if exists('g:gui_oni')
  call Source('/vim/gui/oni.vim')
endif
"---------------------------------------------------------------------------//
" echom 'Read Vimrc'
