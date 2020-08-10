" Helpers -- generalise the methods for checking a ft or buftype
function! s:is_ft(ft) abort
  return &ft ==? a:ft
endfunction

function! s:is_bt(bt) abort
  return &bt ==? a:bt
endfunction

function! statusline#show_plain_statusline() abort
  return s:is_ft('help') ||
        \ s:is_ft('ctrlsf')||
        \ s:is_ft('tsplayground')||
        \ s:is_ft('coc-explorer') ||
        \ s:is_ft('LuaTree') ||
        \ s:is_ft('neoterm')||
        \ s:is_ft('vista') ||
        \ s:is_ft('fugitive') ||
        \ s:is_bt('terminal')||
        \ s:is_bt('quickfix') ||
        \ s:is_bt('nofile') ||
        \ s:is_bt('nowrite') ||
        \ s:is_bt('acwrite') ||
        \ s:is_ft('startify') ||
        \ &previewwindow
endfunction

" This function allow me to specify titles for special case buffers
" like the preview window or a quickfix window
" CREDIT: https://vi.stackexchange.com/questions/18079/how-to-check-whether-the-location-list-for-the-current-window-is-open?rq=1
function! statusline#special_buffers() abort
  let is_location_list = get(getloclist(0, {'filewinid':0}), 'filewinid', 0)
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

let s:filetype_map = {
      \ 'dbui' : 'Dadbod UI',
      \ 'tsplayground': 'Treesitter 侮',
      \ 'vista' : 'Vista',
      \ 'fugitive' : 'Fugitive ',
      \ 'fugitiveblame' : 'Git blame ',
      \ 'gitcommit' : 'Git commit ',
      \ 'startify' : 'Startify',
      \ 'defx' : 'Defx ⌨',
      \ 'ctrlsf' : 'CtrlSF 🔍',
      \ 'vim-plug' : 'vim-plug ⚉',
      \ 'help' : 'help ',
      \ 'undotree' : 'UndoTree ⮌',
      \ 'coc-explorer' : 'Coc Explorer',
      \ 'LuaTree' : 'Lua Tree',
      \ 'toggleterm': '  Terminal('.fnamemodify($SHELL, ':t').')'
      \ }

let s:filename_map = {
      \ '__Tagbar__' : 'Tagbar',
      \ 'ControlP' : 'CtrlP',
      \ '__Gundo__' : 'Gundo',
      \ '__Gundo_Preview__' : 'Gundo Preview',
      \ 'NERD_tree' : 'NERDTree 🖿',
      \}

function! statusline#get_dir() abort
  if strlen(&buftype)
        \ || expand('%:t') == ''
        \ || get(s:filetype_map, &ft, '') != ''
        \ || &previewwindow
    return ''
  endif
  return expand("%:h") . "/"
endfunction

function! statusline#filename(...) abort
  if s:is_bt('terminal') && !s:is_ft('toggleterm')
    return '  '. expand('%:t')
  endif

  let special_buffer_name = statusline#special_buffers()
  if strlen(special_buffer_name)
    return special_buffer_name
  endif

  let readonly_indicator = ' '. statusline#readonly()

  let name = get(s:filetype_map, &filetype, '')
  if strlen(name)
    return name
  endif

  let filename_modifier = get(a:, '1', '%:t')
  let fname = expand(filename_modifier)

  let filename = get(s:filename_map, fname, '')
  if strlen(filename)
    return filename
  endif

  if !strlen(fname)
    return '[No Name]'
  endif
  return fname . readonly_indicator
endfunction

function s:get_lua_devicon() abort
  try
    let name = bufname()
    let extension = fnamemodify(name, ':e')
    let devicon = luaeval("require'nvim-web-devicons'.get_icon(_A[1], _A[2], _A[3])",
          \ [name, extension, { 'default': v:true }])
    return devicon
  catch
    return ''
  endtry
endfunction

function! statusline#filetype() abort
  if !strlen(&filetype) || statusline#show_plain_statusline()
    return ''
  endif
  let ft_icon = &filetype
  if has('nvim')
    let ft_icon = s:get_lua_devicon()
  elseif exists('*WebDevIconsGetFileTypeSymbol')
    let ft_icon = WebDevIconsGetFileTypeSymbol()
  endif
  return winwidth(0) > 70 ? ft_icon : ''
endfunction

function! statusline#file_component() abort
  return statusline#filename() . " " . statusline#filetype()
endfunction
