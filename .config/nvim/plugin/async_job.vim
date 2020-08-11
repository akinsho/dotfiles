"--------------------------------------------------------------------------------
" Async Job
" =========
"
" a simple plugin to execute async jobs using the jobstart API
"--------------------------------------------------------------------------------
let s:state = {
      \ "data": [''],
      \}

func! s:open_preview() abort
  let s:shell_tmp_output = tempname()
  execute 'pedit '.s:shell_tmp_output
  wincmd P
  wincmd J
  setlocal modifiable
  setlocal nobuflisted
  setlocal winfixheight
  setlocal nolist
  nnoremap <silent><nowait><buffer>q :bd<cr>
  nnoremap <silent><nowait><buffer><CR> :bd<cr>
endfunc

function! s:echo(msg) abort
  echohl String
  echom a:msg
  echohl clear
endfunction

func! s:process_data(shell, exit_code) abort
  " If the output is only 1 line and there was no error echo it
  if len(s:state.data) < 2 && !a:exit_code
    let str = join(s:state.data, "\n")
    call s:echo(str)
  else
    " open the preview window in a modifieable state
    call s:open_preview()
    " append each line to the modifiable preview buffer
    for item in s:state.data
      if len(item)
        call append(line('$'), item)
      endif
    endfor
    " resize the buffer to match the height of its content
    execute('resize ' . line('$'))
    " if there was a non zero exit code print that
    if a:exit_code
      call append(line('$'), 'Command "'.a:shell.'" exited with '.a:exit_code)
    endif
    normal! G
    setlocal nomodifiable
    " return to original window
    " wincmd p
  endif
endfunc

function! s:shell_cmd_completed(...) dict
  let exit_code = get(a:, '2', 0)
  call s:process_data(self.shell, exit_code)
  " terminate job
  call jobstop(self.pid)
  " reset data
  let s:state.data = ['']
endfunction

function! s:job_handler(job_id, data, event) dict
  let result = copy(a:data)
  call filter(result, 'len(v:val) > 0')
  " source: `:h on_exit`
  if len(result)
    let s:state.data[0] = self.shell .': '
    let s:state.data[-1] .= result[0]
    call extend(s:state.data, result[1:])
  endif
endfunction

function! Exec(cmd) abort
  let s:callbacks = {
        \ 'on_stdout': function('s:job_handler'),
        \ 'on_stderr': function('s:job_handler'),
        \ 'on_exit': function('s:shell_cmd_completed'),
        \ 'shell': a:cmd
        \ }
  let pid = jobstart(a:cmd, s:callbacks)
  let s:callbacks.pid = pid
endfunction

command! GitPush call Exec('git push')
command! GitPushF call Exec('git push -f')
