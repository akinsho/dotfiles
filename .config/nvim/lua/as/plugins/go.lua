return function()
  local path = require 'nvim-lsp-installer.path'
  local install_root_dir = path.concat { vim.fn.stdpath 'data', 'lsp_servers' }
  require('go').setup {
    gopls_cmd = { install_root_dir .. '/go/gopls' },
    max_line_len = 100,
    goimport = 'gopls', -- NOTE: using goimports comes with unintended formatting consequences
    icons = false,
    lsp_cfg = {
      codelenses = {
        gc_details = false,
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
