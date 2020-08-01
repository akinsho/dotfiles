" Blacklist certain plugins and buffer types
function! s:is_blacklisted()
  if buflisted(bufnr('')) == 0
    return 1
  endif

  if &diff
    return 1
  endif

  if &previewwindow
    return 1
  endif

  for ft in g:number_filetype_exclusions
    if &ft =~ ft
      return 1
    endif
  endfor

  for buftype in g:number_buftype_exclusions
    if &buftype =~ buftype
      return 1
    endif
  endfor
  return 0
endfunction

function! numbers#enable_relative_number()
  if s:is_blacklisted()
    return
  endif
  setlocal number relativenumber
endfunction

function! numbers#disable_relative_number()
  if s:is_blacklisted()
    return
  endif
  setlocal number norelativenumber
endfunction
