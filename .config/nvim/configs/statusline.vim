"--------------------------------------------------------------------------------
" Statusline
"--------------------------------------------------------------------------------

let s:st_warning  = {'color': '%#StWarning#', 'sep_color': '%#StWarningSep#' }

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
  let normal_bg      = synIDattr(hlID('Normal'), 'bg')
  let normal_fg      = synIDattr(hlID('Normal'), 'fg')
  let pmenu_bg       = synIDattr(hlID('Pmenu'), 'bg')
  let string_fg      = synIDattr(hlID('String'), 'fg')
  let error_fg       = synIDattr(hlID('ErrorMsg'), 'fg')
  let comment_fg     = synIDattr(hlID('Comment'), 'fg')
  let wildmenu_bg    = synIDattr(hlID('Wildmenu'), 'bg')
  let warning_fg     = g:colors_name =~ 'one' ?
        \ s:light_yellow : synIDattr(hlID('WarningMsg'), 'fg')

  " NOTE: Unicode characters including vim devicons should NOT be highlighted
  " as italic or bold, this is because the underlying bold font is not necessarily
  " patched with the nerd font characters
  " terminal emulators like kitty handle this by fetching nerd fonts elsewhere
  " but this is not universal across terminals so should be avoided
  silent! execute 'highlight StMetadata guifg='.comment_fg.' guibg=NONE gui=italic,bold'
  silent! execute 'highlight StMetadataPrefix guifg='.comment_fg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StModified guifg='.string_fg.' guibg='.pmenu_bg.' gui=NONE'
  silent! execute 'highlight StPrefix guibg='.pmenu_bg.' guifg='.normal_fg.' gui=NONE'
  silent! execute 'highlight StPrefixSep guibg='.normal_bg.' guifg='.pmenu_bg.' gui=NONE'
  silent! execute 'highlight StDirectory guibg='.normal_bg.' guifg=Gray gui=italic'
  silent! execute 'highlight StFilename guibg='.normal_bg.' guifg=LightGray gui=italic,bold'
  silent! execute 'highlight StFilenameInactive guifg='.s:comment_grey.' guibg='.normal_bg.' gui=italic,bold'
  silent! execute 'highlight StItem guibg='.normal_fg.' guifg='.normal_bg.' gui=italic'
  silent! execute 'highlight StSep guifg='.normal_fg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StInfo guifg='.s:dark_blue.' guibg='.normal_bg.' gui=bold'
  silent! execute 'highlight StInfoSep guifg='.pmenu_bg.' guibg=NONE gui=NONE'
  silent! execute 'highlight StInactive guifg='.normal_bg.' guibg='.s:comment_grey.' gui=NONE'
  silent! execute 'highlight StInactiveSep guifg='.s:comment_grey.' guibg=NONE gui=NONE'
  " setting a statusline fillchar that the character or a replacement
  " with ">" appears in inactive windows because the statusline is the same color
  " as the background see:
  " https://vi.stackexchange.com/questions/2381/hi-statusline-cterm-none-displays-whitespace-characters
  " https://vi.stackexchange.com/questions/15873/carets-in-status-line
  " So instead we set the inactive statusline to have an underline
  silent! execute 'highlight Statusline guifg=NONE guibg='.normal_bg.' gui=NONE cterm=NONE'
  silent! execute 'highlight StatuslineNC guifg=NONE guibg='.normal_bg.' gui=NONE cterm=NONE'
  " Diagnostic highlights
  silent! execute 'highlight StWarning guifg='.warning_fg.' guibg='.pmenu_bg.' gui=NONE'
  silent! execute 'highlight StWarningSep guifg='.pmenu_bg.' guibg='.normal_bg.' gui=NONE'
  silent! execute 'highlight StError guifg='.error_fg.' guibg='.pmenu_bg.' gui=NONE'
  silent! execute 'highlight StErrorSep guifg='.pmenu_bg.' guibg='.normal_bg.' gui=NONE'
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

function! StatusLine() abort
  " use the statusline global variable which is set inside of statusline
  " functions to the window for *that* statusline
  let curbuf = winbufnr(g:statusline_winid)

  " TODO reduce the available space whenever we add
  " a component so we can use it to determine what to add
  let available_space = winwidth(g:statusline_winid)

  let context = {
        \ 'bufnum': curbuf,
        \ 'winid': g:statusline_winid,
        \ 'preview': getwinvar(g:statusline_winid, '&previewwindow'),
        \ 'readonly': getbufvar(curbuf, '&readonly'),
        \ 'filetype': getbufvar(curbuf, '&ft'),
        \ 'buftype': getbufvar(curbuf, '&bt'),
        \ 'modified': getbufvar(curbuf, '&modified'),
        \ 'fileformat': getbufvar(curbuf, '&fileformat'),
        \ 'shiftwidth': getbufvar(curbuf, '&shiftwidth'),
        \ 'expandtab': getbufvar(curbuf, '&expandtab'),
        \}
  "---------------------------------------------------------------------------//
  " Modifiers
  "---------------------------------------------------------------------------//
  let plain = statusline#is_plain(context)

  let current_mode = s:mode()
  let line_info = statusline#line_info()
  let file_modified = statusline#modified(context, '●')
  let inactive = !has('nvim') ? 1 : nvim_get_current_win() != g:statusline_winid
  let focused = get(g: , 'vim_in_focus', 1)
  let minimal = plain || inactive || !focused

  "---------------------------------------------------------------------------//
  " Filename
  "---------------------------------------------------------------------------//
  " The filename component should be 20% of the screen width but has a minimum
  " width of 10 since smaller than that is likely to be unintelligible
  " although if the window is plain i.e. terminal or tree buffer allow the file
  " name to take up more space
  let percentage = plain ? 0.4 : 0.5
  let minwid = 5

  " Don't set a minimum width for plain status line filenames
  let trunc_amount = float2nr(round(available_space * percentage))

  " highlight the filename component separately
  let filename_hl = minimal ? "StFilenameInactive" : "StFilename"

  let [directory, filename] = statusline#filename(context)
  let [ft_icon, icon_highlight] = statusline#filetype(context)

  let filename = directory . '%#'.filename_hl.'#'. filename
  let title_component = '%'.minwid.'.' .trunc_amount.'('.filename.'%)'

  "---------------------------------------------------------------------------//
  " Mode
  "---------------------------------------------------------------------------//
  " show a minimal statusline with only the mode and file component
  if minimal
    return statusline#item(title_component, 'StInactiveSep', {'prefix': ft_icon, 'before': ' '})
  endif
  "---------------------------------------------------------------------------//
  " Setup
  "---------------------------------------------------------------------------//
  let statusline = ""
  let statusline .=  statusline#item(current_mode, 'StModeText', {'before': ''})

  let statusline .= statusline#item(title_component, 'StDirectory', {
        \ 'prefix': ft_icon,
        \ 'prefix_color': icon_highlight,
        \ 'after': '',
        \})

  let statusline .= statusline#sep_if(file_modified, strlen(file_modified), {
        \ 'small': 1,
        \ 'color': '%#StModified#',
        \ 'sep_color': '%#StPrefixSep#',
        \})

  " If local plugins are loaded and I'm developing locally show an indicator
  let develop_text = available_space > 100 ? 'local dev' : ''
  let statusline .= statusline#sep_if(
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
  let [prefix, git_status] = statusline#statusline_git_status()
  let statusline .= statusline#item(git_status, 'StInfo', {'prefix': prefix})

  " LSP Diagnostics
  let info = statusline#diagnostic_info()
  let statusline .= statusline#item(info.error, 'Error')
  let statusline .= statusline#item(info.warning, 'PreProc')
  let statusline .= statusline#item(info.information, 'String')

  " LSP Status
  let lsp_status = statusline#statusline_lsp_status()
  let current_fn = statusline#statusline_current_fn()

  let statusline .= statusline#item(lsp_status, "Comment")
  let statusline .= statusline#item(current_fn, "StMetadata")

  " Indentation
  let unexpected_indentation = context.shiftwidth > 2 || !context.expandtab
  let statusline .= statusline#item_if(
        \ context.shiftwidth,
        \ unexpected_indentation,
        \ 'Title',
        \ {'prefix': &expandtab ? 'Ξ' : '⇥', 'prefix_color': 'PmenuSbar'})

  " Current line number/total line number,  alternatives 
  let statusline .= statusline#item_if(
        \ line_info,
        \ strlen(line_info),
        \ 'StMetadata',
        \ {'prefix': 'ℓ', 'prefix_color': 'StMetadataPrefix'})

  let statusline .= '%<'
  return statusline
endfunction

augroup custom_statusline
  autocmd!
  autocmd FocusGained *  let g:vim_in_focus = 1
  autocmd FocusLost * let g:vim_in_focus = 0
  " The quickfix window sets it's own statusline, so we override it here
  autocmd FileType qf setlocal statusline=%!StatusLine()
  autocmd VimEnter,ColorScheme * call s:set_statusline_colors()
augroup END

set statusline=%!StatusLine()
" =====================================================================
" Resources:
" =====================================================================
" 1. https://gabri.me/blog/diy-vim-statusline
" 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
" 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" 4. Right sided truncation - https://stackoverflow.com/questions/20899651/how-to-truncate-a-vim-statusline-field-from-the-right
