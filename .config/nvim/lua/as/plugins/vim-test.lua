return function ()
  local map = as_utils.map
  vim.cmd [[let test#strategy = "neovim"]]
  vim.cmd [[let test#neovim#term_position = "vert botright"]]
  map("n", "<localleader>tf", "<cmd>TestFile<CR>")
  map("n", "<localleader>tn", "<cmd>TestNearest<CR>")
  map("n", "<localleader>ts", "<cmd>TestSuite<CR>")
end
