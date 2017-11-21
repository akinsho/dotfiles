if exists('g:gui_oni')
  finish
endif
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode' ], [ 'filename', 'filetype'] ],
      \   'right': [ [ 'fugitive', 'gitgutter' ], [ 'AleError', 'AleWarning', 'AleOk' ],
      \    ['lineinfo'], ['csv']
      \]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename',  'filesize' ] ],
      \   'right': [ [] ]
      \ },
      \ 'component': {
      \   'lineinfo': '%3l:%-2v',
      \   'tagbar': '%{tagbar#currenttag("%s", "")}',
      \   'close': '%999X X ',
      \ },
      \ 'component_function': {
      \   'filesize': 'LightLineFileSize',
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'csv':'LightLineCsv',
      \   'mode': 'LightLineMode',
      \   'gitgutter': 'LightLineGitGutter'
      \ },
      \ 'component_expand': {
      \   'AleError':   'LightlineAleError',
      \   'AleWarning': 'LightlineAleWarning',
      \   'AleOk':      'LightlineAleOk',
      \ },
      \ 'component_type': {
      \   'AleError':   'error',
      \   'AleWarning': 'warning',
      \   'AleOk':      'ok',
      \ },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
"FIXME: Lightline Bufferline
" let g:lightline#bufferline#modified  = ' @'
" let g:lightline.component_type   = {'buffers': 'tabsel'}
" let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
" let g:lightline.tabline = {
"       \ 'left': [ [ 'buffers' ] ],
"       \ 'right': [ [ 'close' ] ] }
" let g:lightline.tab = {
"       \ 'active': [ 'tabnum', 'filename', 'modified' ],
"       \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }
" 
" let g:lightline#bufferline#unicode_symbols = 1
" g:lightline#bufferline#show_number = 2


function! LightLineCsv()
  if has("statusline")
    hi User1 term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
    if exists("*CSV_WCol") && &ft =~ "csv"
      return CSV_WCol("Name") . " " . CSV_WCol()
    else
      return ""
    endif
  endif
endfunction

function! LightLineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added,
        \ g:gitgutter_sign_modified,
        \ g:gitgutter_sign_removed
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . ' ' . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

augroup LightLineOnALE
  autocmd!
  autocmd User ALELint call lightline#update()
augroup END

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '±' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? '' :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFileSize() "{{{
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return ""
  endif
  if bytes < 1024
    return  bytes . " b"
  else
    return  (bytes / 1024) . " kb"
  endif
endfunction "}}}

function! LightLineFiletype()
  if has('gui_running')
    return winwidth(0) > 70 ? (strlen(&filetype) ? &ft : '') : ''
  else
    return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : '') : ''
  endif
endfunction

function! LightLineFileFormat()
  if has('gui_running')
    return winwidth(0) > 70 ? (&fileformat . ' ') : ''
  else
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endif
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction

function! LightlineAleError() abort
  return LightlineAleString(0)
endfunction

function! LightlineAleWarning() abort
  return LightlineAleString(1)
endfunction

function! LightlineAleOk() abort
  let l:ok_string = LightlineAleString(2)
  let l:active_linters = strlen(&filetype) ? ale#linter#Get(&filetype) : []
  let l:has_linters = len(l:active_linters) > 0
  return l:has_linters ? l:ok_string : ''
endfunction

function! LightlineAleString(mode)
  if !exists('g:ale_buffer_info')
    return ''
  endif

  let l:buffer = bufnr('%')
  let l:counts = ale#statusline#Count(l:buffer)
  let [l:error_format, l:warning_format, l:no_errors] = g:ale_statusline_format

  if a:mode == 0 " Error
    let l:errors = l:counts.error + l:counts.style_error
    return l:errors ? printf(l:error_format, l:errors) : ''
  elseif a:mode == 1 " Warning
    let l:warnings = l:counts.warning + l:counts.style_warning
    return l:warnings ? printf(l:warning_format, l:warnings) : ''
  endif

  return l:counts.total == 0 ? '' : ''
endfunction

" Set the colorscheme. Modified from onedark.vim
if exists('g:lightline')

  " These are the colour codes that are used in the original onedark theme
  let s:gold         = ['#F5F478', 227]
  let s:black        = ['#282c34', 235]
  let s:white        = ['#abb2bf', 145]
  let s:light_red    = ['#e06c75', 204]
  let s:dark_red     = ['#be5046', 196]
  let s:green        = ['#98c379', 114]
  let s:light_yellow = ['#e5c07b', 180]
  let s:dark_yellow  = ['#d19a66', 173]
  let s:blue         = ['#61afef', 39]
  let s:dark_blue    = ['#4e88ff', 400]
  let s:magenta      = ['#c678dd', 170]
  let s:cyan         = ['#56b6c2', 38]
  let s:gutter_grey  = ['#636d83', 238]
  let s:comment_grey = ['#5c6370', 59]

  " TODO: Use Lightline bufferline -- needs configuring
  let s:bright_blue  = ['#A2E8F6', 58]
  let s:grey         = ['#5A5E68', 59]


  let s:p = {'normal':{}, 'inactive':{}, 'insert':{}, 'replace':{}, 'visual':{}, 'tabline':{}}

  let s:p.normal.left     = [ [ s:gold, s:black ], [ s:white, s:black ] ]
  let s:p.normal.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.normal.middle   = [ [ s:comment_grey, s:black ] ]


  let s:p.inactive.left   = [ [ s:comment_grey, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.inactive.right  = [ [ s:comment_grey, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.inactive.middle = [ [ s:comment_grey, s:black ] ]

  let s:p.insert.left     = [ [ s:green, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.insert.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.insert.middle   = [ [ s:comment_grey, s:black ] ]

  let s:p.replace.left     = [ [ s:light_red, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.replace.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.replace.middle   = [ [ s:comment_grey, s:black ] ]

  let s:p.visual.left     = [ [ s:magenta, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.visual.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.visual.middle   = [ [ s:comment_grey, s:black ] ]

  let s:p.tabline.left    = [ [ s:comment_grey, s:black ] ]
  let s:p.tabline.right   = [ [ s:gutter_grey, s:black ] ]
  let s:p.tabline.middle  = [ [ s:black, s:black ] ]
  let s:p.tabline.tabsel  = [ [ s:white, s:black ] ]

  let s:p.normal.error    = [ [ s:light_red, s:black ] ]
  let s:p.normal.warning  = [ [ s:light_yellow, s:black ] ]
  let s:p.normal.ok  = [ [ s:green, s:black ] ]


  let g:lightline#colorscheme#one#palette = lightline#colorscheme#flatten(s:p)
endif
