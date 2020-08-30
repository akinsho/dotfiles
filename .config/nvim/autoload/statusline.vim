" Helpers -- generalise the methods for checking a ft or buftype
function! s:is_ft(ft) abort
  return &ft ==? a:ft
endfunction

function! s:is_bt(bt) abort
  return &bt ==? a:bt
endfunction

let s:plain_filetypes = [
      \ 'help',
      \ 'ctrlsf',
      \ 'tsplayground',
      \ 'coc-explorer',
      \ 'LuaTree',
      \ 'neoterm',
      \ 'vista',
      \ 'fugitive',
      \ 'startify',
      \ 'vimwiki',
      \ 'markdown'
      \]

let s:plain_buftypes = [
      \ 'terminal',
      \ 'quickfix',
      \ 'nofile',
      \ 'nowrite',
      \ 'acwrite',
      \]

function! statusline#show_plain_statusline() abort
  return index(s:plain_filetypes, &ft) >= 0 || index(s:plain_buftypes, &bt) >= 0
        \ || exists('#goyo')
        \ || &previewwindow
endfunction

" This function allow me to specify titles for special case buffers
" like the preview window or a quickfix window
" CREDIT: https://vi.stackexchange.com/questions/18079/how-to-check-whether-the-location-list-for-the-current-window-is-open?rq=1
function! statusline#special_buffers() abort
  let is_location_list = get(getloclist(0, {'filewinid':0}), 'filewinid', 0)
  let is_regular_terminal = s:is_bt('terminal') && &ft ==# ''

  return is_location_list ? 'Location List' :
        \ s:is_bt('quickfix') ? 'QuickFix' :
        \ is_regular_terminal ? 'Terminal('.fnamemodify($SHELL, ':t').')' :
        \ &previewwindow ? 'preview' : ''
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

let s:exceptions_ft_icons = {
      \ 'dbui' : '',
      \ 'vista' : 'פּ',
      \ 'tsplayground': '侮',
      \ 'fugitive' : '',
      \ 'fugitiveblame' : '',
      \ 'gitcommit' : '',
      \ 'startify' : '',
      \ 'defx' : '⌨',
      \ 'ctrlsf' : '🔍',
      \ 'vim-plug' : '⚉',
      \ 'vimwiki': 'ﴬ',
      \ 'help' : '',
      \ 'undotree' : 'פּ',
      \ 'coc-explorer' : '',
      \ 'LuaTree' : 'פּ',
      \ 'toggleterm': ' ',
      \ }

let s:exceptions_bt_icons = {
      \ 'terminal': ' ',
      \ 'quickfix': '',
      \}

let s:exceptions_ft_names = {
      \ 'dbui' : 'Dadbod UI',
      \ 'tsplayground': 'Treesitter',
      \ 'vista' : 'Vista',
      \ 'fugitive' : 'Fugitive',
      \ 'fugitiveblame' : 'Git blame',
      \ 'gitcommit' : 'Git commit',
      \ 'startify' : 'Startify',
      \ 'defx' : 'Defx',
      \ 'ctrlsf' : 'CtrlSF',
      \ 'vim-plug' : 'vim plug',
      \ 'vimwiki': 'vim wiki',
      \ 'help' : 'help',
      \ 'undotree' : 'UndoTree',
      \ 'coc-explorer' : 'Coc Explorer',
      \ 'LuaTree' : 'Lua Tree',
      \ 'toggleterm': {-> 'Terminal('.fnamemodify($SHELL, ':t').')['.b:toggle_number.']'}
      \}

function! statusline#get_dir() abort
  if strlen(&buftype)
        \ || expand('%:t') == ''
        \ || get(s:exceptions_ft_names, &ft, '') != ''
        \ || &previewwindow
    return ''
  endif
  return expand("%:h") . "/"
endfunction

function! statusline#filename(...) abort
  let special_buffer_name = statusline#special_buffers()
  if strlen(special_buffer_name)
    return special_buffer_name
  endif

  let readonly_indicator = ' '. statusline#readonly()

  " as the name can be a reference to a function it must
  " be uppercase as all function references must be.
  let Name = get(s:exceptions_ft_names, &filetype, '')
  if type(Name) == v:t_func
    return Name()
  elseif strlen(Name)
    return Name
  endif

  let filename_modifier = get(a:, '1', '%:t')
  let fname = expand(filename_modifier)

  if !strlen(fname)
    return '[No Name]'
  endif
  return fname . readonly_indicator
endfunction

" this is required since devicons returns 2 values which need to be collected
" into a table before they can be read out in vimscript
lua << EOF
  _G.__statusline_icon = function(name, extension)
    local icon, hl = require'nvim-web-devicons'.get_icon(name, extension, {
      default = true
    })
    return {icon, hl}
  end
EOF

function s:get_lua_devicon() abort
  try
    let extension = fnamemodify(bufname(), ':e')
    let icon_data = v:lua.__statusline_icon(bufname(), extension)
    return icon_data
  catch
    echoerr v:errmsg
    return ['', '']
  endtry
endfunction

" cache of statusline icon highlight names
" e.g.
" {
"  "VimDevIconStatusline": 1
" }
let s:icon_hl_cache = {}

function statusline#filetype_icon_highlight(hl_name) abort
  if !has('nvim')
    return ''
  endif

  let [_, hl] = s:get_lua_devicon()
  let name = hl.'Statusline'
  " prevent recreating highlight group for every buffer instead save
  " the newly created highlight name's status i.e. created or not
  let already_created = get(s:icon_hl_cache, name, 0)

  if !already_created
    let bg_color = synIDattr(hlID(a:hl_name), 'bg')
    let fg_color = synIDattr(hlID(hl), 'fg')
    let cmd = 'highlight '.name.' guibg='.bg_color.' guifg='.fg_color
    silent execute cmd
    execute 'augroup '.name
    execute 'autocmd!'
    execute 'autocmd ColorScheme * '.cmd
    execute 'augroup END'
    let s:icon_hl_cache[name] = 1
  endif
  return name
endfunction

function! statusline#filetype() abort
  let ft_exception = get(s:exceptions_ft_icons, &ft, '')
  if strlen(ft_exception) > 0
    return ft_exception
  endif

  let bt_exception = get(s:exceptions_bt_icons, &bt, '')
  if strlen(bt_exception) > 0
    return bt_exception
  endif

  let ft_icon = &ft
  if has('nvim')
    let [ft_icon; _] = s:get_lua_devicon()
  elseif exists('*WebDevIconsGetFileTypeSymbol')
    let ft_icon = WebDevIconsGetFileTypeSymbol()
  endif
  return ft_icon
endfunction
