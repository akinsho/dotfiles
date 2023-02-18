local r = vim.regex

local function flat_highlights(defaults)
  local visible_tab = { highlight = 'VisibleTab', attribute = 'bg' }

  local data, err = as.highlight.get('Normal')
  if as.empty(data) or err then return defaults.highlights end

  local normal_bg, normal_fg = data.background, data.foreground
  local visible = as.highlight.alter_color(normal_fg, -40)
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
end

local function config()
  local fn = vim.fn
  local icons = as.ui.icons.lsp

  local groups = require('bufferline.groups')

  require('bufferline').setup({
    highlights = flat_highlights,
    options = {
      debug = { logging = true },
      mode = 'buffers', -- tabs
      sort_by = 'insert_after_current',
      right_mouse_command = 'vert sbuffer %d',
      show_close_icon = false,
      show_buffer_close_icons = true,
      indicator = { style = 'underline' },
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level) return (icons[level] or '?') .. ' ' .. count end,
      diagnostics_update_in_insert = false,
      hover = { enabled = true, reveal = { 'close' } },
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
            matcher = function(buf) return vim.startswith(buf.path, vim.env.VIMRUNTIME) end,
          },
          {
            name = 'Terraform',
            matcher = function(buf) return buf.name:match('%.tf') ~= nil end,
          },
          {
            name = 'Kubernetes',
            matcher = function(buf)
              return buf.name:match('kubernetes') and buf.name:match('%.yaml')
            end,
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

  -- as.nnoremap('gD', '<Cmd>BufferLinePickClose<CR>', 'bufferline: delete buffer')
  map('n', '[b', '<Cmd>BufferLineMoveNext<CR>', { desc = 'bufferline: move next' })
  map('n', ']b', '<Cmd>BufferLineMovePrev<CR>', { desc = 'bufferline: move prev' })
  map('n', 'gb', '<Cmd>BufferLinePick<CR>', { desc = 'bufferline: pick buffer' })
  map('n', '<S-tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'bufferline: prev' })
  map('n', '<leader><tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'bufferline: next' })
  map('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>')
  map('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>')
  map('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>')
  map('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>')
  map('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>')
  map('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>')
  map('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>')
  map('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>')
  map('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>')
end

return {
  {
    'akinsho/bufferline.nvim',
    event = 'BufReadPre',
    config = config,
    dev = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
