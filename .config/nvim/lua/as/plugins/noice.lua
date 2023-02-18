local border, highlight = as.ui.current.border, as.highlight

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = as.nightly(),
  version = '*',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    cmdline = {
      format = {
        cmdline = { title = '' },
        lua = { title = '' },
        search_down = { title = '' },
        search_up = { title = '' },
        filter = { title = '' },
        help = { title = '' },
        input = { title = '' },
        confirm = { title = '' },
        IncRename = { title = '' },
        substitute = { pattern = '^:%%?s/', icon = ' ', ft = 'regex', title = '' },
      },
    },
    lsp = {
      documentation = {
        opts = {
          border = { style = border },
          position = { row = 2 },
        },
      },
      signature = { enabled = false },
      hover = { enabled = true },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    views = {
      split = {
        win_options = {
          winhighlight = { Normal = 'Normal' },
        },
      },
      cmdline_popup = {
        position = { row = 5, col = '50%' },
        size = { width = 'auto', height = 'auto' },
        border = { style = border, padding = { 0, 1 } },
      },
      confirm = {
        border = { style = border, padding = { 0, 1 } },
      },
      popupmenu = {
        relative = 'editor',
        position = { row = 9, col = '50%' },
        size = { width = 60, height = 10 },
        border = { style = border, padding = { 0, 1 } },
        win_options = {
          winhighlight = { Normal = 'NormalFloat', FloatBorder = 'FloatBorder' },
        },
      },
    },
    routes = {
      {
        filter = { event = 'msg_show', kind = 'search_count' },
        opts = { skip = true },
      },
      {
        filter = { event = 'msg_show', kind = '', find = 'written' },
        opts = { skip = true },
      },
    },
    commands = {
      history = { view = 'vsplit' },
    },
    presets = {
      inc_rename = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
  config = function(_, opts)
    require('noice').setup(opts)

    highlight.plugin('noice', {
      { NoiceMini = { inherit = 'MsgArea', bg = { from = 'Normal' } } },
      { NoicePopupBaseGroup = { inherit = 'NormalFloat', fg = { from = 'DiagnosticSignInfo' } } },
      { NoicePopupWarnBaseGroup = { inherit = 'NormalFloat', fg = { from = 'Float' } } },
      { NoicePopupInfoBaseGroup = { inherit = 'NormalFloat', fg = { from = 'Conditional' } } },
      { NoiceCmdlinePopup = { bg = { from = 'NormalFloat' } } },
      { NoiceCmdlinePopupBorder = { link = 'FloatBorder' } },
      { NoiceCmdlinePopupBorderCmdline = { link = 'NoicePopupBaseGroup' } },
      { NoiceCmdlinePopupBorderSearch = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlinePopupBorderFilter = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlinePopupBorderHelp = { link = 'NoicePopupInfoBaseGroup' } },
      { NoiceCmdlinePopupBorderSubstitute = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlinePopupBorderIncRename = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlinePopupBorderInput = { link = 'NoicePopupBaseGroup' } },
      { NoiceCmdlinePopupBorderLua = { link = 'NoicePopupBaseGroup' } },
      { NoiceCmdlineIconCmdline = { link = 'NoicePopupBaseGroup' } },
      { NoiceCmdlineIconSearch = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlineIconFilter = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlineIconHelp = { link = 'NoicePopupInfoBaseGroup' } },
      { NoiceCmdlineIconIncRename = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlineIconSubstitute = { link = 'NoicePopupWarnBaseGroup' } },
      { NoiceCmdlineIconInput = { link = 'NoicePopupBaseGroup' } },
      { NoiceCmdlineIconLua = { link = 'NoicePopupBaseGroup' } },
      { NoiceConfirm = { bg = { from = 'NormalFloat' } } },
      { NoiceConfirmBorder = { link = 'NoicePopupBaseGroup' } },
    })

    map({ 'n', 'i', 's' }, '<c-f>', function()
      if not require('noice.lsp').scroll(4) then return '<c-f>' end
    end, { silent = true, expr = true })

    map({ 'n', 'i', 's' }, '<c-b>', function()
      if not require('noice.lsp').scroll(-4) then return '<c-b>' end
    end, { silent = true, expr = true })
  end,
}
