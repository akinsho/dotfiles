if !PluginLoaded('vim-visual-multi')
  finish
endif

let g:VM_maps                       = {}
let g:VM_highlight_matches          = 'underline'
let g:VM_theme                      = 'iceblue'
let g:VM_maps['Find Under']         = '<C-e'
let g:VM_maps['Find Subword Under'] = '<C-e>'
let g:VM_maps["Select Cursor Up"]   = '\k'
let g:VM_maps["Select Cursor Down"] = '\j'
