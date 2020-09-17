if !PluginLoaded('nvim-treesitter')
  finish
endif

highlight link TSKeyword Statement
highlight TSParameter gui=italic,bold

" This plugin is an experimental application of tree sitter usage in Neovim
" be careful when applying any functionality to a filetype as it might not work
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  custom_captures = {
    ["variable.parameter"] = "TSParameter",
  },
  highlight = {
    enable = true,
    disable = {"json"}
  },
  incremental_selection = {
    enable = false,
    keymaps = {                       -- mappings for incremental selection (visual mappings)
      init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
      node_incremental = "grn",       -- increment to the upper named parent
      scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
      node_decremental = "grm",       -- decrement to the previous node
    }
  },
}
EOF

nnoremap <silent><localleader>dte :TSEnable highlight<CR>
nnoremap <silent><localleader>dtd :TSDisable highlight<CR>
nnoremap <silent><localleader>dtp :TSPlaygroundToggle<CR>

augroup TreeSitterFolds
  autocmd FileType go,dart,rust,java,c setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
augroup END
