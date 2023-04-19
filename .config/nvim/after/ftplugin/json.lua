local api = vim.api
local map = map or vim.keymap.set

map('n', 'o', function()
  local line = api.nvim_get_current_line()
  return line:find('[^,{[]$') and 'A,<cr>' or 'o'
end, { buffer = true, expr = true })
