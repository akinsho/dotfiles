return {
  {
    'jay-babu/mason-null-ls.nvim',
    dependencies = { 'mason.nvim' },
    opts = { automatic_installation = true },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim', 'mason-null-ls.nvim' },
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        debounce = 150,
        sources = {
          null_ls.builtins.diagnostics.buf,
          null_ls.builtins.diagnostics.zsh,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.formatting.pg_format,
          null_ls.builtins.formatting.stylua.with({
            condition = function()
              return as.executable('stylua')
                and not vim.tbl_isempty(vim.fs.find({ '.stylua.toml', 'stylua.toml' }, {
                  path = vim.fn.expand('%:p'),
                  upward = true,
                }))
            end,
          }),
          null_ls.builtins.formatting.prettier.with({
            filetypes = { 'html', 'json', 'yaml', 'graphql', 'markdown' },
            condition = function() return as.executable('prettier') end,
          }),
        },
      })
    end,
  },
}
