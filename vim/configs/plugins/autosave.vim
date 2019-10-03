""---------------------------------------------------------------------------//
" AutoSave {{{1
" ----------------------------------------------------------------------------
let s:preset = "💾 AutoSaved at " . strftime("%H:%M:%S")
let g:autosave_message =  "💾 Saving..."

function! s:unset_autosaved(in_throttle) abort
    let a:in_throttle = 0
    let b:autosaved_buffer = ""
endfunction

function s:debounced_autosave() abort
  let l:in_throttle = 0
  return { -> s:handle_autosave(l:in_throttle)}
endfunction

function! s:handle_autosave(in_throttle) abort
  if a:in_throttle
    finish
  endif

  if empty(&buftype) && !empty(bufname('')) && &modifiable == 1 && &readonly == 0 && &buftype != 'nofile'
    silent! update
    let b:autosaved_buffer = get(g:, 'autosave_message', s:preset)
    let a:in_throttle = 1
    call timer_start(800, { -> s:unset_autosaved(a:in_throttle) })
  endif
endfunction

augroup AutoSave
  autocmd!
  autocmd CursorHold,CursorHoldI <buffer> call s:debounced_autosave()
augroup END
