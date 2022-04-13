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
  local icons = as.style.icons

  fn.sign_define {
    {
      name = 'DapBreakpoint',
      text = icons.misc.bug,
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = '',
    },
    {
      name = 'DapStopped',
      text = icons.misc.bookmark,
      texthl = 'DapStopped',
      linehl = '',
      numhl = '',
    },
  }

  require('as.highlights').plugin('dap', {
    DapBreakpoint = { foreground = as.style.palette.light_red },
    DapStopped = { foreground = as.style.palette.green },
  })

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
  -- dap.defaults.fallback.exception_breakpoints = {}
  -- NOTE: the window options can be set directly in this function

  as.nnoremap('<localleader>dt', function()
    require('dap').repl.toggle(nil, 'botright split')
  end)
  as.nnoremap('<localleader>dc', function()
    require('dap').continue()
  end)
  as.nnoremap('<localleader>de', function()
    require('dap').step_out()
  end)
  as.nnoremap('<localleader>di', function()
    require('dap').step_into()
  end)
  as.nnoremap('<localleader>do', function()
    require('dap').step_over()
  end)
  as.nnoremap('<localleader>dl', function()
    require('dap').run_last()
  end)
  as.nnoremap('<localleader>db', function()
    require('dap').toggle_breakpoint()
  end)
  as.nnoremap('<localleader>dB', function()
    require('dap').set_breakpoint(fn.input 'Breakpoint condition: ')
  end)
end

return M
