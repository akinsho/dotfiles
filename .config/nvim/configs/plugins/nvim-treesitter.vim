if !PluginLoaded('nvim-treesitter')
  finish
endif

" This plugin is an experimental application of tree sitter usage in Neovim
" be careful when applying any functionality to a filetype as it might not work
lua << EOF
local has_mac = vim.fn.has('mac') > 0

local mac_config = { enable = false }

local linux_config = {
  enable = true,                                   -- false will disable the whole extension
  disable = { 'javascript', 'typescript', 'lua' }, -- list of language that will be disabled
}

local highlight_config = has_mac and mac_config or linux_config

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  highlight = highlight_config,
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
        enable = true
    },
  }
}
EOF
