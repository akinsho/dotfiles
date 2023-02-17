local highlight = as.highlight

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.install').compilers = { 'gcc-12' }
      local parsers = require('nvim-treesitter.parsers')
      local rainbow_enabled = { 'dart' }

      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'lua',
          'bash',
          'go',
          'dart',
          'rust',
          'typescript',
          'javascript',
          'diff',
          'regex',
          'git_rebase',
          'gitcommit',
          'markdown',
          'markdown_inline',
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
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
        textobjects = {
          lookahead = true,
          select = {
            enable = true,
            include_surrounding_whitespace = true,
            keymaps = {
              ['af'] = { query = '@function.outer', desc = 'ts: all function' },
              ['if'] = { query = '@function.inner', desc = 'ts: inner function' },
              ['ac'] = { query = '@class.outer', desc = 'ts: all class' },
              ['ic'] = { query = '@class.inner', desc = 'ts: inner class' },
              ['aC'] = { query = '@conditional.outer', desc = 'ts: all conditional' },
              ['iC'] = { query = '@conditional.inner', desc = 'ts: inner conditional' },
              ['iA'] = { query = '@assignment.lhs', desc = 'ts: assignment lhs' },
              ['aA'] = { query = '@assignment.rhs', desc = 'ts: assignment rhs' },
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']M'] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[M'] = '@class.outer',
            },
          },
        },
        rainbow = {
          enable = true,
          disable = vim.tbl_filter(function(p)
            local disable = true
            for _, lang in pairs(rainbow_enabled) do
              if p == lang then disable = false end
            end
            return disable
          end, parsers.available_parsers()),
          colors = {
            'royalblue3',
            'darkorange3',
            'seagreen3',
            'firebrick',
            'darkorchid3',
          },
        },
        autopairs = { enable = true },
        playground = { persist_queries = true },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { 'BufWrite', 'CursorHold' },
        },
        context_commentstring = { enable = true },
      })
    end,
    dependencies = {
      { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle' } },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'mrjones2014/nvim-ts-rainbow' },
    },
  },
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    init = function()
      highlight.plugin('treesitter-context', {
        { ContextBorder = { link = 'Dim' } },
        { TreesitterContext = { inherit = 'Normal' } },
        { TreesitterContextLineNumber = { inherit = 'LineNr' } },
      })
    end,
    opts = {
      multiline_threshold = 4,
      separator = { '─', 'ContextBorder' }, -- alternatives: ▁ ─ ▄
      mode = 'topline',
    },
  },
}
