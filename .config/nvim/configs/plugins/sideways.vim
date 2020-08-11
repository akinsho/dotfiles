if !PluginLoaded("sideways.vim")
  finish
endif

nnoremap ]w :SidewaysLeft<cr>
nnoremap [w :SidewaysRight<cr>
