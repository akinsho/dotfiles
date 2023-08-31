local fn, api = vim.fn, vim.api
local highlight = as.highlight
local icons = as.ui.icons
local autocmd = api.nvim_create_autocmd

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = { 'Neotree' },
    keys = { { '<C-N>', '<Cmd>Neotree toggle reveal<CR>', desc = 'NeoTree' } },
    init = function()
      autocmd('BufEnter', {
        desc = 'Load NeoTree if entering a directory',
        callback = function(args)
          if fn.isdirectory(api.nvim_buf_get_name(args.buf)) > 0 then
            require('lazy').load({ plugins = { 'neo-tree.nvim' } })
            api.nvim_del_autocmd(args.id)
          end
        end,
      })
    end,
    config = function()
      highlight.plugin('NeoTree', {
        theme = {
          ['*'] = {
            { NeoTreeNormal = { link = 'PanelBackground' } },
            { NeoTreeNormalNC = { link = 'PanelBackground' } },
            { NeoTreeCursorLine = { link = 'Visual' } },
            { NeoTreeRootName = { underline = true } },
            { NeoTreeStatusLine = { link = 'PanelSt' } },
            { NeoTreeTabActive = { bg = { from = 'PanelBackground' }, bold = true } },
            { NeoTreeTabInactive = { bg = { from = 'PanelDarkBackground', alter = 0.15 }, fg = { from = 'Comment' } } },
            { NeoTreeTabSeparatorActive = { inherit = 'PanelBackground', fg = { from = 'Comment' } } },
            -- stylua: ignore
            { NeoTreeTabSeparatorInactive = { inherit = 'NeoTreeTabInactive', fg = { from = 'PanelDarkBackground', attr = 'bg' } } },
          },
          -- NOTE: panel background colours don't get ignored by tint.nvim so avoid using them for now
          horizon = {
            { NeoTreeWinSeparator = { link = 'WinSeparator' } },
            { NeoTreeTabActive = { link = 'VisibleTab' } },
            { NeoTreeTabSeparatorActive = { link = 'VisibleTab' } },
            { NeoTreeTabInactive = { inherit = 'Comment', italic = false } },
            { NeoTreeTabSeparatorInactive = { bg = 'bg', fg = 'bg' } },
          },
        },
      })

      local symbols = require('lspkind').symbol_map
      local lsp_kinds = as.ui.lsp.highlights

      require('neo-tree').setup({
        sources = { 'filesystem', 'git_status', 'document_symbols' },
        source_selector = {
          winbar = true,
          separator_active = '',
          sources = {
            { source = 'filesystem' },
            { source = 'git_status' },
            { source = 'document_symbols' },
          },
        },
        enable_git_status = true,
        enable_normal_mode_for_inputs = true,
        git_status_async = true,
        nesting_rules = {
          ['dart'] = { 'freezed.dart', 'g.dart' },
        },
        event_handlers = {
          {
            event = 'neo_tree_buffer_enter',
            handler = function() highlight.set('Cursor', { blend = 100 }) end,
          },
          {
            event = 'neo_tree_popup_buffer_enter',
            handler = function() highlight.set('Cursor', { blend = 0 }) end,
          },
          {
            event = 'neo_tree_buffer_leave',
            handler = function() highlight.set('Cursor', { blend = 0 }) end,
          },
          {
            event = 'neo_tree_popup_buffer_leave',
            handler = function() highlight.set('Cursor', { blend = 100 }) end,
          },
          {
            event = 'neo_tree_window_after_close',
            handler = function() highlight.set('Cursor', { blend = 0 }) end,
          },
        },
        filesystem = {
          hijack_netrw_behavior = 'open_current',
          use_libuv_file_watcher = true,
          group_empty_dirs = false,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = { '.DS_Store' },
          },
          window = {
            mappings = {
              ['/'] = 'noop',
              ['g/'] = 'fuzzy_finder',
            },
          },
        },
        default_component_configs = {
          icon = { folder_empty = icons.documents.open_folder },
          name = { highlight_opened_files = true },
          document_symbols = {
            follow_cursor = true,
            kinds = as.fold(function(acc, v, k)
              acc[k] = { icon = v, hl = lsp_kinds[k] }
              return acc
            end, symbols),
          },
          modified = { symbol = icons.misc.circle .. ' ' },
          git_status = {
            symbols = {
              added = icons.git.add,
              deleted = icons.git.remove,
              modified = icons.git.mod,
              renamed = icons.git.rename,
              untracked = icons.git.untracked,
              ignored = icons.git.ignored,
              unstaged = icons.git.unstaged,
              staged = icons.git.staged,
              conflict = icons.git.conflict,
            },
          },
          file_size = {
            required_width = 50,
          },
        },
        window = {
          mappings = {
            ['o'] = 'toggle_node',
            ['<CR>'] = 'open_with_window_picker',
            ['<c-s>'] = 'split_with_window_picker',
            ['<c-v>'] = 'vsplit_with_window_picker',
            ['<esc>'] = 'revert_preview',
            ['P'] = { 'toggle_preview', config = { use_float = false } },
          },
        },
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        'ten3roberts/window-picker.nvim',
        name = 'window-picker',
        config = function()
          local picker = require('window-picker')
          picker.setup()
          picker.pick_window = function()
            return picker.select(
              { hl = 'WindowPicker', prompt = 'Pick window: ' },
              function(winid) return winid or nil end
            )
          end
        end,
      },
    },
  },
}
