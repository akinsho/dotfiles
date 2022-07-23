return function()
  local icons = as.style.icons
  local highlights = require('as.highlights')

  highlights.plugin('NeoTree', {
    NeoTreeIndentMarker = { link = 'Comment' },
    NeoTreeNormal = { link = 'PanelBackground' },
    NeoTreeNormalNC = { link = 'PanelBackground' },
    NeoTreeRootName = { bold = true, italic = true, foreground = 'LightMagenta' },
    NeoTreeCursorLine = { link = 'Visual' },
    NeoTreeStatusLine = { link = 'PanelSt' },
    NeoTreeTabBackground = { link = 'PanelDarkBackground' },
    NeoTreeTab = { bg = { from = 'PanelDarkBackground' }, fg = { from = 'Comment' } },
    NeoTreeSeparator = { link = 'PanelDarkBackground' },
    NeoTreeActiveTab = { bg = { from = 'PanelBackground' }, fg = 'fg', bold = true },
  })

  vim.g.neo_tree_remove_legacy_commands = 1

  as.nnoremap('<c-n>', '<Cmd>Neotree toggle reveal<CR>')

  require('neo-tree').setup({
    source_selector = {
      winbar = true,
      separator = ' ',
      highlight_tab = 'NeoTreeTab',
      highlight_tab_active = 'NeoTreeActiveTab',
      highlight_separator = 'NeoTreeSeparator',
      highlight_separator_active = 'NeoTreeSeparator',
      highlight_background = 'NeoTreeTabBackground',
    },
    enable_git_status = true,
    git_status_async = true,
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function() highlights.set_hl('Cursor', { blend = 100 }) end,
      },
      {
        event = 'neo_tree_buffer_leave',
        handler = function() highlights.set_hl('Cursor', { blend = 0 }) end,
      },
    },
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      use_libuv_file_watcher = true,
      group_empty_dirs = true,
      follow_current_file = false,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        never_show = {
          '.DS_Store',
        },
      },
    },
    default_component_configs = {
      icon = {
        folder_empty = '',
      },
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
        ['<CR>'] = 'open_with_window_picker',
        ['<c-s>'] = 'split_with_window_picker',
        ['<c-v>'] = 'vsplit_with_window_picker',
      },
    },
  })
end
