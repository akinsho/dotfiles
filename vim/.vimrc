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

let g:gui_neovim_running = has('gui_running') || has('gui_vimr') || exists('g:gui_oni')

let g:dotfiles = $DOTFILES
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
                exe 'source' fpath
                let l:loaded += 1
            catch
                echohl WarningMsg
                echom 'Error: ----->' . v:exception
                echom 'Could not load '.fpath
                echohl none
            endtry
        endif
    endfor
    echohl WarningMsg
    " echom l:loaded . ' plugin configs successfully loaded'
    echohl none
endfunction

function! Source(arg) abort
    try
        exe 'source' . g:dotfiles . a:arg
    catch
        echohl WarningMsg
        echom 'Error: ----->' . v:exception
        echom 'Could not load'.a:arg
        echohl none
    endtry
endfunction

if !exists('g:gui_oni')
  " alternatives: #22252B
  let g:term_win_highlight = {
        \"guibg": "black",
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
syntax enable
" ----------------------------------------------------------------------
" Plugin Configurations
" ----------------------------------------------------------------------
let s:settings = g:dotfiles . '/vim/configs/plugins'
call Source('/vim/configs/general.vim')
call Source('/vim/configs/open-changed-files.vim')
call Source('/vim/configs/highlight.vim')
call Source('/vim/configs/mappings.vim')
call Source('/vim/configs/autocommands.vim')
call LoadConfigs(s:settings)
if exists('g:gui_oni') "NOTE: Order Matters here as this works like an after overwriting Settings for oni
  call Source('/vim/gui/oni.vim')
endif
"---------------------------------------------------------------------------//
" Essential Settings - Taken care of by Vim Plug
"---------------------------------------------------------------------------//
filetype plugin indent on
