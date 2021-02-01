return function()
  vim.g.tmux_navigator_no_mappings = 1
  local map = as_utils.map
  map("n", "<C-H>", "<cmd>TmuxNavigateLeft<cr>")
  map("n", "<C-J>", "<cmd>TmuxNavigateDown<cr>")
  map("n", "<C-K>", "<cmd>TmuxNavigateUp<cr>")
  map("n", "<C-L>", "<cmd>TmuxNavigateRight<cr>")
  -- Disable tmux navigator when zooming the Vim pane
  vim.g.tmux_navigator_disable_when_zoomed = 1
  vim.g.tmux_navigator_save_on_switch = 2
end
