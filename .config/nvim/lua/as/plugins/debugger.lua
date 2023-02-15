local function dapui_config()
  require('dapui').setup({
    windows = { indent = 2 },
    floating = {
      border = as.ui.current.border,
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

local function init()
  local fn = vim.fn

  local function dap() return require('dap') end

  local function repl_toggle() dap().repl.toggle(nil, 'botright split') end
  local function continue() dap().continue() end
  local function step_out() dap().step_out() end
  local function step_into() dap().step_into() end
  local function step_over() dap().step_over() end
  local function run_last() dap().run_last() end
  local function toggle_breakpoint() dap().toggle_breakpoint() end
  local function set_breakpoint() dap().set_breakpoint(fn.input('Breakpoint condition: ')) end
  local function log_breakpoint() dap().set_breakpoint(nil, nil, fn.input('Log point message: ')) end

  as.nnoremap('<localleader>dL', log_breakpoint, 'dap: log breakpoint')
  as.nnoremap('<localleader>db', toggle_breakpoint, 'dap: toggle breakpoint')
  as.nnoremap('<localleader>dB', set_breakpoint, 'dap: set conditional breakpoint')
  as.nnoremap('<localleader>dc', continue, 'dap: continue or start debugging')
  as.nnoremap('<localleader>de', step_out, 'dap: step out')
  as.nnoremap('<localleader>di', step_into, 'dap: step into')
  as.nnoremap('<localleader>do', step_over, 'dap: step over')
  as.nnoremap('<localleader>dl', run_last, 'dap REPL: run last')
  as.nnoremap('<localleader>dt', repl_toggle, 'dap REPL: toggle')
end

local function config()
  local fn, icons = vim.fn, as.ui.icons

  require('dap') -- Dap must be loaded before the signs can be tweaked

  as.highlight.plugin('dap', {
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
end

return {
  {
    'mfussenegger/nvim-dap',
    init = init,
    config = config,
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = dapui_config,
        { 'theHamsta/nvim-dap-virtual-text', opts = { all_frames = true } },
      },
    },
  },
}
