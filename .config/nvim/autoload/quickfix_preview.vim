" GetPreviewWindow() {{
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

function! s:preview_matches(opts) abort
  let entry = a:opts.entry
  let is_listed = a:opts.buf_listed
  let preview_open = a:opts.preview_open

  if !preview_open
    execute "pedit +" . entry.lnum . " " . bufname(entry.bufnr)
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
  " highlight the line
  execute 'match Search /\%'.entry.lnum.'l^\s*\zs.\{-}\ze\s*$/'
  " go back to the quickfix
  keepjumps wincmd p
  keepjumps wincmd J
  set eventignore-=all
endfunction

function quickfix_preview#view_file(lnum) abort
  " Close the preview window if the user has selected a same entry again
  if a:lnum == b:prev_lnum
    pclose
    let b:prev_lnum = 0
    return
  endif
  let cur_list = getqflist()
  " get the qf entry for the current line which includes the line number
  " and the buffer number. Using those open the preview window to the specific
  " position
  let entry = cur_list[a:lnum - 1]
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

function! quickfix_preview#open(lnum)
  if a:lnum != b:prev_lnum
    call quickfix_preview#view_file(a:lnum)
  endif
endfunction

func! quickfix_preview#setup() abort
  let b:prev_lnum = 0
  let b:prev_bufnum = 0

  augroup QFMove
    au! * <buffer>
    " Auto close preview window when closing/deleting the qf/loc list
    autocmd BufDelete,WinClosed <buffer> pclose
    " we create a nested autocommand to ensure that when we open the preview buffer
    " things like syntax highlighting and statuslines get set correctly
    autocmd CursorMoved <buffer> nested call quickfix_preview#open(line('.'))
  augroup END
endfunc
