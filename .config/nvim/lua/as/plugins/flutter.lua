return function()
  require("flutter-tools").setup {
    experimental = {
      lsp_derive_paths = true
    },
    debugger = {
      enabled = true
    },
    widget_guides = {
      enabled = true,
      debug = true
    },
    dev_log = {open_cmd = "tabedit"},
    lsp = {
      on_attach = as.lsp and as.lsp.on_attach,
      capabilities = require("lsp-status").capabilities or {},
      settings = {
        showTodos = true,
        completeFunctionCalls = true,
      }
    }
  }
end
