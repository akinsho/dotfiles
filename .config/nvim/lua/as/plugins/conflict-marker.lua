return function()
  -- disable the default highlight group
  vim.g.conflict_marker_highlight_group = ""
  -- Include text after begin and end markers
  vim.g.conflict_marker_begin = "^<<<<<<< .*$"
  vim.g.conflict_marker_end = "^>>>>>>> .*$"
end
