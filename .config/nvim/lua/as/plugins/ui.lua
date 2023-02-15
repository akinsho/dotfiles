local api = vim.api
local highlight = as.highlight

-- NOTE: the limit is half the max lines because this is the cursor theme so
-- unless the cursor is at the top or bottom it realistically most often will
-- only have half the screen available
local function get_height(self, _, max_lines)
  local results = #self.finder.results
  local PADDING = 4 -- this represents the size of the telescope window
  local LIMIT = math.floor(max_lines / 2)
  return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
end

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      highlight.plugin('indentline', {
        theme = {
          horizon = {
            { IndentBlanklineContextChar = { fg = { from = 'Directory' } } },
            { IndentBlanklineContextStart = { sp = { from = 'Directory', attr = 'fg' } } },
          },
        },
      })
    end,
    opts = {
      char = '│', -- ┆ ┊ 
      show_foldtext = false,
      context_char = '▎',
      char_priority = 12,
      show_current_context = true,
      show_current_context_start = true,
      show_current_context_start_on_current_line = false,
      show_first_indent_level = true,
      filetype_exclude = {
        'dbout',
        'neo-tree-popup',
        'dap-repl',
        'startify',
        'dashboard',
        'log',
        'fugitive',
        'gitcommit',
        'packer',
        'vimwiki',
        'markdown',
        'txt',
        'vista',
        'help',
        'NvimTree',
        'git',
        'TelescopePrompt',
        'undotree',
        'flutterToolsOutline',
        'norg',
        'org',
        'orgagenda',
        '', -- for all buffers without a file type
      },
      buftype_exclude = { 'terminal', 'nofile' },
    },
  },
  {
    'lukas-reineke/headlines.nvim',
    ft = { 'org', 'norg', 'markdown', 'yaml' },
    init = function()
      highlight.plugin('Headlines', {
        theme = {
          ['*'] = {
            { Headline1 = { background = '#003c30', foreground = 'White' } },
            { Headline2 = { background = '#00441b', foreground = 'White' } },
            { Headline3 = { background = '#084081', foreground = 'White' } },
            { Dash = { background = '#0b60a1', bold = true } },
          },
          ['horizon'] = {
            { Headline = { background = { from = 'Normal', alter = 20 } } },
          },
        },
      })
    end,
    opts = {
      markdown = {
        headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
      },
      org = { headline_highlights = false },
      norg = {
        headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
        codeblock_highlight = false,
      },
    },
  },
  {
    'stevearc/dressing.nvim',
    init = function()
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
    config = function()
      highlight.plugin('dressing', { { FloatTitle = { inherit = 'Visual', bold = true } } })
      require('dressing').setup({
        input = {
          insert_only = false,
          border = as.ui.current.border,
          win_options = {
            winblend = 2,
          },
        },
        select = {
          get_config = function(opts)
            -- center the picker for treesitter prompts
            if opts.kind == 'codeaction' then
              return {
                backend = 'telescope',
                telescope = require('telescope.themes').get_cursor({
                  layout_config = { height = get_height },
                }),
              }
            end
          end,
          telescope = require('telescope.themes').get_dropdown({
            layout_config = { height = get_height },
          }),
        },
      })
    end,
  },
  {
    'rcarriga/nvim-notify',
    init = function()
      highlight.plugin('notify', {
        { NotifyERRORBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyWARNBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyINFOBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyDEBUGBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyTRACEBorder = { bg = { from = 'NormalFloat' } } },
        { NotifyERRORBody = { link = 'NormalFloat' } },
        { NotifyWARNBody = { link = 'NormalFloat' } },
        { NotifyINFOBody = { link = 'NormalFloat' } },
        { NotifyDEBUGBody = { link = 'NormalFloat' } },
        { NotifyTRACEBody = { link = 'NormalFloat' } },
      })

      local notify = require('notify')

      notify.setup({
        timeout = 3000,
        stages = 'fade_in_slide_out',
        top_down = false,
        background_colour = 'NormalFloat',
        max_width = function() return math.floor(vim.o.columns * 0.4) end,
        max_height = function() return math.floor(vim.o.lines * 0.8) end,
        on_open = function(win)
          if api.nvim_win_is_valid(win) then
            api.nvim_win_set_config(win, { border = as.ui.current.border })
          end
        end,
        render = function(...)
          local notif = select(2, ...)
          local style = notif.title[1] == '' and 'minimal' or 'default'
          require('notify.render')[style](...)
        end,
      })
      vim.notify = notify
      as.nnoremap(
        '<leader>nd',
        function() notify.dismiss({ silent = true, pending = true }) end,
        { desc = 'dismiss notifications' }
      )
    end,
  },
  {
    'levouh/tint.nvim',
    event = 'VeryLazy',
    config = function()
      require('tint').setup({
        tint = -30,
        highlight_ignore_patterns = {
          'WinSeparator',
          'St.*',
          'Comment',
          'Panel.*',
          'Telescope.*',
          'Bqf.*',
        },
        window_ignore_function = function(win_id)
          if vim.wo[win_id].diff or vim.fn.win_gettype(win_id) ~= '' then return true end
          local buf = vim.api.nvim_win_get_buf(win_id)
          local b = vim.bo[buf]
          local ignore_bt = { 'terminal', 'prompt', 'nofile' }
          local ignore_ft = {
            'neo-tree',
            'packer',
            'diff',
            'toggleterm',
            'Neogit.*',
            'Telescope.*',
            'qf',
          }
          return as.any(b.bt, ignore_bt) or as.any(b.ft, ignore_ft)
        end,
      })
    end,
  },
}
