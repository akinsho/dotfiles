return function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local lsp_ok, cmp_nvim_lsp = as.safe_require 'cmp_nvim_lsp'
  if lsp_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  require('go').setup {
    max_line_len = 100,
    goimport = 'gopls',
    icons = false,
    lsp_cfg = {
      capabilities = capabilities,
      codelenses = {
        generate = true,
        gc_details = false,
        test = true,
        tidy = true,
      },
      analyses = {
        unusedparams = true,
      },
    },
    lsp_gofumpt = true,
    lsp_keymaps = false,
    lsp_on_attach = as.lsp.on_attach,
    lsp_diag_virtual_text = false,
    dap_debug_keymap = false,
    textobjects = false,
  }
  as.augroup('Golang', {
    {
      event = { 'BufWritePre' },
      pattern = { '*.go' },
      command = 'silent! lua require("go.format").goimport()',
    },
  })
end
