local M = {}

function M.setup()
  local fn = vim.fn
  local function repl_toggle() require('dap').repl.toggle(nil, 'botright split') end
  local function continue() require('dap').continue() end
  local function step_out() require('dap').step_out() end
  local function step_into() require('dap').step_into() end
  local function step_over() require('dap').step_over() end
  local function run_last() require('dap').run_last() end
  local function toggle_breakpoint() require('dap').toggle_breakpoint() end
  local function set_breakpoint() require('dap').set_breakpoint(fn.input('Breakpoint condition: ')) end
  as.nnoremap('<localleader>db', toggle_breakpoint, 'dap: toggle breakpoint')
  as.nnoremap('<localleader>dB', set_breakpoint, 'dap: set breakpoint')
  as.nnoremap('<localleader>dc', continue, 'dap: continue or start debugging')
  as.nnoremap('<localleader>de', step_out, 'dap: step out')
  as.nnoremap('<localleader>di', step_into, 'dap: step into')
  as.nnoremap('<localleader>do', step_over, 'dap: step over')
  as.nnoremap('<localleader>dl', run_last, 'dap REPL: run last')
  as.nnoremap('<localleader>dt', repl_toggle, 'dap REPL: toggle')
end

function M.config()
  local fn, icons = vim.fn, as.style.icons

  require('as.highlights').plugin('dap', {
    { DapBreakpoint = { foreground = as.style.palette.light_red } },
    { DapStopped = { foreground = as.style.palette.green } },
  })

  fn.sign_define('DapBreakpoint', {
    text = icons.misc.bug,
    texthl = 'DapBreakpoint',
    linehl = '',
    numhl = '',
  })

  fn.sign_define('DapStopped', {
    text = icons.misc.bookmark,
    texthl = 'DapStopped',
    linehl = '',
    numhl = '',
  })

  -- DON'T automatically stop at exceptions
  -- dap.defaults.fallback.exception_breakpoints = {}
end

return M
