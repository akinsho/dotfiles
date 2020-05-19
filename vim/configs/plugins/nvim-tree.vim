if !has_key(g:plugs, "nvim-tree.lua")
  finish
endif

nnoremap <silent><c-n> :LuaTreeToggle<CR>
let g:lua_tree_auto_close = 1 " 0 by default, closes the tree when it's the last window
let g:lua_tree_follow     = 1 " On bufEnter find the current file
let g:lua_tree_bindings = {
      \ "edit": "o",
      \}
let g:lua_tree_ignore = [ '.git', 'node_modules' ]
