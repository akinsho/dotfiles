return function()
  vim.g.dsf_no_mappings = 1
  as_utils.map("n", "dsf", "<Plug>DsfDelete", {silent = true, noremap = false})
  as_utils.map("n", "csf", "<Plug>DsfChange", {silent = true, noremap = false})
  as_utils.map("n", "dsnf", "<Plug>DsfNextDelete", {silent = true, noremap = false})
  as_utils.map("n", "csnf", "<Plug>DsfNextChange", {silent = true, noremap = false})
end
