" Helpers -- generalise the methods for checking a ft or buftype
function! s:is_ft(ft) abort
  return &ft ==# a:ft
endfunction

function! s:is_bt(bt) abort
  return &bt ==# a:bt
endfunction

function! statusline#show_plain_statusline() abort
  return s:is_ft('help') ||
        \ s:is_ft('ctrlsf')||
        \ s:is_ft('coc-explorer') ||
        \ s:is_ft('terminal')||
        \ s:is_ft('neoterm')||
        \ s:is_ft('fugitive') ||
        \ s:is_bt('quickfix') ||
        \ s:is_bt('nofile') ||
        \ &previewwindow
endfunction

" This function allow me to specify titles for special case buffers
" like the previewwindow or a quickfix window
function! statusline#special_buffers() abort
  "Credit: https://vi.stackexchange.com/questions/18079/how-to-check-whether-the-location-list-for-the-current-window-is-open?rq=1
  let is_location_list = get(getloclist(0, {'winid':0}), 'winid', 0)
  return is_location_list ? 'Location List' :
        \ s:is_bt('quickfix') ? 'QuickFix' : &previewwindow ? 'preview' : ''
endfunction

function! statusline#modified() abort
  return &ft =~ 'help' ? '' : &modified ? '✎' : &modifiable ? '' : '-'
endfunction

function! statusline#readonly() abort
  return &ft =~ 'help' || &previewwindow || &readonly ? '' : ''
endfunction

function! statusline#file_format() abort
  if has('gui_running')
    return winwidth(0) > 70 ? (&fileformat . ' ') : ''
  else
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endif
endfunction

function! statusline#filename() abort
  let fname = expand('%:t')
  return fname == 'ControlP' ? 'ControlP' :
        \ fname == '__Tagbar__' ? '' :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ s:is_ft('ctrlsf') ? '' :
        \ s:is_ft('defx') ? '' :
        \ s:is_ft('dbui') ? '' :
        \ s:is_ft('coc-explorer') ? '' :
        \ strlen(statusline#special_buffers()) ? statusline#special_buffers() :
        \ (strlen(statusline#readonly()) ? statusline#readonly() . ' ' : '') .
        \ (strlen(fname) ? fname : '[No Name]') .
        \ (strlen(statusline#modified()) ? ' ' . statusline#modified() : '')
endfunction

function! statusline#filetype() abort
  if !strlen(&filetype) || statusline#show_plain_statusline()
    return ''
  endif
  let l:icon = has('gui_running') ? &filetype : WebDevIconsGetFileTypeSymbol()
  return winwidth(0) > 70 ? l:icon : ''
endfunction

function! statusline#file_component() abort
  return statusline#filename() . " " . statusline#filetype()
endfunction
