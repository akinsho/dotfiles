return {
  {
    'stevearc/conform.nvim',
    event = 'BufReadPre',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        markdown = { 'prettier' },
        go = { 'goimports', 'gofumpt' },
        pgsql = { 'sql_formatter' },
        sql = { 'sql_formatter' },
      },
      format_on_save = function(buf)
        if vim.g.formatting_disabled or vim.b[buf].formatting_disabled then return end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
    config = function(_, opts)
      require('conform').setup(opts)
      require('conform.formatters.sql_formatter').args = function(ctx)
        local config_path = ctx.dirname .. '/.sql-formatter.json'
        if vim.uv.fs_stat(config_path) then return { '--config', config_path } end
        return { '--language', 'postgresql' }
      end
    end,
  },
}
