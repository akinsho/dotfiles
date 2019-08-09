""---------------------------------------------------------------------------//
" ECHODOC
""---------------------------------------------------------------------------//
if !has_key(g:plugs, 'echodoc.vim')
  finish
endif

let g:echodoc#enable_at_startup = 1

if has('nvim-0.3.2')
  " let g:echodoc#type='virtual'
  " Or, you could use neovim's floating text feature.
  let g:echodoc#enable_at_startup = 1
  let g:echodoc#type = 'floating'
  " To use a custom highlight for the float window,
  " change Pmenu to your highlight group
  " highlight link EchoDocFloat Pmenu
endif
