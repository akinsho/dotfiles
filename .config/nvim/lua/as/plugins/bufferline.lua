return function()
  local fn = vim.fn
  local fmt = string.format

  local highlights = require('as.highlights')
  local groups = require('bufferline.groups')

  local data = highlights.get('Normal')
  local normal_bg, normal_fg = data.background, data.foreground
  local visible = highlights.alter_color(normal_fg, -40)
  local visible_tab = { highlight = 'VisibleTab', attribute = 'bg' }

  require('bufferline').setup({
    highlights = {
      offset_separator = { bg = normal_bg },
      group_separator = { bg = normal_bg },
      tab = { bg = normal_bg },
      fill = { bg = normal_bg },
      pick = { bg = normal_bg },
      buffer = { bg = normal_bg },
      buffer_visible = { bg = normal_bg, fg = visible, bold = true, italic = true },
      buffer_selected = { bg = normal_bg },
      indicator_visible = { bg = normal_bg },
      numbers_visible = { bg = normal_bg },
      numbers_selected = { bg = normal_bg },
      pick_selected = { bg = normal_bg },
      pick_visible = { bg = normal_bg },
      duplicate = { bg = normal_bg },
      duplicate_visible = { bg = normal_bg },
      duplicate_selected = { bg = normal_bg },
      background = { bg = normal_bg },
      tab_selected = { bg = visible_tab, bold = true },
      tab_separator = { bg = normal_bg, fg = normal_bg },
      tab_separator_selected = { bg = visible_tab, fg = normal_bg },
      separator = { bg = normal_bg, fg = normal_bg },
      separator_visible = { bg = normal_bg, fg = normal_bg },
      separator_selected = { bg = normal_bg, fg = normal_bg },
      modified_selected = { bg = normal_bg },
      close_button = { bg = normal_bg },
      close_button_visible = { bg = normal_bg },
      close_button_selected = { bg = normal_bg },
      info = { bg = normal_bg },
      info_visible = { bg = normal_bg },
      info_selected = { bg = normal_bg },
      warning = { bg = normal_bg },
      warning_visible = { bg = normal_bg },
      warning_selected = { bg = normal_bg },
      error = { bg = normal_bg },
      error_visible = { bg = normal_bg },
      error_selected = { bg = normal_bg },
      hint = { bg = normal_bg },
      hint_visible = { bg = normal_bg },
      hint_selected = { bg = normal_bg },
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
          text = 'EXPLORER',
          filetype = 'neo-tree',
          highlight = 'PanelHeading',
          text_align = 'left',
          separator = true,
        },
        {
          text = ' FLUTTER OUTLINE',
          filetype = 'flutterToolsOutline',
          highlight = 'PanelHeading',
          separator = true,
        },
        {
          text = 'UNDOTREE',
          filetype = 'undotree',
          highlight = 'PanelHeading',
          separator = true,
        },
        {
          text = ' PACKER',
          filetype = 'packer',
          highlight = 'PanelHeading',
          separator = true,
        },
        {
          text = ' DATABASE VIEWER',
          filetype = 'dbui',
          highlight = 'PanelHeading',
          separator = true,
        },
        {
          text = ' DIFF VIEW',
          filetype = 'DiffviewFiles',
          highlight = 'PanelHeading',
          separator = true,
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
