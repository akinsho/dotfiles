if !PluginLoaded('nvim-colorizer.lua')
  finish
endif

lua require('colorizer').setup{}
