return function()
  require("compe").setup {
    source = {
      path = true,
      buffer = {kind = " [Buffer]"},
      vsnip = {priority = 1500, kind = " [Vsnip]"},
      spell = true,
      nvim_lsp = true,
      nvim_lua = true,
      treesitter = true
    }
  }

  local map = as_utils.map
  local opts = {noremap = true, silent = true, expr = true}
  vim.g.lexima_no_default_rules = true
  vim.fn["lexima#set_default_rules"]()
  map("i", "<C-Space>", "compe#complete()", opts)
  map("i", "<CR>", [[compe#confirm(lexima#expand('<LT>CR>', 'i'))]], opts)
  map("i", "<C-e>", "compe#close('<C-e>')", opts)
end
