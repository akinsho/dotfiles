" Helpers -- generalise the methods for checking a ft or buftype
let s:plain_filetypes = [
      \ 'help',
      \ 'ctrlsf',
      \ 'minimap',
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

function! statusline#is_plain(context) abort
  return index(s:plain_filetypes, a:context.filetype) >= 0
        \ || index(s:plain_buftypes, a:context.buftype) >= 0
        \ || a:context.preview
        \ || exists('#goyo')
endfunction

" This function allow me to specify titles for special case buffers
" like the preview window or a quickfix window
" CREDIT: https://vi.stackexchange.com/a/18090
function! statusline#special_buffers(context) abort
  let is_loc_list = get(getloclist(0, {'filewinid':0}), 'filewinid', 0)
  let norm_terminal = a:context.buftype ==? 'terminal' && a:context.filetype ==# ''

  return is_loc_list ? 'Location List' :
        \ a:context.buftype ==? 'quickfix' ? 'QuickFix' :
        \ norm_terminal ? 'Terminal('.fnamemodify($SHELL, ':t').')' :
        \ a:context.preview ? 'preview' : ''
endfunction

function! statusline#modified(context, ...) abort
  let l:icon = get(a:, '1', '✎')
  return a:context.filetype =~ 'help' ? '' : a:context.modified ? l:icon : ''
endfunction

function! statusline#readonly(context, ...) abort
  let icon = get(a:, '1', '')
  return a:context.filetype =~ 'help' || a:context.preview || a:context.readonly ? icon : ''
endfunction

function! statusline#file_format(context) abort
  let format_icon = a:context.fileformat
  if exists("*WebDevIconsGetFileFormatSymbol") && !has('gui_running')
    let format_icon = WebDevIconsGetFileFormatSymbol()
  endif
  return winwidth(0) > 70 ? (a:context.fileformat . ' ' . format_icon) : ''
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
      \ 'calendar': ''
      \ }

let s:exceptions_bt_icons = {
      \ 'terminal': ' ',
      \ 'quickfix': '',
      \}

let s:exceptions_ft_names = {
      \ 'minimap': 'minimap',
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
      \ 'toggleterm': {_,bufnum -> 'Terminal('.fnamemodify($SHELL, ':t').')['.getbufvar(bufnum, 'toggle_number').']'}
      \}

function s:buf_expand(bufnum, mod) abort
  return expand('#'. a:bufnum . a:mod)
endfunction

function! statusline#filename(context, ...) abort
  let special_buffer_name = statusline#special_buffers(a:context)
  if strlen(special_buffer_name)
    return ['', special_buffer_name]
  endif

  let readonly_indicator = ' '. statusline#readonly(a:context)

  let filename_modifier = get(a:, '1', ':t')
  let fname = s:buf_expand(a:context.bufnum, filename_modifier)
  " as the name can be a reference to a function it must
  " be uppercase as all function references must be.
  let Name = get(s:exceptions_ft_names, a:context.filetype, '')

  if type(Name) == v:t_func
    return ['', Name(fname, a:context.bufnum)]
  endif

  if strlen(Name)
    return ['', Name]
  endif

  if !strlen(fname)
    return ['', 'No Name']
  endif

  let directory = ''
  if !strlen(a:context.buftype)
        \ && get(s:exceptions_ft_names, a:context.filetype, '') == ''
        \ && s:buf_expand(a:context.bufnum, ':t') != ''
        \ && !a:context.preview
    let directory = s:buf_expand(a:context.bufnum, ":h") . "/"
  endif

  let filename = fname . readonly_indicator
  return [directory, filename]
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

function s:get_lua_devicon(bufname) abort
  try
    let extension = fnamemodify(a:bufname, ':e')
    let icon_data = v:lua.__statusline_icon(a:bufname, extension)
    return icon_data
  catch /.*/
    echoerr v:exception
    return ['', '']
  endtry
endfunction

" cache of statusline icon highlight names
" e.g.
" {
"  "VimDevIconStatusline": 1
" }
let s:icon_hl_cache = {}

function s:set_ft_icon_highlight(hl, bg_hl) abort
  if !strlen(a:hl)
    return ''
  endif
  let name = a:hl.'Statusline'
  " prevent recreating highlight group for every buffer instead save
  " the newly created highlight name's status i.e. created or not
  let already_created = get(s:icon_hl_cache, name, 0)

  if !already_created
    let bg_color = synIDattr(hlID(a:bg_hl), 'bg')
    let fg_color = synIDattr(hlID(a:hl), 'fg')
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

function! statusline#filetype(context) abort
  let ft_exception = get(s:exceptions_ft_icons, a:context.filetype, '')
  if strlen(ft_exception) > 0
    return [ft_exception, '']
  endif

  let bt_exception = get(s:exceptions_bt_icons, a:context.buftype, '')
  if strlen(bt_exception) > 0
    return [bt_exception, '']
  endif

  let hl = ''
  let ft_icon = a:context.filetype

  if has('nvim')
    try
      let [ft_icon, raw_hl] = s:get_lua_devicon(bufname(a:context.bufnum))
      let hl = s:set_ft_icon_highlight(raw_hl, 'Normal')
    catch /.*/
      echoerr v:exception
    endtry
  elseif exists('*WebDevIconsGetFileTypeSymbol')
    let ft_icon = WebDevIconsGetFileTypeSymbol()
  endif
  return [ft_icon, hl]
endfunction
