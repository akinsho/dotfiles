" CREDIT: https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23
" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.

let s:terminal_window = -1
" FIXME this is can become invalid if this file is sourced as it will
" be reset to -1 so subsequent exec calls will fail
let s:terminal_job_id = -1
let s:terminal_name = 'Terminal 1'
" Assuming this file is sourced then a file with this terminal name
" will still exist in vim causing the calle to file {name} to fail
" to work around this instead we assign the buffer ID to the result
" of searching for any buffer with a matching name
let s:terminal_buffer = bufnr(s:terminal_name)

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

    " Change the name of the buffer to the terminal name
    execute 'silent file '. s:terminal_name
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
      execute "buffer " . s:terminal_name
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
