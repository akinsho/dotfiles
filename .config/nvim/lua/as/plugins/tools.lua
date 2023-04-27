return {
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason.nvim', 'null-ls.nvim' },
    config = function()
      local null_ls = require('null-ls')
      require('mason-null-ls').setup({
        automatic_setup = true,
        automatic_installation = true,
        ensure_installed = { 'buf', 'goimports', 'golangci_lint', 'stylua', 'prettier' },
        handlers = {
          eslint = function()
            null_ls.register(null_ls.builtins.diagnostics.eslint.with({ extra_filetypes = { 'svelte' } }))
          end,
        },
      })
      null_ls.setup()
    end,
  },
}
