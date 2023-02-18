local api = vim.api
local strwidth = api.nvim_strwidth
local highlight = as.highlight

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
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
      buftype_exclude = { 'terminal', 'nofile' },
      filetype_exclude = { -- TODO: should these filetypes be added to the UI Settings
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
    },
  },
  {
    'stevearc/dressing.nvim',
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
    end,
    config = function()
      highlight.plugin('dressing', { { FloatTitle = { inherit = 'Visual', bold = true } } })

      -- NOTE: the limit is half the max lines because this is the cursor theme so
      -- unless the cursor is at the top or bottom it realistically most often will
      -- only have half the screen available
      local function get_height(self, _, max_lines)
        local results = #self.finder.results
        local PADDING = 4 -- this represents the size of the telescope window
        local LIMIT = math.floor(max_lines / 2)
        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
      end

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
      map(
        'n',
        '<leader>nd',
        function() notify.dismiss({ silent = true, pending = true }) end,
        { desc = 'dismiss notifications' }
      )
    end,
  },
  {
    'levouh/tint.nvim',
    event = 'WinNew',
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
  {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, 'open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, 'close all folds' },
      { 'zP', function() require('ufo').peekFoldedLinesUnderCursor() end, 'preview fold' },
    },
    opts = {
      open_fold_hl_timeout = 0,
      preview = { win_config = { winhighlight = 'Normal:Normal,FloatBorder:Normal' } },
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virt_text, _, end_lnum, width, truncate, ctx)
        local result = {}
        local padding = ''
        local cur_width = 0
        local suffix_width = strwidth(ctx.text)
        local target_width = width - suffix_width

        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = strwidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = strwidth(chunk_text)
            if cur_width + chunk_width < target_width then
              padding = padding .. (' '):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end

        local end_text = ctx.get_fold_virt_text(end_lnum)
        -- reformat the end text to trim excess whitespace from
        -- indentation usually the first item is indentation
        if end_text[1] and end_text[1][1] then
          end_text[1][1] = end_text[1][1]:gsub('[%s\t]+', '')
        end

        table.insert(result, { ' ⋯ ', 'UfoFoldedEllipsis' })
        vim.list_extend(result, end_text)
        table.insert(result, { padding, '' })

        return result
      end,
      provider_selector = function(_, filetype)
        local ufo_ft_map = { dart = { 'lsp', 'treesitter' } }
        return ufo_ft_map[filetype] or { 'treesitter', 'indent' }
      end,
    },
  },
}
