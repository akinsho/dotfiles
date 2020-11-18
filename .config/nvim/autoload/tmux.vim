function! tmux#statusline_colors() abort
  " Get the color of the current vim background and update tmux accordingly
  let bg_color = synIDattr(hlID('Normal'), 'bg')
  call jobstart('tmux set-option -g status-style bg=' . bg_color)
  " TODO: on vim leave we should set this back to what it was
endfunction

function! tmux#on_enter() abort
  let fname = expand("%:t")
  if strlen(fname)
    let session_file = strlen(v:this_session) ? v:this_session : 'Neovim'
    let session = fnamemodify(session_file, ':t')
    let [icon, hl] = utils#get_devicon(bufname())
    let color = synIDattr(hlID(hl), 'fg')
    let window_title = session . ' • ' . '#[fg='.color.']'.icon
    let cmd = printf("tmux rename-window '%s'", window_title)
    call jobstart(cmd)
  endif
endfunction

function! tmux#on_leave() abort
  call jobstart('tmux set-window-option automatic-rename on')
endfunction
