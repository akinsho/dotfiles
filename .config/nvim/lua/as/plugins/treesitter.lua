return function()
  local has = vim.fn.has

  vim.cmd [[highlight link TSKeyword Statement]]
  vim.cmd [[highlight TSParameter gui=italic,bold]]

  -- This plugin is an experimental application of tree sitter usage in Neovim
  -- be careful when applying any functionality to a filetype as it might not work
  local disabled = {"json"}
  if has("mac") > 0 then
    table.insert(disabled, "dart")
  end

  require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
      disable = disabled
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = "g<enter>", -- maps in normal mode to init the node/scope selection
        node_incremental = "g<enter>", -- increment to the upper named parent
        scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
        node_decremental = "grm" -- decrement to the previous node
      }
    },
    rainbow = {
      enable = false,
      disable = {"lua"}
    }
  }

  -- Only apply folding to supported files, inspired by:
  local parsers = require "nvim-treesitter.parsers"
  local configs = parsers.get_parser_configs()
  local ft_str =
    table.concat(
    vim.tbl_map(
      function(ft)
        return configs[ft].filetype or ft
      end,
      parsers.available_parsers()
    ),
    ","
  )

  vim.cmd(
    "autocmd! Filetype " ..
      ft_str .. " setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()"
  )
end
