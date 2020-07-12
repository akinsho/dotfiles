let g:number_filetype_exclusions = [
      \ 'vim-plug',
      \ 'vimwiki',
      \ 'git',
      \ 'toggleterm',
      \ 'fugitive',
      \ 'coc-explorer',
      \ 'coc-list',
      \ 'list',
      \ 'LuaTree',
      \ 'startify'
      \ ]

" TODO this doesn't seem to work, it's not clear when the buftype is being set
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
