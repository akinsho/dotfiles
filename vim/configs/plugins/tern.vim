let g:tern_request_timeout = 1
"Add extra filetypes
let g:tern#filetypes = [
      \ 'ts',
      \ 'tsx',
      \ 'typescript.tsx',
      \ 'typescript',
      \ 'javascript',
      \ 'jsx',
      \ 'javascript.jsx',
      \ ]
let g:tern_map_keys              = 0
let g:tern_show_argument_hints   = 'on_hold'
let g:tern_show_signature_in_pum = 1
let g:tern#command               = ["tern"]
let g:tern#arguments             = ["--persistent", "--no-port-file"]
