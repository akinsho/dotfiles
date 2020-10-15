let s:ro_sym  = ''
let s:ma_sym  = "✗"
let s:mod_sym = "◇"

function! s:file_encoding() abort
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function s:line_info() abort
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

function s:diagnostic_info() abort
  let msgs = {'error': '', 'warning': '', 'information': ''}
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return msgs
  endif

  let warning_sign = get(g:, 'coc_status_warning_sign', 'W')
  let error_sign = get(g:, 'coc_status_error_sign', 'E')
  let information_sign = get(g:, 'coc_status_information_sign', '')

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

function StatuslineLanguageServer() abort
  let lsp_status = get(g:, 'coc_status', '')
  let truncated = s:truncate_string(lsp_status)
  return winwidth(0) > 100 ? s:pad(truncated, { 'start': 0 }) : ''
endfunction

function! StatuslineCurrentFunction() abort
  let current = get(b:, 'coc_current_function', '')
  let sanitized = s:sanitize_string(current)
  let trunctated = s:truncate_string(sanitized, 30)
  return winwidth(0) > 140 ? s:pad(trunctated, { 'start': 0 }) : ''
endfunction

function! s:statusline_git_status() abort
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

let s:st_mode     = {'color': '%#StMode#', 'sep_color': '%#StModeSep#'}
let s:st_info     = {'color': '%#StInfo#', 'sep_color': '%#StInfoSep#'}
let s:st_ok       = {'color': '%#StOk#', 'sep_color': '%#StOkSep#'}
let s:st_inactive = {'color': '%#StInactive#', 'sep_color': '%#StInactiveSep#'}
let s:st_error    = {'color': '%#StError#', 'sep_color': '%#StErrorSep#' }
let s:st_warning  = {'color': '%#StWarning#', 'sep_color': '%#StWarningSep#' }
let s:st_menu     = {'color': '%#StMenu#', 'sep_color': '%#StMenuSep#' }

let s:gold         = '#F5F478'
let s:white        = '#abb2bf'
let s:light_red    = '#e06c75'
let s:dark_red     = '#be5046'
let s:green        = '#98c379'
let s:light_yellow = '#e5c07b'
let s:dark_yellow  = '#d19a66'
let s:blue         = '#61afef'
let s:dark_blue    = '#4e88ff'
let s:magenta      = '#c678dd'
let s:cyan         = '#56b6c2'
let s:gutter_grey  = '#636d83'
let s:comment_grey = '#5c6370'
let s:inc_search_bg = synIDattr(hlID('Search'), 'bg')

function! s:set_statusline_colors() abort
  let s:normal_bg     = synIDattr(hlID('Normal'), 'bg')
  let s:normal_fg     = synIDattr(hlID('Normal'), 'fg')
  let s:pmenu_bg      = synIDattr(hlID('Pmenu'), 'bg')
  let s:string_fg     = synIDattr(hlID('String'), 'fg')
  let s:error_fg      = synIDattr(hlID('ErrorMsg'), 'fg')
  let s:comment_fg    =  synIDattr(hlID('Comment'), 'fg')
  let s:wildmenu_bg    =  synIDattr(hlID('Wildmenu'), 'bg')
  let s:warning_fg    = g:colors_name =~ 'one' ?
        \ s:light_yellow : synIDattr(hlID('WarningMsg'), 'fg')

  " NOTE: Unicode characters including vim devicons should NOT be highlighted
  " as italic or bold, this is because the underlying bold font is not necessarily
  " patched with the nerd font characters
  " terminal emulators like kitty handle this by fetching nerd fonts elsewhere
  " but this is not universal across terminals so should be avoided
  silent! execute 'highlight StMetadata guifg='.s:comment_fg.' guibg=NONE gui=italic,bold'
  silent! execute 'highlight StMetadataPrefix guifg='.s:comment_fg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StModified guifg='.s:string_fg.' guibg='.s:pmenu_bg.' gui=NONE'
  silent! execute 'highlight StPrefix guibg='.s:pmenu_bg.' guifg='.s:normal_fg.' gui=NONE'
  silent! execute 'highlight StPrefixSep guibg='.s:normal_bg.' guifg='.s:pmenu_bg.' gui=NONE'
  silent! execute 'highlight StMenu guibg='.s:pmenu_bg.' guifg='.s:normal_fg.' gui=bold'
  silent! execute 'highlight StMenuSep guibg='.s:normal_bg.' guifg='.s:pmenu_bg.' gui=NONE'
  silent! execute 'highlight StFilename guibg='.s:normal_bg.' guifg='.s:normal_fg.' gui=italic,bold'
  silent! execute 'highlight StFilenameInactive guifg='.s:comment_grey.' guibg='.s:normal_bg.' gui=italic,bold'
  silent! execute 'highlight StItemText guibg='.s:normal_bg.' guifg='.s:normal_fg.' gui=italic'
  silent! execute 'highlight StItem guibg='.s:normal_fg.' guifg='.s:normal_bg.' gui=italic'
  silent! execute 'highlight StSep guifg='.s:normal_fg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StInfo guifg='.s:dark_blue.' guibg='.s:normal_bg.' gui=bold'
  silent! execute 'highlight StInfoSep guifg='.s:pmenu_bg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StOk guifg='.s:normal_bg.' guibg='.s:dark_yellow.' gui=NONE'
  silent! execute 'highlight StOkSep guifg='.s:dark_yellow.' guibg=NONE gui=NONE'
  silent! execute 'highlight StInactive guifg='.s:normal_bg.' guibg='.s:comment_grey.' gui=NONE'
  silent! execute 'highlight StInactiveSep guifg='.s:comment_grey.' guibg=NONE gui=NONE'
  " setting a statusline fillchar that the character or a replacement
  " with ">" appears in inactive windows because the statusline is the same color
  " as the background see:
  " https://vi.stackexchange.com/questions/2381/hi-statusline-cterm-none-displays-whitespace-characters
  " https://vi.stackexchange.com/questions/15873/carets-in-status-line
  " So instead we set the inactive statusline to have an underline
  silent! execute 'highlight Statusline guifg=NONE guibg='.s:normal_bg.' gui=NONE cterm=NONE'
  silent! execute 'highlight StatuslineNC guifg=NONE guibg='.s:normal_bg.' gui=NONE cterm=NONE'
  " Diagnostic highlights
  silent! execute 'highlight StWarning guifg='.s:warning_fg.' guibg='.s:pmenu_bg.' gui=NONE'
  silent! execute 'highlight StWarningSep guifg='.s:pmenu_bg.' guibg='.s:normal_bg.' gui=NONE'
  silent! execute 'highlight StError guifg='.s:error_fg.' guibg='.s:pmenu_bg.' gui=NONE'
  silent! execute 'highlight StErrorSep guifg='.s:pmenu_bg.' guibg='.s:normal_bg.' gui=NONE'
endfunction

function! s:sep(item, ...) abort
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

function! s:sep_if(item, condition, ...) abort
  if !a:condition
    return ''
  endif
  let l:opts = get(a:, '1', {})
  return s:sep(a:item, l:opts)
endfunction

function! s:mode() abort
  let l:mode = mode()
  call s:mode_highlight(l:mode)

  let l:mode_map = {
        \ 'n'  : 'NORMAL',
        \ 'no' : 'N·OPERATOR PENDING ',
        \ 'v'  : 'VISUAL',
        \ 'V'  : 'V·LINE',
        \ '' : 'V·BLOCK',
        \ 's'  : 'SELECT',
        \ 'S'  : 'S·LINE',
        \ '^S' : 'S·BLOCK',
        \ 'i'  : 'INSERT',
        \ 'R'  : 'REPLACE',
        \ 'Rv' : 'V·REPLACE',
        \ 'c'  : 'COMMAND',
        \ 'cv' : 'VIM EX',
        \ 'ce' : 'EX',
        \ 'r'  : 'PROMPT',
        \ 'rm' : 'MORE',
        \ 'r?' : 'CONFIRM',
        \ '!'  : 'SHELL',
        \ 't'  : 'TERMINAL'
        \}
  return get(l:mode_map, l:mode, 'UNKNOWN')
endfunction

function! s:mode_highlight(mode) abort
  if a:mode ==? 'i'
    silent! exe 'highlight StModeText guifg='.s:dark_blue.' guibg=NONE gui=bold'
  elseif a:mode =~? '\(v\|V\|\)'
    silent! exe 'highlight StModeText guifg='.s:magenta.' guibg=NONE gui=bold'
  elseif a:mode ==? 'R'
    silent! exe 'highlight StModeText guifg='.s:dark_red.' guibg=NONE gui=build'
  elseif a:mode =~? '\(c\|cv\|ce\)'
    silent! exe 'highlight StModeText guifg='.s:inc_search_bg.' guibg=NONE gui=bold'
  else
    silent! exe 'highlight StModeText guifg='.s:green.' guibg=NONE gui=bold'
  endif
endfunction

" FIXME this functions should search through the
" array and only apply this command for windows in column formation
" Add underlines between stacked horizontal windows
function! s:add_separators()
  let [layout; rest] = winlayout()
  let gui = layout ==# 'col' ? "underline" : "NONE"
  silent! execute 'highlight Statusline gui='.gui
  silent! execute 'highlight StatuslineNC gui='.gui
endfunction

function s:hl(hl) abort
  return "%#".a:hl."#"
endfunction

func! s:item(component, hl, ...) abort
  if !strlen(a:component)
    return ''
  endif
  let opts = get(a:, '1', {})
  let before = get(opts, 'before', '')
  let after = get(opts, 'after', ' ')
  let prefix = get(opts, 'prefix', '')
  let prefix_color = get(opts, 'prefix_color', a:hl)
  return before . s:hl(prefix_color) . prefix .' '
        \ . s:hl(a:hl) . a:component . after . "%*"
endfunc

function s:item_if(item, condition, hl, ...) abort
  if !a:condition
    return ''
  endif
  return s:item(a:item, a:hl, get(a:, 1, {}))
endfunction

function! StatusLine(inactive) abort
  let available_space = winwidth(0)
  "---------------------------------------------------------------------------//
  " Modifiers
  "---------------------------------------------------------------------------//
  let plain = statusline#show_plain_statusline()

  let current_mode = s:mode()
  let file_type = '%{statusline#filetype()}'
  let line_info = s:line_info()
  let file_modified = statusline#modified('●')
  let minimal = plain || a:inactive

  "---------------------------------------------------------------------------//
  " Filename
  "---------------------------------------------------------------------------//
  " Evaluate the filename in the context of the statusline component
  " -> %{function_call()}, items in this context are per window not global
  " this means the function returns the containing windows filename
  " not the active one i.e. fixes the bug where the wrong filename shows in
  " inactive windows

  " The filename component should be 20% of the screen width but has a minimum
  " width of 10 since smaller than that is likely to be unintelligible
  " although if the window is plain i.e. terminal or tree buffer allow the file
  " name to take up more space
  let percentage = plain ? 0.4 : 0.2
  let minwid = 5
  " Don't set a minimum width for plain status line filenames
  let trunc_amount = float2nr(round(available_space * percentage))
  " highlight the filename component separately
  let filename_hl = minimal ? "StFilenameInactive" : "StFilename"
  let filename = '%#'.filename_hl.'#%{statusline#filename()}'
  let directory = '%{statusline#get_dir()}'
  let title_component = '%'.minwid.'.' .trunc_amount.'('.directory.filename.'%)'
  "---------------------------------------------------------------------------//
  " Mode
  "---------------------------------------------------------------------------//
  " show a minimal statusline with only the mode and file component
  if minimal
    return s:item(title_component, 'StInactiveSep', {'prefix': file_type, 'before': ' '})
  endif
  "---------------------------------------------------------------------------//
  " Setup
  "---------------------------------------------------------------------------//
  let statusline = ""
  let statusline .=  s:item(current_mode, 'StModeText', {'before': ''})

  let icon_highlight = statusline#filetype_icon_highlight('Normal')
  let statusline .= s:item(title_component, 'StItemText', {
        \ 'prefix': file_type,
        \ 'prefix_color': icon_highlight,
        \ 'after': '',
        \})

  let statusline .= s:sep_if(file_modified, strlen(file_modified), {
        \ 'small': 1,
        \ 'color': '%#StModified#',
        \ 'sep_color': '%#StPrefixSep#',
        \})

  " If local plugins are loaded and I'm developing locally show an indicator
  let develop_text = available_space > 100 ? 'local dev' : ''
  let statusline .= s:sep_if(
        \ develop_text,
        \ $DEVELOPING && available_space > 50,
        \ extend({
        \ 'prefix': " ",
        \ 'padding': 'none',
        \ 'prefix_color': '%#StWarning#',
        \ 'small': 1,
        \ }, s:st_warning))

  " Neovim allows unlimited alignment sections so we can put things in the
  " middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
  " let statusline .= '%='

  " Start of the right side layout
  let statusline .= '%='

  " Git Status
  let [prefix, git_status] = s:statusline_git_status()
  let statusline .= s:item(git_status, 'StInfo', {'prefix': prefix})

  " LSP Diagnostics
  let info = s:diagnostic_info()
  let statusline .= s:item(info.error, 'Error')
  let statusline .= s:item(info.warning, 'PreProc')
  let statusline .= s:item(info.information, 'String')

  " LSP Status
  let statusline .= s:item(StatuslineLanguageServer(), "Comment")
  let statusline .= s:item(StatuslineCurrentFunction(), "StMetadata")

  " Indentation
  let unexpected_indentation = &shiftwidth > 2 || !&expandtab
  let statusline .= s:item_if(
        \ &shiftwidth,
        \ unexpected_indentation,
        \ 'Title',
        \ {'prefix': &expandtab ? 'Ξ' : '⇥'})

  " Current line number/total line number,  alternatives 
  let statusline .= s:item_if(
        \ line_info,
        \ strlen(line_info),
        \ 'StMetadata',
        \ {'prefix': 'ℓ', 'prefix_color': 'StMetadataPrefix'})

  let statusline .= '%<'
  return statusline
endfunction

augroup custom_statusline
  autocmd!
  " The quickfix window sets it's own statusline, so we override it here
  autocmd FileType qf setlocal statusline=%!StatusLine(1)
  " FIXME this shouldn't be necessary technically but nvim-tree.lua does not
  " pick up the correct statusline otherwise
  autocmd FileType LuaTree setlocal statusline=%!StatusLine(1)

  autocmd BufEnter,WinEnter,FocusGained * setlocal statusline=%!StatusLine(0)
  autocmd BufLeave,WinLeave,FocusLost,QuickFixCmdPost * setlocal statusline=%!StatusLine(1)
  autocmd VimEnter,ColorScheme * call s:set_statusline_colors()
augroup END

" =====================================================================
" Resources:
" =====================================================================
" 1. https://gabri.me/blog/diy-vim-statusline
" 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
" 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" 4. Right sided truncation - https://stackoverflow.com/questions/20899651/how-to-truncate-a-vim-statusline-field-from-the-right
