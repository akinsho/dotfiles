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
  require('which-key').register({
    d = {
      name = '+debugger',
      b = { toggle_breakpoint, 'dap: toggle breakpoint' },
      B = { set_breakpoint, 'dap: set breakpoint' },
      c = { continue, 'dap: continue or start debugging' },
      e = { step_out, 'dap: step out' },
      i = { step_into, 'dap: step into' },
      o = { step_over, 'dap: step over' },
      l = { run_last, 'dap REPL: run last' },
      t = { repl_toggle, 'dap REPL: toggle' },
    },
  }, {
    prefix = '<localleader>',
  })
end

function M.config()
  local fn = vim.fn
  local icons = as.style.icons

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

  require('as.highlights').plugin('dap', {
    { DapBreakpoint = { foreground = as.style.palette.light_red } },
    { DapStopped = { foreground = as.style.palette.green } },
  })

  -- DON'T automatically stop at exceptions
  -- dap.defaults.fallback.exception_breakpoints = {}
  -- NOTE: the window options can be set directly in this function
end

return M
