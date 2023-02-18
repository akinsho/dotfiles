local fn, api = vim.fn, vim.api
local icons, highlight = as.ui.icons, as.highlight

local function repl_toggle() require('dap').repl.toggle(nil, 'botright split') end
local function continue() require('dap').continue() end
local function step_out() require('dap').step_out() end
local function step_into() require('dap').step_into() end
local function step_over() require('dap').step_over() end
local function run_last() require('dap').run_last() end
local function toggle_breakpoint() require('dap').toggle_breakpoint() end
local function set_breakpoint() require('dap').set_breakpoint(fn.input('Breakpoint condition: ')) end
local function log_breakpoint()
  require('dap').set_breakpoint(nil, nil, fn.input('Log point message: '))
end

return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<localleader>dL', log_breakpoint, desc = 'dap: log breakpoint' },
      { '<localleader>db', toggle_breakpoint, desc = 'dap: toggle breakpoint' },
      { '<localleader>dB', set_breakpoint, desc = 'dap: set conditional breakpoint' },
      { '<localleader>dc', continue, desc = 'dap: continue or start debugging' },
      { '<localleader>de', step_out, desc = 'dap: step out' },
      { '<localleader>di', step_into, desc = 'dap: step into' },
      { '<localleader>do', step_over, desc = 'dap: step over' },
      { '<localleader>dl', run_last, desc = 'dap REPL: run last' },
      { '<localleader>dt', repl_toggle, desc = 'dap REPL: toggle' },
    },
    config = function()
      require('dap') -- Dap must be loaded before the signs can be tweaked

      highlight.plugin('dap', {
        { DapBreakpoint = { foreground = as.ui.palette.light_red } },
        { DapStopped = { foreground = as.ui.palette.green } },
      })

      fn.sign_define({
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
      })

      -- DON'T automatically stop at exceptions
      -- dap.defaults.fallback.exception_breakpoints = {}
    end,
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        keys = {
          { '<localleader>duc', function() require('dapui').close() end, desc = 'dap-ui: close' },
          { '<localleader>dut', function() require('dapui').toggle() end, desc = 'dap-ui: toggle' },
        },
        config = function()
          require('dapui').setup({
            windows = { indent = 2 },
            floating = { border = as.ui.current.border },
          })
          local exclusions = { 'dart' }
          local dap = require('dap')
          dap.listeners.after.event_initialized['dapui_config'] = function()
            if vim.tbl_contains(exclusions, vim.bo.filetype) then return end
            require('dapui').open()
            api.nvim_exec_autocmds('User', { pattern = 'DapStarted' })
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            require('dapui').close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function() require('dapui').close() end
        end,

        { 'theHamsta/nvim-dap-virtual-text', opts = { all_frames = true } },
      },
    },
  },
}
