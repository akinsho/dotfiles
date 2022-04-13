return function()
  require('as.highlights').plugin('NeoTree', {
    NeoTreeIndentMarker = { link = 'Comment' },
    NeoTreeNormal = { link = 'PanelBackground' },
    NeoTreeNormalNC = { link = 'PanelBackground' },
    NeoTreeRootName = { bold = true, italic = true, foreground = 'LightMagenta' },
    NeoTreeCursorLine = { link = 'Visual' },
  })
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
          vim.cmd 'setlocal signcolumn=no'
          vim.cmd 'highlight! Cursor blend=100'
        end,
      },
      {
        event = 'neo_tree_buffer_leave',
        handler = function()
          vim.cmd 'highlight! Cursor blend=0'
        end,
      },
    },
    filesystem = {
      netrw_hijack_behavior = 'open_current',
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
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
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        o = 'toggle_node',
        ['<c-s>'] = 'open_split',
        ['<c-v>'] = 'open_vsplit',
      },
    },
  }
end
