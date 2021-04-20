as.tree = {}

return function()
  vim.g.nvim_tree_icons = {
    default = "",
    git = {
      unstaged = "",
      staged = "",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted = ""
    }
  }

  as.nnoremap("<c-n>", [[<cmd>NvimTreeToggle<CR>]])

  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_lsp_diagnostics = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_auto_close = 0 -- closes the tree when it's the last window
  vim.g.nvim_tree_follow = 1 -- show selected file on open
  vim.g.nvim_tree_width = 30
  vim.g.nvim_tree_width_allow_resize = 1
  vim.g.nvim_tree_disable_netrw = 0
  vim.g.nvim_tree_hijack_netrw = 0
  vim.g.nvim_tree_root_folder_modifier = ":t"
  vim.g.nvim_tree_ignore = {".DS_Store", "fugitive:", ".git"}

  function as.tree.set_highlights()
    require("as.highlights").all {
      {"NvimTreeIndentMarker", {link = "Comment"}},
      {"NvimTreeNormal", {link = "ExplorerBackground"}},
      {"NvimTreeVertSplit", {link = "ExplorerVertSplit"}},
      {"NvimTreeStatusLine", {link = "ExplorerSt"}},
      {"NvimTreeStatusLineNC", {link = "ExplorerStNC"}},
      {"NvimTreeRootFolder", {gui = "bold,italic", guifg = "LightMagenta"}}
    }
  end

  as.augroup(
    "NvimTreeOverrides",
    {
      {
        events = {"ColorScheme"},
        targets = {"*"},
        command = "lua as.tree.set_highlights()"
      },
      {
        events = {"FileType"},
        targets = {"NvimTree"},
        command = "lua as.tree.set_highlights()"
      }
    }
  )
  -- This is required to allow lazy loading to work correctly.
  require("nvim-tree.events").on_nvim_tree_ready(
    function()
      vim.cmd("NvimTreeRefresh")
    end
  )
end
