return function()
  vim.g.nvim_tree_icons = {
    default = '',
    git = {
      unstaged = "",
      staged = "",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted  = ""
    },
  }

  vim.g.nvim_tree_bindings = {
    cd = {"cd"},
  }

  as_utils.map("n", "<c-n>", [[<cmd>NvimTreeToggle<CR>]])

  vim.g.nvim_tree_indent_markers       = 1
  vim.g.nvim_tree_git_hl               = 1
  vim.g.nvim_tree_auto_close           = 0 -- closes the tree when it's the last window
  vim.g.nvim_tree_follow               = 1 -- show selected file on open
  vim.g.nvim_tree_width                = 30
  vim.g.nvim_tree_width_allow_resize   = 1
  vim.g.nvim_tree_root_folder_modifier = ':t'
  vim.g.nvim_tree_ignore               = {'.DS_Store', 'fugitive:', '.git'}

  vim.cmd [[highlight link NvimTreeIndentMarker Comment]]
  vim.cmd [[highlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta]]

  require('as.autocommands').create({
    NvimTreeOverrides = {
      {"ColorScheme", "*", "highlight NvimTreeRootFolder gui=bold,italic guifg=LightMagenta"}
    }
  })
end
