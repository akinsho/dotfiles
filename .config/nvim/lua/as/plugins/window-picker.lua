return function()
  require('window-picker').setup({
    autoselect_one = true,
    include_current = false,
    filter_rules = {
      bo = {
        filetype = { 'neo-tree-popup', 'quickfix' },
        buftype = { 'terminal', 'quickfix' },
      },
    },
    other_win_hl_color = require('as.highlights').get_hl('Visual', 'bg'),
  })
end
