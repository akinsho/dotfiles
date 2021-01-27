return function()
  require("compe").setup {
    enabled = true,
    min_length = 1,
    -- preselect = "enable",
    allow_prefix_unmatch = false,
    source = {
      path = true,
      buffer = true,
      vsnip = true,
      nvim_lsp = true,
      nvim_lua = true
    }
  }

  local map = as_utils.map
  local opts = {noremap = true, silent = true, expr = true}
  map("i", "<C-Space>", "compe#complete()", opts)
  map("i", "<CR>", "compe#confirm(lexima#expand('<LT>CR>', 'i'))", opts)
  map("i", "<C-e>", "compe#close('<C-e>')", opts)
end
