return function()
  require('dapui').setup()
  as.nnoremap('<localleader>duc', function()
    require('dapui').close()
  end, 'dap-ui: close')
  as.nnoremap('<localleader>dut', function()
    require('dapui').toggle()
  end, 'dap-ui: toggle')

  local dap = require('dap')
  dap.listeners.after.event_initialized['dapui_config'] = function()
    require('dapui').open()
    vim.api.nvim_exec_autocmds('User', 'DapStarted')
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    require('dapui').close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    require('dapui').close()
  end
end
