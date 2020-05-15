if !has_key(g:plugs, 'nvim-bufferline')
  finish
endif

lua require'bufferline'.setup()
