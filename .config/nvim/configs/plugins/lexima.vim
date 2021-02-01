if !v:lua.plugin_loaded('lexima.vim')
  finish
endif

let g:lexima_accept_pum_with_enter = has('mac')
let g:lexima_enable_space_rules    = 0
