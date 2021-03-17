return function()
  local map = as_utils.map
  local has = as_utils.has
  require("bufferline").setup {
    options = {
      mappings = true,
      sort_by = "extension",
      show_close_icon = false,
      separator_style = "slant",
      diagnostics = not has("mac") and "nvim_lsp" or false,
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end
    }
  }

  map("n", "gb", [[<cmd>BufferLinePick<CR>]])
  map("n", "<leader><tab>", [[<cmd>BufferLineCycleNext<CR>]])
  map("n", "<S-tab>", [[<cmd>BufferLineCyclePrev<CR>]])
  map("n", "[b", [[<cmd>BufferLineMoveNext<CR>]])
  map("n", "]b", [[<cmd>BufferLineMovePrev<CR>]])
end
