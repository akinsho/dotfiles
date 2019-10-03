""---------------------------------------------------------------------------//
" AutoSave {{{1
" ----------------------------------------------------------------------------
let s:preset = "💾 AutoSaved at " . strftime("%H:%M:%S")
let g:autosave_message =  "💾 Saving..."

function! s:unset_autosaved() abort
    let b:autosaved_buffer = ""
endfunction

function! s:handle_autosave() abort
  if empty(&buftype) && !empty(bufname('')) && &modifiable == 1 && &readonly == 0 && &buftype != 'nofile'
    silent! update
    let b:autosaved_buffer = get(g:, 'autosave_message', s:preset)
    call timer_start(800, { -> s:unset_autosaved() })
  endif
endfunction

augroup AutoSave
  autocmd!
  autocmd CursorHold,CursorHoldI <buffer> call s:handle_autosave()
augroup END
