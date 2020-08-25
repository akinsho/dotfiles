if !PluginLoaded('vim-localvimrc')
  finish
endif
let g:localvimrc_persistent = 1
let g:localvimrc_name = [".lvimrc", ".vim/.lvimrc"]
