return function()
  local fn = vim.fn

  local function diagnostics_indicator(_, _, diagnostics)
    local symbols = { error = ' ', warning = ' ', info = ' ' }
    local result = {}
    for name, count in pairs(diagnostics) do
      if symbols[name] and count > 0 then
        table.insert(result, symbols[name] .. count)
      end
    end
    result = table.concat(result, ' ')
    return #result > 0 and result or ''
  end

  local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
      return vim.bo[b].filetype == 'log'
    end, buf_nums)
    if vim.tbl_isempty(logs) then
      return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr '$'
    local is_log = vim.bo[buf].filetype == 'log'
    if last_tab == 1 then
      return true
    end
    -- only show log buffers in secondary tabs
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
  end

  local function sort_by_mtime(a, b)
    local astat = vim.loop.fs_stat(a.path)
    local bstat = vim.loop.fs_stat(b.path)
    local mod_a = astat and astat.mtime.sec or 0
    local mod_b = bstat and bstat.mtime.sec or 0
    return mod_a > mod_b
  end

  local groups = require 'bufferline.groups'

  require('bufferline').setup {
    options = {
      mode = 'buffers', -- tabs
      sort_by = sort_by_mtime,
      right_mouse_command = 'vert sbuffer %d',
      show_close_icon = false,
      ---based on https://github.com/kovidgoyal/kitty/issues/957
      separator_style = os.getenv 'KITTY_WINDOW_ID' and 'slant' or 'padded_slant',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = diagnostics_indicator,
      diagnostics_update_in_insert = false,
      custom_filter = custom_filter,
      offsets = {
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
          groups.builtin.ungrouped,
          {
            highlight = { guisp = '#51AFEF', gui = 'underline' },
            name = 'tests',
            icon = '',
            matcher = function(buf)
              return buf.filename:match '_spec' or buf.filename:match 'test'
            end,
          },
          {
            name = 'view models',
            highlight = { guisp = '#03589C', gui = 'underline' },
            matcher = function(buf)
              return buf.filename:match 'view_model%.dart'
            end,
          },
          {
            name = 'screens',
            matcher = function(buf)
              return buf.path:match 'screen'
            end,
          },
          {
            highlight = { guisp = '#C678DD', gui = 'underline' },
            name = 'docs',
            matcher = function(buf)
              for _, ext in ipairs { 'md', 'txt', 'org', 'norg', 'wiki' } do
                if ext == fn.fnamemodify(buf.path, ':e') then
                  return true
                end
              end
            end,
          },
        },
      },
    },
  }

  require('which-key').register {
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
    ['<leader>9'] = { '<Cmd>BufferLineGoToBuffer 9<CR>', 'bufferline: goto 9' },
  }
end
