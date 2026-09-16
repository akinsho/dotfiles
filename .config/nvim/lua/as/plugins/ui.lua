---@diagnostic disable: missing-fields
local api, fn = vim.api, vim.fn
local ui, augroup = as.ui, as.augroup
local icons = ui.icons.lsp

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'UIEnter',
    opts = {
      exclude = {
        -- stylua: ignore
        filetypes = {
          'dbout', 'neo-tree-popup', 'log', 'gitcommit',
          'txt', 'help', 'git', 'undotree', 'markdown',
        },
      },
      indent = {
        char = '│', -- ▏┆ ┊ 
        tab_char = '│',
      },
      scope = {
        char = '▎',
        highlight = vim.g.rainbow_delimiters.highlight,
      },
    },
    config = function(_, opts)
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = '#E06C75' })
        api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = '#E5C07B' })
        api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#61AFEF' })
        api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = '#D19A66' })
        api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#98C379' })
        api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#C678DD' })
        api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = '#56B6C2' })
      end)
      require('ibl').setup(opts)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end,
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({
        top_down = false,
        render = 'wrapped-compact',
        stages = 'fade_in_slide_out',
        on_open = function(win)
          if api.nvim_win_is_valid(win) then api.nvim_win_set_config(win, { border = 'single' }) end
        end,
      })
      map('n', '<leader>nd', function() notify.dismiss({ silent = true, pending = true }) end, {
        desc = 'dismiss notifications',
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    dev = true,
    event = 'UIEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local bufferline = require('bufferline')
      bufferline.setup({
        options = {
          debug = { logging = true },
          style_preset = { bufferline.style_preset.minimal },
          mode = 'buffers',
          sort_by = 'insert_after_current',
          move_wraps_at_ends = true,
          right_mouse_command = 'vert sbuffer %d',
          show_close_icon = false,
          show_buffer_close_icons = true,
          indicator = { style = 'underline' },
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level)
            level = level:match('warn') and 'warn' or level
            return (icons[level] or '?') .. ' ' .. count
          end,
          diagnostics_update_in_insert = false,
          hover = { enabled = true, reveal = { 'close' } },
          offsets = {
            {
              text = 'EXPLORER',
              filetype = 'neo-tree',
              highlight = 'PanelHeading',
              text_align = 'left',
              separator = false,
            },
            {
              text = 'UNDOTREE',
              filetype = 'undotree',
              highlight = 'PanelHeading',
              separator = false,
            },
            {
              text = ' DIFF VIEW',
              filetype = 'DiffviewFiles',
              highlight = 'PanelHeading',
              separator = false,
            },
          },
          groups = {
            options = { toggle_hidden_on_enter = true },
            items = {
              bufferline.groups.builtin.pinned:with({ icon = '' }),
              bufferline.groups.builtin.ungrouped,
              {
                name = 'Dependencies',
                icon = '',
                highlight = { fg = '#ECBE7B' },
                matcher = function(buf) return vim.startswith(buf.path, vim.env.VIMRUNTIME) end,
              },
              {
                name = 'Terraform',
                matcher = function(buf) return buf.name:match('%.tf') ~= nil end,
              },
              {
                name = 'Kubernetes',
                matcher = function(buf) return buf.name:match('kubernetes') and buf.name:match('%.yaml') end,
              },
              {
                name = 'SQL',
                matcher = function(buf) return buf.name:match('%.sql$') end,
              },
              {
                name = 'tests',
                icon = '',
                matcher = function(buf)
                  local name = buf.name
                  return name:match('[_%.]spec') or name:match('[_%.]test')
                end,
              },
              {
                name = 'docs',
                icon = '',
                matcher = function(buf)
                  if vim.bo[buf.id].filetype == 'man' or buf.path:match('man://') then return true end
                  for _, ext in ipairs({ 'md', 'txt', 'org', 'norg', 'wiki' }) do
                    if ext == fn.fnamemodify(buf.path, ':e') then return true end
                  end
                end,
              },
            },
          },
        },
      })

      -- Under the `gb` prefix rather than `[b`/`]b`, which are Neovim's own
      -- buffer navigation mappings.
      map('n', 'gb>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'bufferline: move buffer right' })
      map('n', 'gb<', '<Cmd>BufferLineMovePrev<CR>', { desc = 'bufferline: move buffer left' })
      map('n', 'gbb', '<Cmd>BufferLinePick<CR>', { desc = 'bufferline: pick buffer' })
      map('n', 'gbd', '<Cmd>BufferLinePickClose<CR>', { desc = 'bufferline: delete buffer' })
      map('n', '<S-tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'bufferline: prev' })
      map('n', '<leader><tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'bufferline: next' })
    end,
  },
}
