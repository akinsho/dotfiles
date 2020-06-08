if has_key(g:plugs, "lightline.vim")
  finish
endif

let s:ro_sym  = ''
let s:ma_sym  = "✗"
let s:mod_sym = "◇"
let s:ff_map  = { "unix": "␊", "mac": "␍", "dos": "␍␊" }

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
    let limit = get(a:, '1', 50)
    return '%.'.limit.'('.a:item.'%)'
endfunction

" Source: Coc documentation
function! s:status_diagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  let warning_sign = get(g:, 'coc_status_warning_sign', 'W')
  let error_sign = get(g:, 'coc_status_error_sign', 'E')

  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, error_sign . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, warning_sign . info['warning'])
  endif
  return join(msgs, ' ')
endfunction

" This checks if there are any errors if so the component
" is highlighted with the error highlight, if there are
" warnings it renders with a warning highlight. If neither
" there is no highlight
" TLDR: Error highlight > Warning highlight
function s:get_diagnostic_highlight() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return {} | endif
  if get(info, 'error', 0) | return s:st_error | endif
  if get(info, 'warning', 0) | return s:st_warning | endif
  return {}
endfunction

function StatuslineLanguageServer() abort
  return winwidth(0) > 100 ? s:truncate_string(get(g:, 'coc_status', '')) : ''
endfunction

function! StatuslineCurrentFunction() abort
  let current = get(b:, 'coc_current_function', '')
  let sanitized = s:sanitize_string(current)
  return winwidth(0) > 100 ? s:truncate_string(sanitized, 30) : ''
endfunction

" This is automatically truncated by coc
function! StatuslineGitStatus() abort
  let status = get(b:, "coc_git_status", "")
  return status
endfunction

" This is automatically truncated by coc
function StatuslineGitRepoStatus() abort
  let status = get(g:, "coc_git_status", "")
  return status
endfunction

" Find out current buffer's size and output it.
function! s:file_size()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

let s:st_mode = {'color': '%#StMode#', 'sep_color': '%#StModeSep#'}
let s:st_info = { 'color': '%#StInfo#', 'sep_color': '%#StInfoSep#' }
let s:st_ok =   { 'color': '%#StOk#', 'sep_color': '%#StOkSep#' }
let s:st_inactive = { 'color': '%#StInactive#', 'sep_color': '%#StInactiveSep#' }
let s:st_error = {'color': '%#StError#', 'sep_color': '%#StErrorSep#' }
let s:st_warning = {'color': '%#StWarning#', 'sep_color': '%#StWarningSep#' }
let s:st_menu = {'color': '%#StMenu#', 'sep_color': '%#StMenuSep#' }

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

function! s:set_statusline_colors() abort
  let s:normal_bg = synIDattr(hlID('Normal'), 'bg')
  let s:normal_fg = synIDattr(hlID('Normal'), 'fg')
  let s:pmenu_bg  = synIDattr(hlID('Pmenu'), 'bg')
  let s:string_fg = synIDattr(hlID('String'), 'fg')
  let s:error_fg =  synIDattr(hlID('ErrorMsg'), 'fg')
  " OneDark vim uses the same color for warning msg as error so I've overriden it
  let s:warning_fg = s:light_yellow "synIDattr(hlID('WarningMsg'), 'fg')

  silent! execute 'highlight StModified guifg='.s:string_fg.' guibg='.s:pmenu_bg.' gui=none'
  silent! execute 'highlight StPrefix guibg='.s:pmenu_bg.' guifg='.s:normal_fg.' gui=italic,bold'
  silent! execute 'highlight StPrefixSep guibg='.s:normal_bg.' guifg='.s:pmenu_bg.' gui=italic,bold'
  silent! execute 'highlight StMenu guibg='.s:pmenu_bg.' guifg='.s:normal_fg.' gui=italic,bold'
  silent! execute 'highlight StMenuSep guibg='.s:normal_bg.' guifg='.s:pmenu_bg.' gui=italic,bold'
  silent! execute 'highlight StItem guibg='.s:normal_fg.' guifg='.s:normal_bg.' gui=italic,bold'
  silent! execute 'highlight StSep guifg='.s:normal_fg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StInfo guifg='.s:normal_bg.' guibg='.s:dark_blue.' gui=NONE'
  silent! execute 'highlight StInfoSep guifg='.s:dark_blue.' guibg=NONE gui=NONE'
  silent! execute 'highlight StOk guifg='.s:normal_bg.' guibg='.s:dark_yellow.' gui=NONE'
  silent! execute 'highlight StOkSep guifg='.s:dark_yellow.' guibg=NONE gui=NONE'
  silent! execute 'highlight StInactive guifg='.s:normal_bg.' guibg='.s:comment_grey.' gui=NONE'
  silent! execute 'highlight StInactiveSep guifg='.s:comment_grey.' guibg=NONE gui=NONE'
  " setting a statsuline fillchar means this that the character or a replacement
  " with ">" appears in inactive windows because the statusline is the same color
  " as the background see:
  " https://vi.stackexchange.com/questions/2381/hi-statusline-cterm-none-displays-whitespace-characters
  " https://vi.stackexchange.com/questions/15873/carets-in-status-line
  "
  " So instead we set the inactive statusline to have an underline
  silent! execute 'highlight Statusline guifg=NONE guibg='.s:normal_bg.' gui=NONE cterm=NONE'
  silent! execute 'highlight StatuslineNC guifg=NONE guibg='.s:normal_bg.' gui=NONE cterm=NONE'
  " Diagnostic highlights
  silent! execute 'highlight StWarning guifg='.s:warning_fg.' guibg='.s:pmenu_bg.' gui=none'
  silent! execute 'highlight StWarningSep guifg='.s:pmenu_bg.' guibg='.s:normal_bg.' gui=none'
  silent! execute 'highlight StError guifg='.s:error_fg.' guibg='.s:pmenu_bg.' gui=none'
  silent! execute 'highlight StErrorSep guifg='.s:pmenu_bg.' guibg='.s:normal_bg.' gui=none'
endfunction

function! s:sep(item, ...) abort
  let opts = get(a:, '1', {})
  let before = get(opts, 'before', ' ')
  let prefix = get(opts, 'prefix', '')
  let small = get(opts, 'small', 0)
  let item_color = get(opts, 'color', '%#StItem#')
  let prefix_color = get(opts, 'prefix_color', '%#StPrefix#')
  let prefix_sep_color = get(opts, 'prefix_sep_color', '%#StPrefixSep#')

  let sep_color = get(opts, 'sep_color', '%#StSep#')
  let sep_color_left = strlen(prefix) ? l:prefix_sep_color : sep_color
  let prefix_item = prefix_color . prefix . " "

  " %* resets the highlighting at the end of the separator so it
  " doesn't interfere with the next component
  let sep_icon_right = small ? '%*' : '█%*'

  let sep_icon_left = strlen(prefix) ? ''. prefix_item : small ? '' : '█'

  let l:item = strlen(prefix) ? " " . a:item : a:item

  return before.
        \ sep_color_left.
        \ sep_icon_left.
        \ item_color.
        \ l:item.
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
    silent! exe 'highlight StMode guibg='.s:dark_blue.' guifg='.s:normal_bg.' gui=bold'
    silent! exe 'highlight StModeSep guifg='.s:dark_blue.' guibg=NONE gui=bold'
  elseif a:mode =~? '\(v\|V\|\)'
    silent! exe 'highlight StMode guibg='.s:magenta.' guifg='.s:normal_bg.' gui=bold'
    silent! exe 'highlight StModeSep guifg='.s:magenta.' guibg=NONE gui=bold'
  elseif a:mode ==? 'R'
    silent! exe 'highlight StMode guibg='.s:dark_red.' guifg='.s:normal_bg.' gui=bold'
    silent! exe 'highlight StModeSep guifg='.s:dark_red.' guibg=NONE gui=bold'
  elseif a:mode =~? '\(c\|cv\|ce\)'
    silent! exe 'highlight StMode guibg='.s:cyan.' guifg='.s:normal_bg.' gui=bold'
    silent! exe 'highlight StModeSep guifg='.s:cyan.' guibg=NONE gui=bold'
  else
    silent! exe 'highlight StMode guibg='.s:green.' guifg='.s:normal_bg.' gui=bold'
    silent! exe 'highlight StModeSep guifg='.s:green.' guibg=NONE gui=bold'
  endif
endfunction

" Add underlines between stacked horizontal windows
function! s:add_separators()
  let [layout; rest] = winlayout()
  let gui = layout ==# 'col' ? "underline" : "NONE"
  silent! execute 'highlight Statusline guifg=black gui='.gui
  silent! execute 'highlight StatuslineNC guifg=black gui='.gui
endfunction

function! StatusLine(...) abort
  let opts = get(a:, '1', {})
  call s:add_separators()
  ""---------------------------------------------------------------------------//
  " Modifiers
  ""---------------------------------------------------------------------------//
  let inactive = get(opts, 'inactive', 0)
  let plain = statusline#show_plain_statusline()

  let current_mode = s:mode()
  let file_type = statusline#filetype()
  let file_format = statusline#file_format()
  let line_info = s:line_info()
  let file_modified = statusline#modified('●')

  " Evaluate the filename in the context of the statusline component
  " -> %{func_call()}, items in this context are per window not global
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
  let truncation_amount = float2nr(round(winwidth(0) * percentage))
  let title_component = '%'.minwid.'.'.truncation_amount.'(%{statusline#filename("%:p:.")}%)'

  let s:info_item = {component -> "%#StInfoSep#".component}
  ""---------------------------------------------------------------------------//
  " Mode
  ""---------------------------------------------------------------------------//
  "show a minimal statusline with only the mode and file component
  if plain || inactive
    return s:sep(title_component, s:st_inactive)
  endif
  ""---------------------------------------------------------------------------//
  " Setup
  ""---------------------------------------------------------------------------//
  let statusline = ""
  let statusline .=  s:sep(current_mode, extend({'before': ''}, s:st_mode))
  " Truncate file path length at 40 characters
  let statusline .= s:sep(title_component, {'prefix': file_type})
  let statusline .= s:sep_if(file_modified, strlen(file_modified), {
        \ 'small': 1,
        \ 'color': '%#StModified#',
        \ 'sep_color': '%#StPrefixSep#',
        \ })

  " Neovim allows unlimited alignment sections so we can put things in the
  " middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
  let statusline .= '%='
  let statusline .= s:sep_if("%{StatuslineCurrentFunction()}",
        \ !empty(StatuslineCurrentFunction()), s:st_menu)

  " Start of the right side layout
  let statusline .= '%='
  " FIXME there is a bug causing this component to render with no highlight
  " and a zero value, so strlen must be > 0 but unclear why
  let diagnostic_info = s:status_diagnostic()
  let diagnostic_highlight = s:get_diagnostic_highlight()
  let statusline .= s:sep_if(diagnostic_info, strlen(diagnostic_info), diagnostic_highlight)

  let statusline .= " "
  let statusline .= "%#Type#%{StatuslineLanguageServer()}%*"
  let statusline .= " "
  let statusline .= s:info_item("%{StatuslineGitRepoStatus()}")
  let statusline .= s:info_item("%{StatuslineGitStatus()}")

  " spaces char ˽ or ⍽ / Tabs char - ⇥
  let unexpected_indentation = &shiftwidth > 2 || !&expandtab
  let l:statusline .= s:sep_if(&shiftwidth, unexpected_indentation,
        \ extend({ 'prefix': &expandtab ? 'Ξ' : '⇥', 'small': 1 }, {}))
  "Current line number/Total line numbers
  let statusline .= s:sep_if(line_info, strlen(line_info), extend({ 'prefix': '' }, s:st_mode))
  let statusline .= '%<'
  return statusline
endfunction

function MinimalStatusLine() abort
  return StatusLine({ 'inactive': 1 })
endfunction

augroup custom_statusline
  autocmd!
  "NOTE: %! expressions get populated globally.
  "That means all statuslines of all buffers get the expression
  "result of the buffer being active.
  autocmd BufEnter,WinEnter * setlocal statusline=%!StatusLine()
  autocmd BufLeave,WinLeave * setlocal statusline=%!MinimalStatusLine()
  autocmd VimEnter,ColorScheme * call <SID>set_statusline_colors()
augroup END


" =====================================================================
" Resources:
" =====================================================================
" 1. https://gabri.me/blog/diy-vim-statusline
" 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
" 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" 4. Right sided truncation - https://stackoverflow.com/questions/20899651/how-to-truncate-a-vim-statusline-field-from-the-right
