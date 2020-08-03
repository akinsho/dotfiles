if !PluginLoaded('nvim-treesitter')
  finish
endif

" This plugin is an experimental application of tree sitter usage in Neovim
" be careful when applying any functionality to a filetype as it might not work
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,   -- false will disable the whole extension
    disable = {      -- list of language that will be disabled
    'lua',
    'javascript',
    'typescript',
    'json'
    },
  },
  incremental_selection = {
        enable = true,
        keymaps = {                       -- mappings for incremental selection (visual mappings)
          init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
          node_incremental = "grn",       -- increment to the upper named parent
          scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
          node_decremental = "grm",       -- decrement to the previous node
        }
  },
  refactor = {
    highlight_current_scope = {
        enable = false
    },
  },
  textobjects = { -- syntax-aware textobjects
      enable = true,
      disable = {},
      keymaps = {
          -- queries from supported languages with textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["aC"] = "@class.outer",
          ["iC"] = "@class.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["ae"] = "@block.outer",
          ["ie"] = "@block.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["is"] = "@statement.inner",
          ["as"] = "@statement.outer",
          ["ad"] = "@comment.outer",
          ["am"] = "@call.outer",
          ["im"] = "@call.inner"
      }
  },
}
EOF

augroup TreeSitterFolds
  autocmd FileType go,dart,rust,java,c setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
augroup END
