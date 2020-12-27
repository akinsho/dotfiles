if !PluginLoaded("nvim-tree.lua")
  finish
endif

let g:nvim_tree_icons = {
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

let g:nvim_tree_bindings = {
      \ "cd": ["cd"],
      \}

nnoremap <silent><c-n> :NvimTreeToggle<CR>

let g:nvim_tree_indent_markers       = 1
let g:nvim_tree_git_hl               = 1
let g:nvim_tree_auto_close           = 0 " closes the tree when it's the last window
let g:nvim_tree_follow               = 1 " show selected file on open
let g:nvim_tree_width                = 30
let g:nvim_tree_width_allow_resize   = 1
let g:nvim_tree_root_folder_modifier = ':t'
let g:nvim_tree_ignore               = ['.DS_Store', 'fugitive:', '.git']

highlight link NvimTreeIndentMarker Comment
highlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta

augroup NvimTreeOverrides
  autocmd!
  autocmd ColorScheme * highlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta
augroup END
