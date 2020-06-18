if !has_key(g:plugs, "sideways.vim")
  finish
endif

nnoremap ]w :SidewaysLeft<cr>
nnoremap [w :SidewaysRight<cr>
