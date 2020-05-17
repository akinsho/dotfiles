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

" This function allow me to specify titles for special case buffers like the preview window or a quickfix window
" CREDIT:
" https://vi.stackexchange.com/questions/18079/how-to-check-whether-the-location-list-for-the-current-window-is-open?rq=1
function! statusline#special_buffers() abort
  let is_location_list = get(getloclist(0, {'winid':0}), 'winid', 0)
  return is_location_list ? 'Location List' :
        \ s:is_bt('quickfix') ? 'QuickFix' : &previewwindow ? 'preview' : ''
endfunction

function! statusline#modified(...) abort
  let l:icon = get(a:, '1', '✎')
  return &ft =~ 'help' ? '' : &modified ? l:icon : ''
endfunction

function! statusline#readonly(...) abort
  let icon = get(a:, '1', '')
  return &ft =~ 'help' || &previewwindow || &readonly ? icon : ''
endfunction

function! statusline#file_format() abort
  let l:icon = &fileformat
  if exists("*WebDevIconsGetFileFormatSymbol") && !has('gui_running')
    let l:icon = WebDevIconsGetFileFormatSymbol()
  endif
  return winwidth(0) > 70 ? (&fileformat . ' ' . l:icon) : ''
endfunction

function! statusline#filename(...) abort
  let filename_modifier = get(a:, '1', '%:t')
  let fname = expand(filename_modifier)
  return fname == 'ControlP' ? 'ControlP' :
        \ fname == '__Tagbar__' ? 'Tagbar' :
        \ fname =~ '__Gundo\|NERD_tree' ? 'NERD Tree' :
        \ s:is_ft('ctrlsf') ? 'CtrlSF' :
        \ s:is_ft('defx') ? 'Defx' :
        \ s:is_ft('dbui') ? 'Dadbod UI' :
        \ s:is_ft('fugitive') ? 'Fugitive ' :
        \ s:is_ft('gitcommit') ? 'Git commit ' :
        \ s:is_ft('defx') ? 'Defx ⌨' :
        \ s:is_ft('ctrlsf') ? 'CtrlSF 🔍' :
        \ s:is_ft('vim-plug') ? 'vim-plug ⚉':
        \ s:is_ft('help') ? 'help ':
        \ s:is_ft('undotree') ? 'UndoTree ⮌' :
        \ s:is_ft('coc-explorer') ? 'Coc Explorer' :
        \ fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree 🖿' :
        \ strlen(statusline#special_buffers()) ? statusline#special_buffers() :
        \ (strlen(statusline#readonly()) ? statusline#readonly() . ' ' : '') .
        \ (strlen(fname) ? fname : '[No Name]')
endfunction

function! statusline#filetype() abort
  if !strlen(&filetype) || statusline#show_plain_statusline()
    return ''
  endif
  let l:icon = has('gui_running') || !exists('*WebDevIconsGetFileTypeSymbol') ?
        \ &filetype :
        \ WebDevIconsGetFileTypeSymbol()
  return winwidth(0) > 70 ? l:icon : ''
endfunction

function! statusline#file_component() abort
  return statusline#filename() . " " . statusline#filetype()
endfunction
