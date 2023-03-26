local fn = vim.fn
local icons, highlight, border = as.ui.icons, as.highlight, as.ui.current.border

as.debug = { layout = { ft = { dart = 2 } } }

return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<localleader>dL',
        function() require('dap').set_breakpoint(nil, nil, fn.input('Log point message: ')) end,
        desc = 'dap: log breakpoint',
      },
      {
        '<localleader>db',
        function() require('dap').toggle_breakpoint() end,
        desc = 'dap: toggle breakpoint',
      },
      {
        '<localleader>dB',
        function() require('dap').set_breakpoint(fn.input('Breakpoint condition: ')) end,
        desc = 'dap: set conditional breakpoint',
      },
      {
        '<localleader>dc',
        function() require('dap').continue() end,
        desc = 'dap: continue or start debugging',
      },
      {
        '<localleader>duc',
        function() require('dapui').close(as.debug.layout.ft[vim.bo.ft]) end,
        desc = 'dap ui: close',
      },
      {
        '<localleader>dut',
        function() require('dapui').toggle(as.debug.layout.ft[vim.bo.ft]) end,
        desc = 'dap ui: toggle',
      },
      { '<localleader>de', function() require('dap').step_out() end, desc = 'dap: step out' },
      { '<localleader>di', function() require('dap').step_into() end, desc = 'dap: step into' },
      { '<localleader>do', function() require('dap').step_over() end, desc = 'dap: step over' },
      { '<localleader>dl', function() require('dap').run_last() end, desc = 'dap REPL: run last' },
    },
    config = function()
      local dap = require('dap') -- NOTE: Must be loaded before the signs can be tweaked
      local dapui = require('dapui')

      highlight.plugin('dap', {
        { DapBreakpoint = { fg = as.ui.palette.light_red } },
        { DapStopped = { fg = as.ui.palette.green } },
      })

      fn.sign_define({
        {
          name = 'DapBreakpoint',
          texthl = 'DapBreakpoint',
          text = icons.misc.bug,
          linehl = '',
          numhl = '',
        },
        {
          name = 'DapStopped',
          texthl = 'DapStopped',
          text = icons.misc.bookmark,
          linehl = '',
          numhl = '',
        },
      })

      -- DON'T automatically stop at exceptions
      -- dap.defaults.fallback.exception_breakpoints = {}

      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open(as.debug.layout.ft[vim.bo.ft])
      end
    end,
    dependencies = {
      {
        {
          'rcarriga/nvim-dap-ui',
          opts = {
            windows = { indent = 2 },
            floating = { border = border },
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  { id = 'breakpoints', size = 0.25 },
                  { id = 'stacks', size = 0.25 },
                  { id = 'watches', size = 0.25 },
                },
                position = 'left',
                size = 20,
              },
              { elements = { { id = 'repl', size = 0.9 } }, position = 'bottom', size = 10 },
            },
          },
        },
        { 'theHamsta/nvim-dap-virtual-text', opts = { all_frames = true } },
      },
    },
  },
}
