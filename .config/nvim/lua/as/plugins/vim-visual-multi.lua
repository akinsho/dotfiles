return function()
  vim.g.VM_highlight_matches = "underline"
  vim.g.VM_theme = "iceblue"
  vim.g.VM_maps = {
    ["Find Under"] = "<C-e>",
    ["Find Subword Under"] = "<C-e>",
    ["Select Cursor Down"] = [[\j]],
    ["Select Cursor Up"] = [[\k]]
  }
end
