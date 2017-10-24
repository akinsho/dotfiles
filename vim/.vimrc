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
let g:dotfiles = '~/Dotfiles/'
function! LoadConfigs(s) abort
    let s:plugins = split(globpath(a:s, '*.vim'), '\n')
    for fpath in s:plugins
        let s:inactive = match(fpath ,"inactive")
        if s:inactive == -1
            try
                exe 'source' fpath
            catch
                echohl WarningMsg
                echom 'Could not load '.fpath
                echohl none
            endtry
        endif
    endfor
    echohl WarningMsg
    " echom len(s:plugins).' plugin configs loaded'
    echohl none
endfunction

function! Source(arg) abort
    exe 'source' . g:dotfiles . a:arg
endfunction

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
call Source('/vim/configs/general.vim')
call Source('/vim/configs/open-changed-files.vim')
call Source('/vim/configs/highlight.vim')
"TODO: source all files with load config fn let s:configs = g:dotfiles.'.'/vim/configs'
let s:settings = g:dotfiles . '/vim/configs/plugins'
call LoadConfigs(s:settings)
call Source('/vim/configs/mappings.vim')
call Source('/vim/configs/autocommands.vim')
"---------------------------------------------------------------------------//
" Essential Settings - Taken care of by Vim Plug
"---------------------------------------------------------------------------//
filetype plugin indent on
