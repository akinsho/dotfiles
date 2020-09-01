if !PluginLoaded('calendar.vim')
  finish
endif

let g:calendar_frame = "unicode"

if filereadable(expand('~/.cache/calendar.vim/credentials.vim'))
  let g:calendar_google_calendar = 1
  let g:calendar_google_task     = 1
  let g:calendar_task            = 1
  let g:calendar_task_width      = 35
  source ~/.cache/calendar.vim/credentials.vim
endif
