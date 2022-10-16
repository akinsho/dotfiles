return function()
  require('window-picker').setup({
    use_winbar = 'smart',
    autoselect_one = true,
    include_current = false,
    filter_rules = {
      bo = {
        filetype = { 'neo-tree-popup', 'quickfix', 'incline' },
        buftype = { 'terminal', 'quickfix', 'nofile' },
      },
    },
    other_win_hl_color = require('as.highlights').get('Visual', 'bg'),
  })
end
