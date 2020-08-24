if !PluginLoaded("nvim-tree.lua")
  finish
endif

let g:lua_tree_icons = {
    \ 'default': '',
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "",
    \   'unmerged': "",
    \   'renamed': "",
    \   'untracked': ""
    \   },
    \ }

let g:lua_tree_bindings = {
      \ "cd": ["<bs>", "cd"],
      \}

nnoremap <silent><c-n> :LuaTreeToggle<CR>

let g:lua_tree_indent_markers       = 1
let g:lua_tree_git_hl               = 1
let g:lua_tree_auto_close           = 0 " closes the tree when it's the last window
let g:lua_tree_follow               = 1 " show selected file on open
let g:lua_tree_width                 = 30
let g:lua_tree_root_folder_modifier = ':t'
let g:lua_tree_ignore               = [ '.DS_store', 'fugitive:' ]

highlight link LuaTreeIndentMarker Comment
highlight LuaTreeRootFolder gui=bold,italic

augroup LuaTreeOverrides
  autocmd!
  autocmd FileType LuaTree setlocal nowrap
  " FIXME this shouldn't be necessary technically but nvim-tree.lua does not
  " pick up the correct statusline otherwise
  autocmd FileType LuaTree setlocal statusline=%!MinimalStatusLine()
augroup END
