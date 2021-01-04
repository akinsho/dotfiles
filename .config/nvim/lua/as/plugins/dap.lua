return function()
  local home = os.getenv("HOME")
  local map = as_utils.map
  local dap = require("dap")

  dap.adapters.dart = {
    type = "executable",
    command = "node",
    args = {home .. "/dart-code/out/dist/debug.js", "flutter"}
  }
  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch flutter",
      dartSdkPath = home .. "/flutter/bin/cache/dart-sdk/",
      flutterSdkPath = home .. "/flutter",
      program = "${workspaceFolder}/lib/main.dart",
      cwd = "${workspaceFolder}"
    }
  }

  vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})

  map("n", "<localleader>dc", [[<cmd>lua require'dap'.continue()<CR>]])
  map("n", "<localleader>do", [[<cmd>lua require'dap'.step_over()<CR>]])
  map("n", "<localleader>di", [[<cmd>lua require'dap'.step_into()<CR>]])
  map("n", "<localleader>de", [[<cmd>lua require'dap'.step_out()<CR>]])
  map("n", "<localleader>db", [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]])
  map(
    "n",
    "<localleader>dB",
    [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]
  )
  map(
    "n",
    "<localleader>dl",
    [[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]]
  )
  map("n", "<localleader>dr", [[<cmd>lua require'dap'.repl.open()<CR>]])
  map("n", "<localleader>dl", [[<cmd>lua require'dap'.repl.run_last()<CR>]])
end
