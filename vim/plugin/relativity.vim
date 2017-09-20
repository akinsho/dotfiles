"As Per the tin this toggles relativenumber and number depending on mode
" Blacklist certain plugins and buffer types
let g:filetype_ignore =
      \ get( g:, 'relativity_filetype_ignore', ['term://','vim-plug','startify','controlp', 'nerdtree', 'help','fugitive', 'tagbar'] )
let g:buftype_ignore =
      \ get( g:, 'relativity_buftype_ignore', ['term://','nomodifiable','nofile','help'] )

function! s:is_blacklisted()
  for ft in g:filetype_ignore
    if &ft =~ ft
      return 1
    endif
  endfor

  for buftype in g:buftype_ignore
    if &buftype =~ buftype
      return 1
    endif
  endfor
  return 0
endfunction

function! s:enable_relative_number()
  if s:is_blacklisted()
    return
  endif
  setlocal nonumber
  setlocal relativenumber
endfunction

function! s:disable_relative_number()
  if s:is_blacklisted()
    return
  endif
  setlocal number norelativenumber
endfunction

function! s:relativeNumber_on()
  call s:enable_relative_number()
  augroup relativity
    autocmd!
    autocmd BufEnter *    if !pumvisible() | call s:enable_relative_number() | endif
    autocmd BufLeave *    if !pumvisible() | call s:disable_relative_number() | endif
    autocmd WinEnter *    if !pumvisible() | call s:enable_relative_number() | endif
    autocmd WinLeave *    if !pumvisible() | call s:disable_relative_number() | endif
    autocmd FocusLost *   call s:disable_relative_number()
    autocmd FocusGained * call s:enable_relative_number()
    autocmd InsertEnter * call s:disable_relative_number()
    autocmd InsertLeave * call s:enable_relative_number()
  augroup END
endfunction


augroup numbertoggle
  autocmd!
  autocmd VimEnter * call s:relativeNumber_on()
augroup END
