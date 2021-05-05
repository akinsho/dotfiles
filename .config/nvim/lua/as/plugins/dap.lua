return function()
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
  require("which-key").register(
    {
      d = {
        name = "+debugger",
        ["?"] = {[[<cmd>lua require'dap.ui.variables'.scopes()<CR>]], "hover: variables scopes"},
        b = {[[<cmd>lua require'dap'.toggle_breakpoint()<CR>]], "toggle breakpoint"},
        B = {
          [[<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]],
          "set breakpoint"
        },
        c = {[[<cmd>lua require'dap'.continue()<CR>]], "continue or start debugging"},
        e = {[[<cmd>lua require'dap'.step_out()<CR>]], "step out"},
        i = {[[<cmd>lua require'dap'.step_into()<CR>]], "step into"},
        o = {[[<cmd>lua require'dap'.step_over()<CR>]], "step over"},
        l = {[[<cmd>lua require'dap'.repl.run_last()<CR>]], "REPL: run last"},
        r = {[[<cmd>lua require'dap'.repl.open()<CR>]], "REPL: open"}
      }
    },
    {prefix = "<localleader>"}
  )
end
