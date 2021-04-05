--- Global treesitter object containing treesitter related utilities
as_utils.ts = {}

---Get all filetypes for which we have a treesitter parser installed
---@return string[]
function as_utils.ts.get_filetypes()
  local parsers = require("nvim-treesitter.parsers")
  local configs = parsers.get_parser_configs()
  return vim.tbl_map(
    function(ft)
      return configs[ft].filetype or ft
    end,
    parsers.available_parsers()
  )
end

return function()
  vim.cmd [[highlight link TSKeyword Statement]]
  vim.cmd [[highlight TSParameter gui=italic,bold]]

  require("nvim-treesitter.configs").setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
      disable = {"json"}
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- mappings for incremental selection (visual mappings)
        init_selection = ",v", -- maps in normal mode to init the node/scope selection
        node_incremental = ",v", -- increment to the upper named parent
        scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
        node_decremental = "grm" -- decrement to the previous node
      }
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner"
        }
      }
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = {"BufWrite", "CursorHold"}
    }
  }

  -- Only apply folding to supported files:
  require("as.autocommands").augroup(
    "TreesitterFolds",
    {
      {
        events = {"FileType"},
        targets = as_utils.ts.get_filetypes(),
        command = "setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()"
      }
    }
  )
end
