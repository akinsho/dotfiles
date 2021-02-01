return function()
  local map = as_utils.map
  -----------------------------------------------------------------------------//
  -- Abolish
  -----------------------------------------------------------------------------//
  -- Find and Replace Using Abolish Plugin %S - Subvert
  -----------------------------------------------------------------------------//
  map("n", "<localleader>[", ":S/<C-R><C-W>//<LEFT>")
  map("n", "<localleader>]", ":%S/<C-r><C-w>//c<left><left>")
  map("v", "<localleader>[", [["zy:%S/<C-r><C-o>"//c<left><left>]])
end
