return function()
  local status = require("lsp-status")
  require("flutter-tools").setup {
    experimental = {
      lsp_derive_paths = true
    },
    debugger = {
      enabled = true
    },
    flutter_outline = {
      enabled = true
    },
    dev_log = {open_cmd = "tabedit"},
    lsp = {
      on_attach = as_utils.lsp.on_attach,
      capabilities = status.capabilities or {}
    }
  }
end
