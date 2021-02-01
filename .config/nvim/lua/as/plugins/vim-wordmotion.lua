return function()
  vim.g.wordmotion_spaces = "_-."
  -- Restore Vim's special case behavior with dw and cw:
  local opts = {silent = true, noremap = false}
  local map = as_utils.map
  map("n", "dw", "de", opts)
  map("n", "cw", "ce", opts)
  map("n", "dW", "dE", opts)
  map("n", "cW", "cE", opts)
end
