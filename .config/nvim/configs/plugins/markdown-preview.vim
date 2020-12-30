if !v:lua.plugin_loaded('markdown-preview.nvim')
  finish
endif
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
