if !PluginLoaded("nvim-tree.lua")
  finish
endif

let g:lua_tree_icons = {
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "",
    \   'unmerged': "",
    \   'renamed': "",
    \   'untracked': ""
    \   },
    \ }

let g:lua_tree_bindings = {
      \ "edit": "o",
      \ "cd": "<bs>",
      \}

nnoremap <silent><c-n> :LuaTreeToggle<CR>

let g:lua_tree_indent_markers = 1
let g:lua_tree_git_hl = 1
let g:lua_tree_auto_close = 1 " closes the tree when it's the last window
let g:lua_tree_follow     = 1 " show selected file on open
let g:lua_tree_ignore = [ '.git', 'node_modules' ]
let g:lua_tree_size = &columns * 0.33 " Make lua tree proportional in size

let comment_fg = synIDattr(hlID('Comment'), 'fg')

execute 'highlight LuaTreeIndentMarker guifg=' . comment_fg

augroup LuaTreeOverrides
  autocmd!
  autocmd FileType LuaTree setlocal nowrap
  " FIXME this shouldn't be necessary technically but nvim-tree.lua does not
  " pick up the correct statusline otherwise
  autocmd FileType LuaTree setlocal statusline=%!MinimalStatusLine()
augroup END
