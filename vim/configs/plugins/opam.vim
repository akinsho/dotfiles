if executable('opam') && &ft ==# 'ocaml'
  let g:opamshare = substitute(system('opam config var share'), '\n$', '', '''')
  execute "set rtp+=" . g:opamshare . "/merlin/vim"
  " To generate help tags run
  " execute "helptags " . g:opamshare . "/merlin/vim/doc"
endif
