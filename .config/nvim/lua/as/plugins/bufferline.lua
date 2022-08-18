return function()
  local fn = vim.fn
  local fmt = string.format

  local groups = require('bufferline.groups')
  local normal = require('as.highlights').get('Normal', 'bg')

  require('bufferline').setup({
    highlights = {
      -- offset_separator = { bg = hl.buffer.bg },
      tab = { bg = normal },
      fill = { bg = normal },
      pick = { bg = normal },
      buffer = { bg = normal },
      buffer_visible = { bg = normal, bold = true, italic = true },
      buffer_selected = { bg = normal },
      indicator_visible = { bg = normal },
      numbers_visible = { bg = normal },
      numbers_selected = { bg = normal },
      pick_selected = { bg = normal },
      pick_visible = { bg = normal },
      duplicate = { bg = normal },
      duplicate_visible = { bg = normal },
      duplicate_selected = { bg = normal },
      background = { bg = normal },
      tab_separator = { bg = normal, fg = normal },
      tab_separator_selected = { bg = normal, fg = normal },
      separator = { bg = normal, fg = normal },
      separator_visible = { bg = normal, fg = normal },
      separator_selected = { bg = normal, fg = normal },
      modified_selected = { bg = normal },
      close_button = { bg = normal },
      close_button_visible = { bg = normal },
      close_button_selected = { bg = normal },
      info = { bg = normal },
      info_visible = { bg = normal },
      info_selected = { bg = normal },
      warning = { bg = normal },
      warning_visible = { bg = normal },
      warning_selected = { bg = normal },
      error = { bg = normal },
      error_visible = { bg = normal },
      error_selected = { bg = normal },
      hint = { bg = normal },
      hint_visible = { bg = normal },
      hint_selected = { bg = normal },
    },
    options = {
      debug = { logging = true },
      mode = 'buffers', -- tabs
      sort_by = 'insert_after_current',
      right_mouse_command = 'vert sbuffer %d',
      show_close_icon = false,
      indicator = { style = 'underline' },
      show_buffer_close_icons = true,
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = false,
      diagnostics_update_in_insert = false,
      offsets = {
        {
          text = '📁 EXPLORER',
          filetype = 'neo-tree',
          highlight = 'PanelDarkHeading',
          text_align = 'left',
        },
        {
          text = ' FLUTTER OUTLINE',
          filetype = 'flutterToolsOutline',
          highlight = 'PanelHeading',
        },
        { text = 'UNDOTREE', filetype = 'undotree', highlight = 'PanelHeading' },
        { text = ' PACKER', filetype = 'packer', highlight = 'PanelHeading' },
        { text = ' DATABASE VIEWER', filetype = 'dbui', highlight = 'PanelHeading' },
        { text = ' DIFF VIEW', filetype = 'DiffviewFiles', highlight = 'PanelHeading' },
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
            icon = '',
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
