" File: quickfix_preview.vim
" Author: Akin Sowemimo
" Description: A copy/paste/edit of ronakg/quickr-preview.vim
" Last Modified: October 11, 2020

" get_preview_window() {{
"
" This function will return the window ID of the preview window;
" if no preview window is currently open it will return zero.
"
function! s:get_preview_window()
  for l:winnr in range(1, winnr('$'))
    if getwinvar(l:winnr, '&previewwindow')
      return l:winnr
    endif
  endfor
  return 0
endfunction
" }}

function! s:open_preview_window(entry) abort
  let original_height = &previewheight
  let preview_height = get(b:, 'preview_height', original_height)
  execute 'set previewheight='.preview_height
  execute 'pedit +' . a:entry.lnum . ' ' . bufname(a:entry.bufnr)
  execute 'set previewheight='.original_height
endfunction

function! s:preview_matches(opts) abort
  let entry = a:opts.entry
  let is_listed = a:opts.buf_listed
  let preview_open = a:opts.preview_open

  if !preview_open
    silent call s:open_preview_window(entry)
  endif

  set eventignore+=all
  " Go to preview window
  keepjumps wincmd P

  " If the window was already opened and we have jumped to it
  " we should find the line in question
  if preview_open
    " Jump to the line of interest
    execute 'keepjumps '.entry.lnum.' | normal! zz'
  endif

  " Setting for unlisted buffers
  if !is_listed
    setlocal nobuflisted        " don't list this buffer
    setlocal noswapfile         " don't create swap file for this buffer
    setlocal bufhidden=delete   " clear out settings when buffer is hidden
  endif
  " Open any folds we may be in
  silent! foldopen!
  setlocal number
  " highlight the line
  execute 'match Search /\%'.entry.lnum.'l^\s*\zs.\{-}\ze\s*$/'
  " go back to the quickfix
  keepjumps wincmd p
  keepjumps wincmd J
  set eventignore-=all
endfunction

function quickfix_preview#view_file(lnum) abort
  " Close the preview window if the user has selected a same entry again
  let prev_lnum = get(b:, 'prev_lnum', 0)
  if a:lnum == prev_lnum
    pclose
    let b:prev_lnum = 0
    return
  endif
  let cur_list = getqflist()
  " get the qf entry for the current line which includes the line number
  " and the buffer number. Using those open the preview window to the specific
  " position
  let entry = get(cur_list, a:lnum - 1, {})
  if empty(entry) || !entry.lnum
    return
  endif
  let b:prev_lnum = a:lnum

  let already_open = s:get_preview_window() && entry.bufnr == b:prev_bufnum

  " Note if the buffer of interest is already listed
  let is_listed = buflisted(entry.bufnr)
  " Setting for unlisted buffers
  call s:preview_matches({
        \ 'entry': entry,
        \ 'preview_open': already_open,
        \ 'buf_listed': is_listed
        \ })

  let b:prev_bufnum = entry.bufnr
endfunction

function s:debounced_preview()
  if exists('b:qf_timer')
    unlet b:qf_timer
  endif
  call quickfix_preview#view_file(line('.'))
endfunction

function! quickfix_preview#open(lnum)
  if a:lnum != b:prev_lnum
    if exists('b:qf_timer')
      call timer_stop(b:qf_timer)
    endif
    let b:qf_timer = timer_start(300, {-> s:debounced_preview()})
  endif
endfunction

function! s:enter_quickfix() abort
  pclose!
  execute "normal! \<cr>"
endfunction

let s:enabled = 1

function quickfix_preview#toggle() abort
  if s:enabled
    let is_open = s:get_preview_window()
    if is_open
      pclose!
    endif
    let s:enabled = 0
  else
    call quickfix_preview#open(line('.'))
    let s:enabled = 1
  end
endfunction

func! quickfix_preview#setup(opts) abort
  let b:preview_height = a:opts.preview_height
  let b:prev_lnum = 0
  let b:prev_bufnum = 0

  nnoremap <buffer> <CR> :call <SID>enter_quickfix()<CR>

  augroup QFMove
    au! * <buffer>
    " Auto close preview window when closing/deleting the qf/loc list
    autocmd WinClosed <buffer> pclose
    " we create a nested autocommand to ensure that when we open the preview buffer
    " things like syntax highlighting and statuslines get set correctly
    autocmd CursorMoved <buffer> nested if s:enabled
          \ | call quickfix_preview#open(line('.'))
          \ | endif
  augroup END
endfunc
