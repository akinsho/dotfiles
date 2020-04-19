let g:mode_map = {
        \  'n': ['NORMAL',  'NormalMode' ],     'no': ['PENDING', 'NormalMode'  ],  'v': ['VISUAL',  'VisualMode' ],
        \  'V': ['V-LINE',  'VisualMode' ], "\<c-v>": ['V-BLOCK', 'VisualMode'  ],  's': ['SELECT',  'VisualMode' ],
        \  'S': ['S-LINE',  'VisualMode' ], "\<c-s>": ['S-BLOCK', 'VisualMode'  ],  'i': ['INSERT',  'InsertMode' ],
        \ 'ic': ['COMPLETE','InsertMode' ],     'ix': ['CTRL-X',  'InsertMode'  ],  'R': ['REPLACE', 'ReplaceMode'],
        \ 'Rc': ['COMPLETE','ReplaceMode'],     'Rv': ['REPLACE', 'ReplaceMode' ], 'Rx': ['CTRL-X',  'ReplaceMode'],
        \  'c': ['COMMAND', 'CommandMode'],     'cv': ['COMMAND', 'CommandMode' ], 'ce': ['COMMAND', 'CommandMode'],
        \  'r': ['PROMPT',  'CommandMode'],     'rm': ['-MORE-',  'CommandMode' ], 'r?': ['CONFIRM', 'CommandMode'],
        \  '!': ['SHELL',   'CommandMode'],      't': ['TERMINAL', 'CommandMode']}

  let g:ro_sym  = ''
  let g:ma_sym  = "✗"
  let g:mod_sym = "◇"
  let g:ff_map  = { "unix": "␊", "mac": "␍", "dos": "␍␊" }

" =====================================================================
" Resources: https://gabri.me/blog/diy-vim-statusline
" =====================================================================
function! s:lightline_fileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction


function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! CocGitStatus() abort
  let status = get(b:, "coc_git_status", "")
  return winwidth(0) > 120 ? status : ''
endfunction

function CocGitRepoStatus() abort
  return get(g:, "coc_git_status", "")
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

let s:st_err = {'color': '%#StErr#', 'sep_color': '%#StErrSep#'}
let s:st_warn = {'color': '%#StWarn#', 'sep_color': '%#StWarnSep#'}
let s:st_mode = {'color': '%#StMode#', 'sep_color': '%#StModeSep#'}
let s:st_info = { 'color': '%#StInfo#', 'sep_color': '%#StInfoSep#' }
let s:st_ok =   { 'color': '%#StOk#', 'sep_color': '%#StOkSep#' }

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
  let s:warning_fg = synIDattr(hlID('WarningMsg'), 'fg')
  let s:error_fg = synIDattr(hlID('ErrorMsg'), 'fg')

  silent! exe 'highlight StItem guibg='.s:normal_fg.' guifg='.s:normal_bg.' gui=NONE'
  silent! exe 'highlight StSep guifg='.s:normal_fg.' guibg=NONE gui=NONE'
  silent! exe 'highlight StErr guibg='.s:error_fg.' guifg='.s:normal_bg.' gui=bold'
  silent! exe 'highlight StErrSep guifg='.s:error_fg.' guibg=NONE gui=NONE'
  silent! exe 'highlight StWarn guibg='.s:warning_fg.' guifg='.s:normal_bg.' gui=bold'
  silent! exe 'highlight StWarnSep guifg='.s:warning_fg.' guibg=NONE gui=NONE'
  silent! exe 'highlight StInfo guifg='.s:normal_bg.' guibg='.s:dark_blue.' gui=NONE'
  silent! exe 'highlight StInfoSep guifg='.s:dark_blue.' guibg=NONE gui=NONE'
  silent! exe 'highlight StOk guifg='.s:normal_bg.' guibg='.s:green.' gui=NONE'
  silent! exe 'highlight StOkSep guifg='.s:green.' guibg=NONE gui=NONE'
  silent! exe 'highlight Statusline guifg=NONE guibg='.s:normal_bg.' gui=NONE cterm=NONE'
endfunction

function! s:sep(item, ...) abort
  let l:opts = get(a:, '1', {})
  let l:before = get(l:opts, 'before', ' ')
  let l:sep_color = get(l:opts, 'sep_color', '%#StSep#')
  let l:color = get(l:opts, 'color', '%#StItem#')

  return l:before.l:sep_color.'█'.l:color.a:item.l:sep_color.'█%*'
endfunction

function! s:sep_if(item, condition, ...) abort
  if !a:condition
    return ''
  endif
  let l:opts = get(a:, '1', {})
  return s:sep(a:item, l:opts)
endfunction

function! s:mode_statusline() abort
  let l:mode = mode()
  call s:mode_highlight(l:mode)

  let l:mode_map={
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
    hi StMode guibg=#83a598 guifg=#3c3836 gui=bold
    hi StModeSep guifg=#83a598 guibg=NONE
  elseif a:mode =~? '\(v\|V\|\)'
    hi StMode guibg=#fe8019 guifg=#3c3836 gui=bold
    hi StModeSep guifg=#fe8019 guibg=NONE
  elseif a:mode ==? 'R'
    hi StMode guibg=#8ec07c guifg=#3c3836 gui=bold
    hi StModeSep guifg=#8ec07c guibg=NONE
  else
    let type_fg = synIDattr(hlID('Type'), 'fg')
    silent! exe 'highlight StMode guibg='.type_fg.' guifg='.s:normal_bg.' gui=bold'
    silent! exe 'highlight StModeSep guifg='.type_fg.' guibg=NONE gui=bold'
  endif
endfunction

function! StatusLine() abort
  let current_mode = s:mode_statusline()
  let title = statusline#file_component()
  let plain =  statusline#show_plain_statusline()
  let file_format = statusline#file_format()


  let statusline = s:sep(current_mode, extend({'before': ''}, s:st_mode))
  let statusline .= s:sep(title, s:st_ok)

  if plain " render a minimal statusline with only the mode and file component
    return statusline
  endif

  let statusline .= " %#StInfoSep#%{CocGitRepoStatus()}"
  let statusline .= "%#StInfoSep#%{CocGitStatus()}"

  " Start of the right side layout
  let statusline .= '%='

  let statusline .= '%{coc#status()}'
  let statusline .= s:sep_if("%{CocCurrentFunction()}", !empty(CocCurrentFunction()), {})

  "Are spaces or tabs used for indentation and how much spaces is single indent
  " let statusline .= s:sep('%{&expandtab? "spaces" : "tabs"}: %{&sw}')

  "Current line number/Total line numbers
  let statusline .= s:sep(': %l/%L (%p%%)', s:st_mode)
  let statusline .= '%<'
  return statusline
endfunction

augroup custom_statusline
  autocmd!
  autocmd BufEnter,WinEnter * setlocal statusline=%!StatusLine()
  autocmd BufLeave,WinLeave * setlocal statusline=%f\ %y\ %m
  autocmd VimEnter,ColorScheme * call s:set_statusline_colors()
augroup END
