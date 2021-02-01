return function()
  local map = as_utils.map
  map("n", "]w", "<cmd>SidewaysLeft<cr>")
  map("n", "[w", "<cmd>SidewaysRight<cr>")

  local opts = {silent = true}
  map("n", "<localleader>si", "<Plug>SidewaysArgumentInsertBefore", opts)
  map("n", "<localleader>sa", "<Plug>SidewaysArgumentAppendAfter", opts)
  map("n", "<localleader>sI", "<Plug>SidewaysArgumentInsertFirst", opts)
  map("n", "<localleader>sA", "<Plug>SidewaysArgumentAppendLast", opts)
  vim.g.sideways_add_item_cursor_restore = 1
end
