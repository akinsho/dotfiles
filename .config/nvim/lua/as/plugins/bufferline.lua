return function()
  local fn = vim.fn
  local fmt = string.format

  local groups = require('bufferline.groups')

  require('bufferline').setup({
    highlights = function(opts)
      local hl = opts.highlights
      local visible = hl.buffer_visible.fg
      local selected = hl.buffer_selected.fg
      return {
        info = { undercurl = true, fg = hl.info.fg },
        info_selected = { undercurl = true, bold = true, italic = true, fg = selected },
        info_visible = { undercurl = true, fg = visible },
        warning = { undercurl = true, fg = hl.warning.fg },
        warning_selected = { undercurl = true, bold = true, italic = true, fg = selected },
        warning_visible = { undercurl = true, fg = visible },
        error = { undercurl = true, fg = hl.error.fg },
        error_selected = { undercurl = true, bold = true, italic = true, fg = selected },
        error_visible = { undercurl = true, fg = visible },
        hint = { undercurl = true, fg = hl.hint.fg },
        hint_selected = { undercurl = true, bold = true, italic = true, fg = selected },
        hint_visible = { undercurl = true, fg = visible },
      }
    end,
    options = {
      debug = {
        logging = true,
      },
      mode = 'buffers', -- tabs
      sort_by = 'insert_after_current',
      right_mouse_command = 'vert sbuffer %d',
      show_close_icon = false,
      show_buffer_close_icons = true,
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = false,
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = 'pr',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'dbui',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'undotree',
          text = 'Undotree',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'NvimTree',
          text = 'Explorer',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'neo-tree',
          text = '📁 EXPLORER',
          text_align = 'left',
          highlight = 'PanelDarkHeading',
        },
        {
          filetype = 'DiffviewFiles',
          text = 'Diff View',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'flutterToolsOutline',
          text = 'Flutter Outline',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'Outline',
          text = 'Symbols',
          highlight = 'PanelHeading',
        },
        {
          filetype = 'packer',
          text = 'Packer',
          highlight = 'PanelHeading',
        },
      },
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
        items = {
          groups.builtin.pinned:with({ icon = '' }),
          groups.builtin.ungrouped,
          {
            name = 'Dependencies',
            highlight = { fg = '#ECBE7B' },
            matcher = function(buf)
              return vim.startswith(buf.path, fmt('%s/site/pack/packer', fn.stdpath('data')))
                or vim.startswith(buf.path, fn.expand('$VIMRUNTIME'))
            end,
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
            matcher = function(buf) return buf.filename:match('%.sql$') end,
          },
          {
            name = 'tests',
            icon = '',
            matcher = function(buf)
              local name = buf.filename
              if name:match('%.sql$') == nil then return false end
              return name:match('_spec') or name:match('_test')
            end,
          },
          {
            name = 'docs',
            icon = '',
            matcher = function(buf)
              for _, ext in ipairs({ 'md', 'txt', 'org', 'norg', 'wiki' }) do
                if ext == fn.fnamemodify(buf.path, ':e') then return true end
              end
            end,
          },
        },
      },
    },
  })

  require('which-key').register({
    ['gD'] = { '<Cmd>BufferLinePickClose<CR>', 'bufferline: delete buffer' },
    ['gb'] = { '<Cmd>BufferLinePick<CR>', 'bufferline: pick buffer' },
    ['<leader><tab>'] = { '<Cmd>BufferLineCycleNext<CR>', 'bufferline: next' },
    ['<S-tab>'] = { '<Cmd>BufferLineCyclePrev<CR>', 'bufferline: prev' },
    ['[b'] = { '<Cmd>BufferLineMoveNext<CR>', 'bufferline: move next' },
    [']b'] = { '<Cmd>BufferLineMovePrev<CR>', 'bufferline: move prev' },
    ['<leader>1'] = { '<Cmd>BufferLineGoToBuffer 1<CR>', 'which_key_ignore' },
    ['<leader>2'] = { '<Cmd>BufferLineGoToBuffer 2<CR>', 'which_key_ignore' },
    ['<leader>3'] = { '<Cmd>BufferLineGoToBuffer 3<CR>', 'which_key_ignore' },
    ['<leader>4'] = { '<Cmd>BufferLineGoToBuffer 4<CR>', 'which_key_ignore' },
    ['<leader>5'] = { '<Cmd>BufferLineGoToBuffer 5<CR>', 'which_key_ignore' },
    ['<leader>6'] = { '<Cmd>BufferLineGoToBuffer 6<CR>', 'which_key_ignore' },
    ['<leader>7'] = { '<Cmd>BufferLineGoToBuffer 7<CR>', 'which_key_ignore' },
    ['<leader>8'] = { '<Cmd>BufferLineGoToBuffer 8<CR>', 'which_key_ignore' },
    ['<leader>9'] = { '<Cmd>BufferLineGoToBuffer 9<CR>', 'which_key_ignore' },
  })
end
