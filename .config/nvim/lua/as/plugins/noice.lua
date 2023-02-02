return function()
  require('noice').setup({
    cmdline = {
      format = {
        cmdline = { title = '' },
        lua = { title = '' },
        -- search_down = { title = '' },
        -- search_up = { title = '' },
        -- filter = { title = '' },
        -- help = { title = '' },
      },
    },
    lsp = {
      signature = {
        enabled = false,
      },
      hover = {
        enabled = false,
      },
    },
    views = {
      split = {
        win_options = {
          winhighlight = { Normal = 'Normal' },
        },
      },
      cmdline_popup = {
        position = {
          row = 5,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
        border = {
          style = as.style.current.border,
          padding = { 0, 1 },
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 9,
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = as.style.current.border,
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = 'NormalFloat',
            FloatBorder = 'FloatBorder',
          },
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
    presets = {
      inc_rename = true,
      long_message_to_split = true,
    },
  })

  require('as.highlights').plugin('noice', {
    {
      NoicePopupBaseGroup = {
        bg = { from = 'NormalFloat' },
        fg = { from = 'DiagnosticSignInfo' },
      },
    },
    {
      NoicePopupWarnBaseGroup = {
        bg = { from = 'NormalFloat' },
        fg = { from = 'Float' },
      },
    },
    {
      NoicePopupInfoBaseGroup = {
        bg = { from = 'NormalFloat' },
        fg = { from = 'Conditional' },
      },
    },
    { NoiceCmdlinePopup = { bg = { from = 'NormalFloat' } } },
    { NoiceCmdlinePopupBorder = { link = 'FloatBorder' } },
    { NoiceCmdlinePopupBorderCmdline = { link = 'NoicePopupBaseGroup' } },
    { NoiceCmdlinePopupBorderSearch = { link = 'NoicePopupWarnBaseGroup' } },
    { NoiceCmdlinePopupBorderFilter = { link = 'NoicePopupWarnBaseGroup' } },
    { NoiceCmdlinePopupBorderHelp = { link = 'NoicePopupInfoBaseGroup' } },
    { NoiceCmdlinePopupBorderIncRename = { link = 'NoicePopupWarnBaseGroup' } },
    { NoiceCmdlinePopupBorderInput = { link = 'NoicePopupBaseGroup' } },
    { NoiceCmdlinePopupBorderLua = { link = 'NoicePopupBaseGroup' } },
    { NoiceCmdlineIconCmdline = { link = 'NoicePopupBaseGroup' } },
    { NoiceCmdlineIconSearch = { link = 'NoicePopupWarnBaseGroup' } },
    { NoiceCmdlineIconFilter = { link = 'NoicePopupWarnBaseGroup' } },
    { NoiceCmdlineIconHelp = { link = 'NoicePopupInfoBaseGroup' } },
    { NoiceCmdlineIconIncRename = { link = 'NoicePopupWarnBaseGroup' } },
    { NoiceCmdlineIconInput = { link = 'NoicePopupBaseGroup' } },
    { NoiceCmdlineIconLua = { link = 'NoicePopupBaseGroup' } },
  })
end
