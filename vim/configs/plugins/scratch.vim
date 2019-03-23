if !has_key(g:plugs, 'scratch.vim')
  finish
endif

let g:scratch_no_mappings = 1
let g:scratch_horizontal = 0
let g:scratch_height = 50
nmap <leader>os <plug>(scratch-insert-reuse)
nmap <leader>oS <plug>(scratch-insert-clear)
