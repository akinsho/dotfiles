if !has_key(plugs, 'nvim-colorizer.lua') || exists('g:loaded_colorizer')
  finish
endif

lua require'colorizer'.setup()
