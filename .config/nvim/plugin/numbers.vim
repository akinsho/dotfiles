" Inspiration
" 1. vim-relativity
" 2. numbers.vim - https://github.com/myusuf3/numbers.vim/blob/master/plugin/numbers.vim
"
" NOTE: it's important that we use BufReadPost as otherwise the buftype and filetype
" variables might not be set correctly
let g:number_filetype_exclusions = [
      \ 'markdown',
      \ 'vimwiki',
      \ 'vim-plug',
      \ 'gitcommit',
      \ 'toggleterm',
      \ 'fugitive',
      \ 'coc-explorer',
      \ 'coc-list',
      \ 'list',
      \ 'LuaTree',
      \ 'startify',
      \ 'help'
      \ ]

let g:number_buftype_exclusions = [
      \ 'terminal',
      \ 'nowrite',
      \ 'quickfix',
      \ 'help',
      \ 'nofile',
      \ 'acwrite'
      \ ]

call numbers#enable_relative_number()

augroup ToggleRelativeLineNumbers
  autocmd!
  autocmd BufReadPost * call numbers#enable_relative_number()
  autocmd BufNewFile  * call numbers#enable_relative_number()
  autocmd WinEnter    * call numbers#enable_relative_number()
  autocmd WinLeave    * call numbers#disable_relative_number()
  autocmd FocusLost   * call numbers#disable_relative_number()
  autocmd FocusGained * call numbers#enable_relative_number()
  autocmd InsertEnter * call numbers#disable_relative_number()
  autocmd InsertLeave * call numbers#enable_relative_number()
augroup end
