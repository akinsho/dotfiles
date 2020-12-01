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
    \   'untracked': "",
    \   'deleted' : ""
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
let g:lua_tree_width                = 30
let g:lua_tree_width_allow_resize   = 1
let g:lua_tree_root_folder_modifier = ':t'
let g:lua_tree_ignore               = ['.DS_Store', 'fugitive:']

highlight link LuaTreeIndentMarker Comment

function! s:darken_explorer() abort
  let normal_bg = synIDattr(hlID('Normal'), 'bg')
  let bg_color = v:lua.require('bufferline').shade_color(normal_bg, -30)
  echomsg 'darkening to '.bg_color
  silent execute 'highlight ExplorerBackground guibg='.bg_color
  setlocal winhighlight=Normal:ExplorerBackground
endfunction

augroup LuaTreeOverrides
  autocmd!
  autocmd ColorScheme * highlight LuaTreeRootFolder gui=bold,italic
  autocmd BufEnter * if &ft == 'LuaTree' | call s:darken_explorer() | endif
augroup END
