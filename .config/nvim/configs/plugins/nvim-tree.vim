if !PluginLoaded("nvim-tree.lua")
  finish
endif

let g:lua_tree_icons = {
    \ 'default': '',
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "",
    \   'unmerged': "═",
    \   'renamed': "",
    \   'untracked': "★"
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': ""
    \   }
    \ }

nnoremap <silent><c-n> :LuaTreeToggle<CR>
let g:lua_tree_auto_close = 1 " 0 by default, closes the tree when it's the last window
let g:lua_tree_follow     = 1 " On bufEnter find the current file
let g:lua_tree_bindings = {
      \ "edit": "o",
      \}
let g:lua_tree_ignore = [ '.git', 'node_modules' ]
let g:lua_tree_size = &columns * 0.25 " Make lua tree proportional in size

augroup LuaTreeOverrides
  autocmd!
  autocmd FileType LuaTree setlocal nowrap
augroup END
