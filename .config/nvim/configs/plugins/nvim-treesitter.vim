if !PluginLoaded('nvim-treesitter')
  finish
endif

highlight link TSKeyword Statement
highlight TSParameter gui=italic,bold

" This plugin is an experimental application of tree sitter usage in Neovim
" be careful when applying any functionality to a filetype as it might not work
lua << EOF
-- Disable treesitter for certian filetypes when running on MacOs
-- because that is work and the bugs are more annoying in that context
local is_mac = vim.loop.os_uname().sysname == "Darwin"
local disabled = {"json"}
if is_mac then
  table.insert(disabled, "dart")
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = disabled
  },
  incremental_selection = {
    enable = true,
    keymaps = {                       -- mappings for incremental selection (visual mappings)
      init_selection = '<enter>',     -- maps in normal mode to init the node/scope selection
      node_incremental = '<enter>',   -- increment to the upper named parent
      scope_incremental = 'grc',      -- increment to the upper scope (as defined in locals.scm)
      node_decremental = 'grm',       -- decrement to the previous node
    }
  },
  rainbow = {
    enable = disable,
    disable = {'lua'}
  }
}

-- Disable parentheses highlights
require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.highlighter.hl_map
hlmap["punctuation.bracket"] = nil

local function add_folds()
  -- Only apply folding to supported files, inspired by:
  -- https://github.com/Happy-Dude/dotfiles/blob/71172469884481c0da4743928df1b1296d1d7a47/vim/.vim/lua/treesitter.lua#L57
  local parsers = require 'nvim-treesitter.parsers'
  local configs = parsers.get_parser_configs()
  local ft_str = table.concat(
  vim.tbl_map(
  function(ft)
    return configs[ft].filetype or ft
  end, parsers.available_parsers()),
  ','
  )
  vim.cmd('autocmd Filetype '
    ..ft_str..
    ' setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()'
  )
end

add_folds()

EOF

nnoremap <silent><localleader>dte :TSEnable highlight<CR>
nnoremap <silent><localleader>dtd :TSDisable highlight<CR>
nnoremap <silent><localleader>dtp :TSPlaygroundToggle<CR>
