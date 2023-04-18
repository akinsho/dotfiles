local highlight = as.highlight

return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      -- @see: https://github.com/nvim-orgmode/orgmode/issues/481
      local ok, orgmode = pcall(require, 'orgmode')
      if ok then orgmode.setup_ts_grammar() end

      require('nvim-treesitter.install').compilers = { 'gcc-12' }
      require('nvim-treesitter.configs').setup({
        -- stylua: ignore
        ensure_installed = {
          'c', 'vim', 'vimdoc', 'query', 'lua', 'luadoc', 'luap', 'go', 'dart', 'rust', 'typescript',
          'tsx', 'jsdoc', 'diff', 'regex', 'gitcommit', 'git_rebase', 'markdown', 'markdown_inline',
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'orgmode' },
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
              ['aL'] = { query = '@assignment.lhs', desc = 'ts: assignment lhs' },
              ['aR'] = { query = '@assignment.rhs', desc = 'ts: assignment rhs' },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = { [']m'] = '@function.outer', [']M'] = '@class.outer' },
            goto_previous_start = { ['[m'] = '@function.outer', ['[M'] = '@class.outer' },
          },
        },
        rainbow = {
          enable = true,
          disable = false,
          query = {
            'rainbow-parens',
            tsx = function() return nil end,
            javascript = function() return nil end,
          },
          strategy = { require('ts-rainbow.strategy.global') },
        },
        autopairs = { enable = true },
        context_commentstring = { enable = true },
        playground = { persist_queries = true },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { 'BufWrite', 'CursorHold' },
        },
      })
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'brokenbyte/nvim-ts-rainbow2' }, -- HiPhish
    },
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'typescriptreact', 'javascript', 'javascriptreact', 'html', 'vue' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = true,
  },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle' },
    dependencies = { 'nvim-treesitter' },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    init = function()
      highlight.plugin('treesitter-context', {
        { ContextBorder = { link = 'WinSeparator' } },
        { TreesitterContext = { inherit = 'Normal' } },
        { TreesitterContextLineNumber = { inherit = 'LineNr' } },
      })
    end,
    opts = {
      multiline_threshold = 4,
      separator = { '─', 'ContextBorder' }, -- alternatives: ▁ ─ ▄
      mode = 'cursor',
    },
  },
}
