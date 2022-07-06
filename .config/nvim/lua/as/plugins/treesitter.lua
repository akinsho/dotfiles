as.treesitter = as.treesitter or {
  install_attempted = {},
}

-- When visiting a file with a type we don't have a parser for, ask me if I want to install it.
function as.treesitter.ensure_parser_installed()
  local WAIT_TIME = 6000
  local parsers = require('nvim-treesitter.parsers')
  local lang = parsers.get_buf_lang()
  local fmt = string.format
  if
    parsers.get_parser_configs()[lang]
    and not parsers.has_parser(lang)
    and not as.treesitter.install_attempted[lang]
  then
    vim.schedule(function()
      vim.cmd('TSInstall ' .. lang)
      as.treesitter.install_attempted[lang] = true
      vim.notify(fmt('Installing Treesitter parser for %s', lang), 'info', {
        title = 'Nvim Treesitter',
        icon = as.style.icons.misc.down,
        timeout = WAIT_TIME,
      })
    end)
  end
end

return function()
  local parsers = require('nvim-treesitter.parsers')
  local rainbow_enabled = { 'dart' }

  as.augroup('TSParserCheck', {
    {
      event = 'FileType',
      desc = 'Treesitter: install missing parsers',
      command = as.treesitter.ensure_parser_installed,
    },
  })

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'lua',
      'go',
      'dart',
      'rust',
      'typescript',
      'javascript',
      'comment',
      'markdown',
      'markdown_inline',
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = '<CR>', -- maps in normal mode to init the node/scope selection
        node_incremental = '<CR>', -- increment to the upper named parent
        node_decremental = '<C-CR>', -- decrement to the previous node
        -- scope_incremental = '<TAB>', -- increment to the upper scope (as defined in locals.scm)
        -- scope_decremental = '<C-TAB>', -- increment to the upper scope (as defined in locals.scm)
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
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aC'] = '@conditional.outer',
          ['iC'] = '@conditional.inner',
          -- FIXME: this is unusable
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
          -- ['ax'] = '@comment.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['[w'] = { '@parameter.inner' },
        },
        swap_previous = {
          [']w'] = { '@parameter.inner' },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = { '@function.outer', '@class.outer' },
        },
        goto_previous_start = {
          ['[m'] = { '@function.outer', '@class.outer' },
        },
      },
      lsp_interop = {
        enable = true,
        border = as.style.current.border,
        peek_definition_code = {
          ['<leader>df'] = '@function.outer',
          ['<leader>dF'] = '@class.outer',
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
    playground = {
      persist_queries = true,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
  })
end
