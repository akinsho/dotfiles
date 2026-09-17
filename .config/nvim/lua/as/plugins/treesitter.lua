local highlight = as.highlight

return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup({
        -- stylua: ignore
        ensure_installed = {
          'c', 'vim', 'vimdoc', 'query', 'lua', 'luadoc', 'luap',
          'diff', 'regex', 'gitcommit', 'git_config', 'git_rebase', 'markdown', 'markdown_inline',
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'org', 'sql' },
        },
        incremental_selection = {
          enable = true,
          disable = { 'help' },
          keymaps = {
            init_selection = '<CR>', -- maps in normal mode to init the node/scope selection
            node_incremental = '<CR>', -- increment to the upper named parent
            node_decremental = '<C-CR>', -- decrement to the previous node
          },
        },
        indent = {
          enable = true,
          disable = { 'yaml' },
        },
        -- NOTE: the `textobjects` module is deliberately absent. It resolves
        -- captures through `nvim-treesitter.query`, which asks `iter_matches` for
        -- the `all = false` behaviour Neovim removed in 0.11, so every capture
        -- comes back as a list of nodes and errors with "attempt to call method
        -- 'range' (a nil value)". Those textobjects live in mini.ai instead.
      })
    end,
    -- Kept for the `textobjects` queries it ships, which mini.ai reads via
    -- `vim.treesitter.query.get()`. Its lua modules are not used.
    dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects' } },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    init = function()
      highlight.plugin('treesitter-context', {
        { TreesitterContextSeparator = { link = 'Dim' } },
        { TreesitterContext = { inherit = 'Normal' } },
        { TreesitterContextLineNumber = { inherit = 'LineNr' } },
      })
    end,
    opts = {
      multiline_threshold = 4,
      separator = '─', -- alternatives: ▁ ─ ▄
      mode = 'cursor',
    },
  },
}
