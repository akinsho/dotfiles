return function()
  local null_ls = require('null-ls')
  null_ls.setup({
    debounce = 150,
    on_attach = as.lsp.on_attach,
    sources = {
      null_ls.builtins.diagnostics.buf,
      null_ls.builtins.diagnostics.zsh,
      null_ls.builtins.diagnostics.golangci_lint,
      null_ls.builtins.formatting.stylua.with({
        condition = function(_utils)
          return as.executable('stylua') and _utils.root_has_file({ 'stylua.toml', '.stylua.toml' })
        end,
      }),
      null_ls.builtins.formatting.prettier.with({
        filetypes = { 'html', 'json', 'yaml', 'graphql', 'markdown' },
        condition = function()
          return as.executable('prettier')
        end,
      }),
    },
  })
end
