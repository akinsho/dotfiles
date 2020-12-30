if !v:lua.plugin_loaded('dsf.vim')
  finish
endif

let g:dsf_no_mappings = 1

nmap dsf <Plug>DsfDelete
nmap csf <Plug>DsfChange

nmap dsnf <Plug>DsfNextDelete
nmap csnf <Plug>DsfNextChange
