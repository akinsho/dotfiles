if !PluginLoaded('vim-visual-multi')
  finish
endif

let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-e>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-e>'
let g:VM_maps["Select Cursor Up"]   = '\k'
let g:VM_maps["Select Cursor Down"] = '\j'      " start selecting down
