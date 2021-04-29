return function()
  local nnoremap = as.nnoremap
  local vnoremap = as.vnoremap

  vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})
  vim.fn.sign_define("DapStopped", {text = "🟢", texthl = "", linehl = "", numhl = ""})

  local dap = require("dap")

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input("Host [127.0.0.1]: ")
        if value ~= "" then
          return value
        end
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input("Port: "))
        assert(val, "Please provide a port number")
        return val
      end
    }
  }

  dap.adapters.nlua = function(callback, config)
    callback({type = "server", host = config.host, port = config.port})
  end

  vnoremap("<localleader>di", [[<cmd>lua require'dap.ui.variables'.visual_hover()<CR>]])
  nnoremap("<localleader>d?", [[<cmd>lua require'dap.ui.variables'.scopes()<CR>]])
  nnoremap("<localleader>dc", [[<cmd>lua require'dap'.continue()<CR>]])
  nnoremap("<localleader>do", [[<cmd>lua require'dap'.step_over()<CR>]])
  nnoremap("<localleader>di", [[<cmd>lua require'dap'.step_into()<CR>]])
  nnoremap("<localleader>de", [[<cmd>lua require'dap'.step_out()<CR>]])
  nnoremap("<localleader>db", [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]])
  nnoremap(
    "<localleader>dB",
    [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]
  )
  nnoremap(
    "<localleader>dl",
    [[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]]
  )
  nnoremap("<localleader>dr", [[<cmd>lua require'dap'.repl.open()<CR>]])
  nnoremap("<localleader>dl", [[<cmd>lua require'dap'.repl.run_last()<CR>]])
  require("which-key").register(
    {
      d = {
        name = "+debugger",
        ["?"] = "hover: variables scopes",
        b = "toggle breakpoint",
        B = "set breakpoint",
        c = "continue or start debugging",
        e = "step out",
        i = "step into",
        o = "step over",
        l = "REPL: run last",
        r = "REPL: open"
      }
    },
    {prefix = "<localleader>"}
  )
end
