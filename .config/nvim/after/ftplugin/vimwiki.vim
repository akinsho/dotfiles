setlocal spell spelllang=en_gb
setlocal expandtab
setlocal shiftwidth=2
setlocal nowrap
setlocal softtabstop=2
setlocal colorcolumn=
setlocal concealcursor=
setlocal nonumber norelativenumber

highlight VimwikiDelText gui=strikethrough guifg=#5c6370 guibg=background
highlight link VimwikiCheckBoxDone VimwikiDelText

if PluginLoaded('vim-which-key')
  let g:which_leader_key_map.w.d  = 'delete current wiki file'
  let g:which_leader_key_map.w.h  = 'convert wiki to html'
  let g:which_leader_key_map.w.hh = 'convert wiki to html & open browser'
  let g:which_leader_key_map.w.r  = 'rename wiki file'
  let g:which_leader_key_map.w.n  = 'go to vim wiki page specified'
endif
