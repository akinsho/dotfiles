if !has_key(g:plugs, 'nvim-bufferline.lua')
  finish
endif

lua require'bufferline'.setup()
