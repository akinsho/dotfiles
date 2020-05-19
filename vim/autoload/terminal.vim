" CREDIT: https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23
" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.

let s:terminal_window = -1
let s:terminal_buffer = -1
let s:terminal_job_id = -1

function! terminal#open(...) abort
  let size = get(a:, '1', 10)
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves to the window the right the current one
    wincmd J
    execute "resize " . size
    let s:terminal_job_id = termopen($SHELL, { 'detach': 1 })

    " Change the name of the buffer to "Terminal 1"
    " FIXME this is erroring because the filename already exists
    silent file Terminal\ 1
    " Gets the id of the terminal window
    let s:terminal_window = win_getid()
    let s:terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
    lcd %:p:h
  else
    if !win_gotoid(s:terminal_window)
      sp
      " Moves to the window below the current one
      wincmd J
      execute "resize " . size
      buffer Terminal\ 1
      lcd %:p:h
      " Gets the id of the terminal window
      let s:terminal_window = win_getid()
    endif
  endif
endfunction

function! terminal#toggle(size) abort
  if win_gotoid(s:terminal_window)
    call terminal#close()
  else
    call terminal#open(a:size)
  endif
endfunction

function! terminal#close() abort
  if win_gotoid(s:terminal_window)
    " close the current window
    hide
  endif
endfunction

function! terminal#exec(cmd) abort
  if !win_gotoid(s:terminal_window)
    call terminal#open()
  endif

  " clear current input
  call jobsend(s:terminal_job_id, "clear\n")
  " FIXME change the directory of the terminal to that of the current buffer
  " call jobsend(s:terminal_job_id, "cd ".expand('%:p:h').'\n')

  " run cmd
  call jobsend(s:terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction
