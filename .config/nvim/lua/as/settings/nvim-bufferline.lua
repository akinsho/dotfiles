if not as_utils.plugin_loaded("nvim-bufferline.lua") then
  return
end

require("bufferline").setup {
  options = {
    mappings = true,
    sort_by = "extension",
    separator_style = "slant"
  }
}

as_utils.map("n", "gb", [[<cmd>BufferLinePick<CR>]])
as_utils.map("n", "<leader><tab> ", [[<cmd>BufferLineCycleNext<CR>]])
as_utils.map("n", "<S-tab>", [[<cmd>BufferLineCyclePrev<CR>]])
as_utils.map("n", "[b", [[<cmd>BufferLineMoveNext<CR>]])
as_utils.map("n", "]b", [[<cmd>BufferLineMovePrev<CR>]])
