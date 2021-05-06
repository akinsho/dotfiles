return function()
  local vnoremap = as.vnoremap
  local dap = require("dap")

  vim.fn.sign_define("DapBreakpoint", {text = "🛑", texthl = "", linehl = "", numhl = ""})
  vim.fn.sign_define("DapStopped", {text = "🟢", texthl = "", linehl = "", numhl = ""})

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

  local function set_breakpoint()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end

  vnoremap("<localleader>di", [[<cmd>lua require'dap.ui.variables'.visual_hover()<CR>]])
  require("which-key").register(
    {
      d = {
        name = "+debugger",
        ["?"] = {require("dap.ui.variables").scopes, "hover: variables scopes"},
        b = {dap.toggle_breakpoint, "toggle breakpoint"},
        B = {set_breakpoint, "set breakpoint"},
        c = {dap.continue, "continue or start debugging"},
        e = {dap.step_out, "step out"},
        i = {dap.step_into, "step into"},
        o = {dap.step_over, "step over"},
        l = {dap.repl.run_last, "REPL: run last"},
        -- NOTE: the window options can be set directly in this function
        r = {dap.repl.toggle, "REPL: toggle"}
      }
    },
    {prefix = "<localleader>"}
  )
end
