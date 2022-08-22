return function()
  local fn = vim.fn
  local r = vim.regex
  local fmt = string.format
  local icons = as.style.icons.lsp

  local highlights = require('as.highlights')
  local groups = require('bufferline.groups')

  local visible_tab = { highlight = 'VisibleTab', attribute = 'bg' }

  require('bufferline').setup({
    highlights = function(defaults)
      local data = highlights.get('Normal')
      local normal_bg, normal_fg = data.background, data.foreground
      local visible = highlights.alter_color(normal_fg, -40)
      local diagnostic = r([[\(error_selected\|warning_selected\|info_selected\|hint_selected\)]])

      local hl = as.fold(function(accum, attrs, name)
        local formatted = name:lower()
        local is_group = formatted:match('group')
        local is_offset = formatted:match('offset')
        local is_separator = formatted:match('separator')
        if diagnostic:match_str(formatted) then attrs.fg = normal_fg end
        if not is_group or (is_group and is_separator) then attrs.bg = normal_bg end
        if not is_group and not is_offset and is_separator then attrs.fg = normal_bg end
        accum[name] = attrs
        return accum
      end, defaults.highlights)

      -- Make the visible buffers and selected tab more "visible"
      hl.buffer_visible.bold = true
      hl.buffer_visible.italic = true
      hl.buffer_visible.fg = visible
      hl.tab_selected.bold = true
      hl.tab_selected.bg = visible_tab
      hl.tab_separator_selected.bg = visible_tab
      return hl
    end,
    options = {
      debug = { logging = true },
      mode = 'buffers', -- tabs
      sort_by = 'insert_after_current',
      right_mouse_command = 'vert sbuffer %d',
      show_close_icon = false,
      indicator = { style = 'underline' },
      show_buffer_close_icons = true,
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level) return (icons[level] or '?') .. ' ' .. count end,
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
        options = { toggle_hidden_on_enter = true },
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
