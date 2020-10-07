if !PluginLoaded('minimap.vim')
  finish
endif

let g:minimap_auto_start = 0
let g:minimap_highlight  = 'PreProc'

augroup MinimapStart
  autocmd!
  autocmd SessionLoadPost * if exists(':Minimap') | Minimap | endif
augroup END
