"--------------------------------------------------------------------------------
" Preloaded variables
"--------------------------------------------------------------------------------
" This file contains only variables that need to be set before plugins are initialised
"
let todoist = {
      \ 'key': $TODOIST_API_KEY,
      \ 'icons': {
      \   'unchecked': '  ',
      \   'checked':   '  ',
      \   'loading':   '  ',
      \   'error':     '  ',
      \  }
      \}


" without this option set before loading vim snippets it causes that plugin
" to make a synchronous system command which slows vim startup time
let g:snips_author = 'Akin Sowemimo'
let g:snips_email = ''
