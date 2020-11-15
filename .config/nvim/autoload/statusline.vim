let s:plain_filetypes = [
      \ 'help',
      \ 'ctrlsf',
      \ 'minimap',
      \ 'tsplayground',
      \ 'coc-explorer',
      \ 'LuaTree',
      \ 'undotree',
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
function _G.__statusline_icon(name, extension)
    local icon, hl = require "nvim-web-devicons".get_icon(name, extension, {default = true})
    return {icon, hl}
end
EOF

function statusline#get_devicon(bufname) abort
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
    if strlen(bg_color) && strlen(fg_color)
      let cmd = 'highlight '.name.' guibg='.bg_color.' guifg='.fg_color
      silent execute cmd
      execute 'augroup '.name
      execute 'autocmd!'
      execute 'autocmd ColorScheme * '.cmd
      execute 'augroup END'
      let s:icon_hl_cache[name] = 1
    endif
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
      let [ft_icon, raw_hl] = statusline#get_devicon(bufname(a:context.bufnum))
      let hl = s:set_ft_icon_highlight(raw_hl, 'Normal')
    catch /.*/
      echoerr v:exception
    endtry
  elseif exists('*WebDevIconsGetFileTypeSymbol')
    let ft_icon = WebDevIconsGetFileTypeSymbol()
  endif
  return [ft_icon, hl]
endfunction

" FIXME this functions should search through the
" array and only apply this command for windows in column formation
" Add underlines between stacked horizontal windows
function! statusline#add_separators()
  let [layout; rest] = winlayout()
  let gui = layout ==# 'col' ? "underline" : "NONE"
  silent! execute 'highlight Statusline gui='.gui
  silent! execute 'highlight StatuslineNC gui='.gui
endfunction

function! statusline#file_encoding() abort
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function statusline#line_info() abort
  " TODO This component should truncate from the left not right
  return winwidth(0) > 120 ? '%.15(%l/%L %p%%%)' : ''
endfunction

" Sometimes special characters are passed into statusline components
" this sanitizes theses strings to prevent them mangling the statusline
" See: https://vi.stackexchange.com/questions/17704/how-to-remove-character-returned-by-system
function! s:sanitize_string(item) abort
  return substitute(a:item, '\n', '', 'g')
endfunction

function! s:truncate_string(item, ...) abort
  let limit = get(a:, '1', 50)
  let suffix = get(a: , '2', '…')
  return strlen(a:item) > limit ? strpart(a:item, 0, limit) . suffix : a:item
endfunction

function! s:truncate_statusline_component(item, ...) abort
  if !strlen(a:item)
    return ''
  endif
  let limit = get(a:, '1', 50)
  return '%.'.limit.'('.a:item.'%)'
endfunction

function statusline#diagnostic_info() abort
  let msgs = {'error': '', 'warning': '', 'information': ''}
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return msgs
  endif

  let warning_sign = get(g:, 'coc_status_warning_sign', 'W')
  let error_sign = get(g:, 'coc_status_error_sign', 'E')
  let information_sign = get(g:, 'coc_status_information_sign', '')

  let has_error = get(info, 'error', 0)
  let has_warning = get(info, 'warning', 0)
  let has_information = get(info, 'information', 0)

  if has_error
    let msgs.error = error_sign . info['error']
  endif
  if has_warning
    let msgs.warning =  warning_sign . info['warning']
  endif
  if has_information
    let msgs.information = information_sign . info['information']
  endif
  return msgs
endfunction

function s:pad(string, ...) abort
  let opts = get(a:, '1', { 'end': 1 , 'start': 1})
  let opt_end = get(opts, 'end', 1)
  let opt_start = get(opts, 'start', 1)
  let end = opt_end ? ' ' : ''
  let start = opt_start ? ' ' : ''
  return strlen(a:string) > 0 ? start . a:string . end : ''
endfunction

function statusline#statusline_lsp_status() abort
  let lsp_status = get(g:, 'coc_status', '')
  let truncated = s:truncate_string(lsp_status)
  return winwidth(0) > 100 ? trim(truncated) : ''
endfunction

function! statusline#statusline_current_fn() abort
  let current = get(b:, 'coc_current_function', '')
  let sanitized = s:sanitize_string(current)
  let trunctated = s:truncate_string(sanitized, 30)
  return winwidth(0) > 140 ? trim(trunctated) : ''
endfunction

function! statusline#statusline_git_status() abort
  " symbol opts -  , "\uf408"
  let prefix = ''
  let window_size = winwidth(0)
  let repo_status = get(g:, "coc_git_status", "")
  let buffer_status = trim(get(b:, "coc_git_status", "")) " remove excess whitespace

  let parts = split(repo_status)
  if len(parts) > 0
    let [prefix; rest] = parts
    let repo_status = join(rest, " ")
  endif

  " branch name should not exceed 30 chars if the window is under 200 columns
  if window_size < 200
    let repo_status = s:truncate_statusline_component(repo_status, 30)
  endif

  let component = repo_status . " ". buffer_status
  let length = strlen(component)
  " if there is no branch info show nothing
  if !strlen(repo_status) || window_size < 100
    return ['', '']
  endif
  " if the window is small drop the buffer changes
  if length > 30 && window_size < 140
    return [prefix, repo_status]
  endif
  return [prefix, component]
endfunction

function statusline#hl(hl) abort
  return "%#".a:hl."#"
endfunction

function! statusline#sep(item, ...) abort
  let opts = get(a:, '1', {})
  let before = get(opts, 'before', ' ')
  let prefix = get(opts, 'prefix', '')
  let small = get(opts, 'small', 0)
  let padding = get(opts, 'padding', 'prefix')
  let item_color = get(opts, 'color', '%#StItem#')
  let prefix_color = get(opts, 'prefix_color', '%#StPrefix#')
  let prefix_sep_color = get(opts, 'prefix_sep_color', '%#StPrefixSep#')

  let sep_color = get(opts, 'sep_color', '%#StSep#')
  let sep_color_left = strlen(prefix) ? prefix_sep_color : sep_color

  let prefix_item = prefix_color . prefix
  let item = a:item

  " depending on how padding is specified extra space
  " will be injected at specific points
  if padding == 'prefix' || padding == 'full'
    let prefix_item .= ' '
  endif

  if padding == 'full'
    let item = ' ' . item
  endif

  " %* resets the highlighting at the end of the separator so it
  " doesn't interfere with the next component
  let sep_icon_right = small ? '%*' : '█%*'
  let sep_icon_left = strlen(prefix) ? ''. prefix_item : small ? '' : '█'

  return before.
        \ sep_color_left.
        \ sep_icon_left.
        \ item_color.
        \ item.
        \ sep_color.
        \ sep_icon_right
endfunction

function! statusline#sep_if(item, condition, ...) abort
  if !a:condition
    return ''
  endif
  let l:opts = get(a:, '1', {})
  return statusline#sep(a:item, l:opts)
endfunction

func! statusline#item(component, hl, ...) abort
  if !strlen(a:component)
    return ''
  endif
  let opts = get(a:, '1', {})
  let before = get(opts, 'before', '')
  let after = get(opts, 'after', ' ')
  let prefix = get(opts, 'prefix', '')
  let prefix_color = get(opts, 'prefix_color', a:hl)
  return before . statusline#hl(prefix_color) . prefix .' '
        \ . statusline#hl(a:hl) . a:component . after . "%*"
endfunc

function statusline#item_if(item, condition, hl, ...) abort
  if !a:condition
    return ''
  endif
  return statusline#item(a:item, a:hl, get(a:, 1, {}))
endfunction
