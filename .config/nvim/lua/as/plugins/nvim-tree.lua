return function()
  local action = require('nvim-tree.config').nvim_tree_callback

  vim.g.nvim_tree_icons = {
    default = '',
    git = {
      unstaged = '',
      staged = '',
      unmerged = '',
      renamed = '',
      untracked = '',
      deleted = '',
    },
  }
  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_width_allow_resize = 1
  vim.g.nvim_tree_root_folder_modifier = ':t'
  vim.g.nvim_tree_highlight_opened_files = 1

  require('as.highlights').plugin(
    'NvimTree',
    { 'NvimTreeIndentMarker', { link = 'Comment' } },
    { 'NvimTreeNormal', { link = 'PanelBackground' } },
    { 'NvimTreeNormalNC', { link = 'PanelBackground' } },
    { 'NvimTreeSignColumn', { link = 'PanelBackground' } },
    { 'NvimTreeEndOfBuffer', { link = 'PanelBackground' } },
    { 'NvimTreeVertSplit', { link = 'PanelVertSplit' } },
    { 'NvimTreeStatusLine', { link = 'PanelSt' } },
    { 'NvimTreeStatusLineNC', { link = 'PanelStNC' } },
    { 'NvimTreeRootFolder', { bold = true, italic = true, foreground = 'LightMagenta' } }
  )

  as.nnoremap('<c-n>', [[<cmd>NvimTreeToggle<CR>]])

  require('nvim-tree').setup {
    view = {
      width = '20%',
      auto_resize = true,
      list = {
        { key = 'cd', cb = action 'cd' },
      },
    },
    diagnostics = {
      enable = true,
    },
    disable_netrw = false,
    hijack_netrw = true,
    open_on_setup = false,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    filters = {
      custom = { '.DS_Store', 'fugitive:', '.git' },
    },
  }
end
