if !has_key(g:plugs, "git-messenger.vim")
  finish
endif
nmap <Leader>cm <Plug>(git-messenger)
nmap <Leader>cM <Plug>(git-messenger-into-popup)

" Normal color. This color is the most important
highlight link gitmessengerPopupNormal Pmenu

let g:git_messenger_max_popup_height = 15
