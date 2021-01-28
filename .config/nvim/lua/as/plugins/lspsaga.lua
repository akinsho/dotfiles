return function()
  local saga = require("lspsaga")
  local map = as_utils.map

  saga.init_lsp_saga {
    use_saga_diagnostic_sign = true,
    max_hover_width = 80
  }
  map("n", "gd", "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>")
  map("n", "<leader>ca", [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]])
  map("n", "gh", [[<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>]])
end
