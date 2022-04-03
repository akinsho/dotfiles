return function()
  require('as.highlights').plugin(
    'NeoTree',
    { 'NeoTreeIndentMarker', { link = 'Comment' } },
    { 'NeoTreeNormal', { link = 'PanelBackground' } },
    { 'NeoTreeNormalNC', { link = 'PanelBackground' } },
    { 'NeoTreeRootName', { bold = true, italic = true, foreground = 'LightMagenta' } }
  )
  vim.g.neo_tree_remove_legacy_commands = 1
  local icons = as.style.icons
  as.nnoremap('<c-n>', '<Cmd>Neotree toggle reveal<CR>')
  require('neo-tree').setup {
    enable_git_status = true,
    git_status_async = true,
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.wo.signcolumn = 'no'
        end,
      },
    },
    filesystem = {
      netrw_hijack_behavior = 'open_current',
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = icons.git.add,
          deleted = icons.git.remove,
          modified = icons.git.mod,
          renamed = icons.git.rename,
          untracked = '',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
    window = {
      mappings = {
        o = 'toggle_node',
      },
    },
  }
end
