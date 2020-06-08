" CREDIT: https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23
" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.

let s:terminal_window = -1
" FIXME this is can become invalid if this file is sourced as it will
" be reset to -1 so subsequent exec calls will fail
let s:terminal_job_id = -1
let s:terminal_name = 'terminal'
" Assuming this file is sourced then a file with this terminal name
" will still exist in vim causing the calle to file {name} to fail
" to work around this instead we assign the buffer ID to the result
" of searching for any buffer with a matching name
let s:terminal_buffer = bufnr(s:terminal_name)
let s:terminal_dir = getcwd()

function s:set_working_dir() abort
  let working_dir = getcwd()
  if s:terminal_dir !=# working_dir
    call chansend(s:terminal_job_id, "cd ". working_dir ."\n")
    call chansend(s:terminal_job_id, "clear\n")
    let s:terminal_dir = working_dir
  endif
endfunction

" Rather than call win_gotoid directly we call it with alt so
" we don't set the alternate-file to the terminal so it should
" be omitted when using b#,<C-^> to switch buffers
function! s:go_to_winid(win_id) abort
  keepalt call win_gotoid(a:win_id)
  return win_getid() == s:terminal_window ? 1 : 0
endfunction

function! terminal#open(...) abort
  let size = get(a:, '1', 10)
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:terminal_buffer)
    " Creates a window call monkey_terminal
    keepalt new monkey_terminal
    execute 'lcd '. getcwd()
    " Moves to the window the right the current one
    wincmd J
    execute "resize " . size
    setlocal winfixheight
    let s:terminal_job_id = termopen($SHELL, { 'detach': 1 })

    " Change the name of the buffer to the terminal name
    execute 'silent file '. s:terminal_name
    " Gets the id of the terminal window
    let s:terminal_window = win_getid()
    let s:terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !s:go_to_winid(s:terminal_window)
      sp
      " Moves to the window below the current one
      wincmd J
      execute "resize " . size
      setlocal winfixheight
      execute "keepalt buffer " . s:terminal_name
      call s:set_working_dir()
      " Gets the id of the terminal window
      let s:terminal_window = win_getid()
    endif
  endif
endfunction

function! terminal#toggle(size) abort
  if s:go_to_winid(s:terminal_window)
    call terminal#close()
  else
    call terminal#open(a:size)
  endif
endfunction

function! terminal#close() abort
  if s:go_to_winid(s:terminal_window)
    " close the current window
    hide
  endif
endfunction

function! terminal#exec(cmd, ...) abort
  " When we execute a command we want to see what is actually going
  " on so make the size bigger
  let size = get(a:, '1', 15)
  if !s:go_to_winid(s:terminal_window)
    call terminal#open(size)
  endif

  " clear current input
  call chansend(s:terminal_job_id, "clear\n")
  " run cmd
  call chansend(s:terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
  stopinsert!
endfunction

function s:check_last_window()
  if winnr('$') == 1 && winbufnr(0) == s:terminal_buffer
    " Reset the window id so there are no hanging
    " references to the terminal window
    let s:terminal_window = -1
    execute 'keepalt bnext'
  endif
endfunction

augroup AutocloseTerminal
  autocmd!
  au! BufEnter * call s:check_last_window()
augroup END
