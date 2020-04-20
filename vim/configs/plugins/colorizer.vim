if !has_key(plugs, 'nvim-colorizer.lua')
  finish
endif

lua require'colorizer'.setup()
