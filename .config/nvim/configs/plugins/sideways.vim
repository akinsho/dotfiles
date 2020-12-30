if !v:lua.plugin_loaded("sideways.vim")
  finish
endif

nnoremap ]w :SidewaysLeft<cr>
nnoremap [w :SidewaysRight<cr>

nmap <silent><localleader>si <Plug>SidewaysArgumentInsertBefore
nmap <silent><localleader>sa <Plug>SidewaysArgumentAppendAfter
nmap <silent><localleader>sI <Plug>SidewaysArgumentInsertFirst
nmap <silent><localleader>sA <Plug>SidewaysArgumentAppendLast

let g:sideways_add_item_cursor_restore = 1
