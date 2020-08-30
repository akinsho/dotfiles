if !PluginLoaded("sideways.vim")
  finish
endif

nnoremap ]w :SidewaysLeft<cr>
nnoremap [w :SidewaysRight<cr>

nmap <silent><localleader>si <Plug>SidewaysArgumentInsertBefore
nmap <silent><localleader>sa <Plug>SidewaysArgumentAppendAfter
nmap <silent><localleader>sI <Plug>SidewaysArgumentInsertFirst
nmap <silent><localleader>sA <Plug>SidewaysArgumentAppendLast
