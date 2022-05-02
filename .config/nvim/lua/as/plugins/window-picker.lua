return function()
  require('window-picker').setup {
    autoselect_one = true,
    include_current = false,
    filter_rules = {
      bo = {
        filetype = { 'neo-tree-popup', 'quickfix' },
        buftype = { 'terminal' },
      },
    },
    other_win_hl_color = '#e35e4f',
  }
end
