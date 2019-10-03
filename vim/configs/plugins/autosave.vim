""---------------------------------------------------------------------------//
" AutoSave {{{1
" ----------------------------------------------------------------------------
let s:preset = "💾 AutoSaved at " . strftime("%H:%M:%S")
let g:autosave_message =  "💾 Saving..."
let g:autosave_debounce_time = 3000

function! s:unset_autosaved() abort
    let b:autosaved_buffer = ""
endfunction

function s:toggle_throttle(value) abort
  let b:in_throttle = a:value
endfunction

function! s:handle_autosave() abort
  if exists('b:in_throttle') && b:in_throttle
    return
  endif

  if empty(&buftype) && !empty(bufname('')) && &modifiable == 1 && &readonly == 0 && &buftype != 'nofile'
    silent! update
    let b:autosaved_buffer = get(g:, 'autosave_message', s:preset)
    let l:throttle_time = get(g:, 'autosave_debounce_time', 10000)
    let b:in_throttle = 1
    call timer_start(800, { -> s:unset_autosaved() })
    call timer_start(l:throttle_time, { -> s:toggle_throttle(0)})
  endif
endfunction

augroup AutoSave
  autocmd!
  autocmd CursorHold,CursorHoldI <buffer> call s:handle_autosave()
augroup END
