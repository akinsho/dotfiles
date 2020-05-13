let s:normal_fg = synIDattr(hlID('Normal'), 'fg')
let s:normal_bg = synIDattr(hlID('Normal'), 'bg')
let s:comment_fg = synIDattr(hlID('Comment'), 'fg')
let s:tabline_sel_bg = synIDattr(hlID('TabLineSel'), 'bg')

let g:bufferline_tab = { "guifg": s:comment_fg, "guibg": s:normal_bg }
let g:bufferline_tab_selected = { "guifg": s:comment_fg, "guibg": s:tabline_sel_bg }
let g:bufferline_buffer = { "guifg": s:comment_fg, "guibg": "#1b1e24" }
let g:bufferline_buffer_inactive = { "guifg": s:comment_fg, "guibg": s:normal_bg }
let g:bufferline_background = { "guibg": "#1b1e24" }
let g:bufferline_separator = {"guibg": "#191c22"}
let g:bufferline_selected = { "guifg": s:normal_fg, "guibg": s:normal_bg, "gui": "bold,italic" }
