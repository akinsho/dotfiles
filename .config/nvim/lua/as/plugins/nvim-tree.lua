return function()
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

  as.nnoremap('<c-n>', [[<cmd>NvimTreeToggle<CR>]])

  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_lsp_diagnostics = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_group_empty = 1
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_auto_close = 0 -- closes the tree when it's the last window
  vim.g.nvim_tree_follow = 1 -- show selected file on open
  vim.g.nvim_tree_width = '20%'
  vim.g.nvim_tree_width_allow_resize = 1
  vim.g.nvim_tree_disable_netrw = 0
  vim.g.nvim_tree_hijack_netrw = 1
  vim.g.nvim_tree_root_folder_modifier = ':t'
  vim.g.nvim_tree_ignore = { '.DS_Store', 'fugitive:', '.git' }
  vim.g.nvim_tree_highlight_opened_files = 1
  vim.g.nvim_tree_auto_resize = 1

  local action = require('nvim-tree.config').nvim_tree_callback
  vim.g.nvim_tree_bindings = {
    { key = 'cd', cb = action 'cd' },
  }

  local function set_highlights()
    require('as.highlights').all {
      { 'NvimTreeIndentMarker', { link = 'Comment' } },
      { 'NvimTreeNormal', { link = 'PanelBackground' } },
      { 'NvimTreeEndOfBuffer', { link = 'PanelBackground' } },
      { 'NvimTreeVertSplit', { link = 'PanelVertSplit' } },
      { 'NvimTreeStatusLine', { link = 'PanelSt' } },
      { 'NvimTreeStatusLineNC', { link = 'PanelStNC' } },
      { 'NvimTreeRootFolder', { gui = 'bold,italic', guifg = 'LightMagenta' } },
    }
  end
  as.augroup('NvimTreeOverrides', {
    {
      events = { 'ColorScheme' },
      targets = { '*' },
      command = set_highlights,
    },
    {
      events = { 'FileType' },
      targets = { 'NvimTree' },
      command = set_highlights,
    },
  })
end
