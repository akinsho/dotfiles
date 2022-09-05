return function()
  require('tint').setup({
    tint = -35,
    highlight_ignore_patterns = {
      'WinSeparator',
      'Status.*',
      'Comment',
      'Beacon.*',
      'Panel.*',
      'Telescope.*',
    },
    window_ignore_function = function(win_id)
      if vim.fn.win_gettype(win_id) ~= '' then return true end
      local buf = vim.api.nvim_win_get_buf(win_id)
      local b = vim.bo[buf]
      local ignore_bt = { 'terminal', 'prompt', 'nofile' }
      local ignore_ft = { 'neo-tree', 'packer', 'diff', 'toggleterm', 'Neogit.*', 'Telescope.*' }
      return as.any(b.bt, ignore_bt) or as.any(b.ft, ignore_ft)
    end,
  })
end
