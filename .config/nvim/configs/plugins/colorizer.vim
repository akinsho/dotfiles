if !v:lua.plugin_loaded('nvim-colorizer.lua')
  finish
endif

lua require('colorizer').setup{}
