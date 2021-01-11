return function()
  local map = as_utils.map
  require("bufferline").setup {
    options = {
      mappings = true,
      sort_by = "extension",
      separator_style = "slant"
    }
  }

  map("n", "gb", [[<cmd>BufferLinePick<CR>]])
  map("n", "<leader><tab>", [[<cmd>BufferLineCycleNext<CR>]])
  map("n", "<S-tab>", [[<cmd>BufferLineCyclePrev<CR>]])
  map("n", "[b", [[<cmd>BufferLineMoveNext<CR>]])
  map("n", "]b", [[<cmd>BufferLineMovePrev<CR>]])
end
