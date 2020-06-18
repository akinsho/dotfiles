if !has_key(plugs, 'nvim-colorizer.lua')
  finish
endif

augroup load_colorizer
  au!
  au CursorHold,CursorHoldI * ++once lua require('colorizer').setup{}
augroup END
