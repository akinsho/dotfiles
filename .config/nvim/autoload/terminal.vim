" CREDIT: https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23
" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.
"
" NOTE: We have to use Neovim's naming scheme for terminal buffers as otherwise these
" will not be correctly restored when loading a session
" When the terminal starts, the buffer contents are updated and the buffer is
" named in the form of `term://{cwd}//{pid}:{cmd}`. This naming scheme is used
" by |:mksession| to restore a terminal buffer (by restarting the {cmd}).
" SEE: help terminal-start

let s:default_size = 12
let s:terminal_window = -1
" FIXME this is can become invalid if this file is sourced as it will
" be reset to -1 so subsequent exec calls will fail
let s:terminal_job_id = -1
let s:terminal_buffer = -1
let s:terminal_dir = getcwd()

" If there is a matching buffer toggle the terminal
" this is primarily for restoring terminals from
" post loading a vim session
function terminal#restore_terminal() abort
  let s:terminal_buffer = bufnr('')
  let s:terminal_job_id = b:terminal_job_id
  let s:terminal_window = win_getid()
  execute "resize " . s:default_size
  setlocal winfixheight winfixwidth nobuflisted
  setfiletype toggleterm
endfunction

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

function s:check_for_existing_window() abort
  let is_terminal = getbufvar(s:terminal_buffer, "&buftype") ==? 'terminal'
  if bufexists(s:terminal_buffer) && !is_terminal
    execute 'bdelete! ' . s:terminal_buffer
    let s:terminal_buffer = -1
    let s:terminal_window = -1
  endif
endfunction

function! terminal#open(...) abort
  let size = get(a:, '1', s:default_size)
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:terminal_buffer)
    " Creates a window call monkey_terminal
    keepalt new monkey_terminal
    execute 'lcd '. getcwd()
    " Moves to the window the right the current one
    wincmd J
    execute "resize " . size
    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    setlocal winfixheight winfixwidth  nobuflisted
    " Namespace terminals opened via this functions so we can retrieve them later
    " inspired by: https://github.com/kassio/neoterm/commit/64e861a410749fd637ef75fe080a67a95cecb377
    let s:terminal_job_id = termopen($SHELL.';#toggleterm', { 'detach': 1 })
    " Set a unique filetype for these terminal so they can be targeted specifically
    setfiletype toggleterm

    " Gets the id of the terminal window
    let s:terminal_window = win_getid()
    let s:terminal_buffer = bufnr('%')
  else
    if !s:go_to_winid(s:terminal_window)
      sp
      " Moves to the window below the current one
      wincmd J
      execute "resize " . size
      setlocal winfixheight winfixwidth
      execute "keepalt buffer " . s:terminal_buffer
      call s:set_working_dir()
      " Gets the id of the terminal window
      let s:terminal_window = win_getid()
    endif
  endif
endfunction

function! terminal#toggle(size) abort
  " Check if there is a lingering buffer from a previous session
  call s:check_for_existing_window()
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
  " run command
  call chansend(s:terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
  stopinsert!
endfunction

function terminal#check_last_window()
  if winnr('$') == 1 && winbufnr(0) == s:terminal_buffer
    " Reset the window id so there are no hanging
    " references to the terminal window
    let s:terminal_window = -1
    execute 'keepalt bnext'
  endif
endfunction
