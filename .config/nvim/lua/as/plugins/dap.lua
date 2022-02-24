local M = {}

function M.setup()
  require('which-key').register({
    d = {
      name = '+debugger',
      b = 'dap: toggle breakpoint',
      B = 'dap: set breakpoint',
      c = 'dap: continue or start debugging',
      e = 'dap: step out',
      i = 'dap: step into',
      o = 'dap: step over',
      l = 'dap REPL: run last',
      t = 'dap REPL: toggle',
    },
  }, {
    prefix = '<localleader>',
  })
end

function M.config()
  local dap = require 'dap'
  local fn = vim.fn

  fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
  fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
      host = function()
        local value = fn.input 'Host [default: 127.0.0.1]: '
        return value ~= '' and value or '127.0.0.1'
      end,
      port = function()
        local val = tonumber(fn.input 'Port: ')
        assert(val, 'Please provide a port number')
        return val
      end,
    },
  }

  dap.adapters.nlua = function(callback, config)
    callback { type = 'server', host = config.host, port = config.port }
  end

  -- DON'T automatically stop at exceptions
  dap.defaults.fallback.exception_breakpoints = {}
  -- NOTE: the window options can be set directly in this function
  as.nnoremap('<localleader>dt', "<Cmd>lua require'dap'.repl.toggle()<CR>")
  as.nnoremap('<localleader>dc', "<Cmd>lua require'dap'.continue()<CR>")
  as.nnoremap('<localleader>de', "<Cmd>lua require'dap'.step_out()<CR>")
  as.nnoremap('<localleader>di', "<Cmd>lua require'dap'.step_into()<CR>")
  as.nnoremap('<localleader>do', "<Cmd>lua require'dap'.step_over()<CR>")
  as.nnoremap('<localleader>dl', "<Cmd>lua require'dap'.run_last()<CR>")
  as.nnoremap('<localleader>db', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
  as.nnoremap(
    '<localleader>dB',
    "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input 'Breakpoint condition: ')<CR>"
  )
end

return M
