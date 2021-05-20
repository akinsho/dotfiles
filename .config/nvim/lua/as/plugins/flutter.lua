return function()
  local ok, lsp_status = pcall(require, "lsp-status")
  local capabilities = ok and lsp_status.capabilities or nil

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
      on_attach = as.lsp and as.lsp.on_attach or nil,
      capabilities = capabilities
    }
  }
end
