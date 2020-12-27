if not plugin_loaded("nvim-bufferline.lua") then
  return
end

local api = vim.api

require("bufferline").setup {
  options = {
    mappings = true,
    sort_by = "extension",
    separator_style = "slant"
  }
}

local opts = {noremap = true, silent = true}
api.nvim_set_keymap("n", "gb", [[<cmd>BufferLinePick<CR>]], opts)
api.nvim_set_keymap("n", "<leader><tab> ", [[<cmd>BufferLineCycleNext<CR>]], opts)
api.nvim_set_keymap("n", "<S-tab>", [[<cmd>BufferLineCyclePrev<CR>]], opts)
api.nvim_set_keymap("n", "[b", [[<cmd>BufferLineMoveNext<CR>]], opts)
api.nvim_set_keymap("n", "]b", [[<cmd>BufferLineMovePrev<CR>]], opts)
