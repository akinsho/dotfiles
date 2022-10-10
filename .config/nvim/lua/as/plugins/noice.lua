return function()
  require('noice').setup({
    popupmenu = {
      backend = 'cmp',
    },
    views = {
      split = {
        win_options = {
          winhighlight = { Normal = 'Normal' },
        },
      },
      cmdline_popup = {
        position = {
          row = 10,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 13,
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
  })
end
