return function()
  require('dapui').setup({
    windows = { indent = 2 },
    floating = {
      border = as.style.current.border,
    },
  })
  as.nnoremap('<localleader>duc', function() require('dapui').close() end, 'dap-ui: close')
  as.nnoremap('<localleader>dut', function() require('dapui').toggle() end, 'dap-ui: toggle')

  local exclusions = { 'dart' }
  local dap = require('dap')
  dap.listeners.after.event_initialized['dapui_config'] = function()
    if vim.tbl_contains(exclusions, vim.bo.filetype) then return end
    require('dapui').open()
    vim.api.nvim_exec_autocmds('User', { pattern = 'DapStarted' })
  end
  dap.listeners.before.event_terminated['dapui_config'] = function() require('dapui').close() end
  dap.listeners.before.event_exited['dapui_config'] = function() require('dapui').close() end
end
