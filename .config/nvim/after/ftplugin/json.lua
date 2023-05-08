local api = vim.api
local map = map or vim.keymap.set

map('n', 'o', function()
  local line = api.nvim_get_current_line()
  return line:find('[^,{[]$') and 'A,<cr>' or 'o'
end, { buffer = 0, expr = true })

if as then
  as.ftplugin_conf({
    ['package-info'] = function(package_info)
      local name = api.nvim_buf_get_name(0)
      if name:match('package%.json') then
        map('n', '<leader>ni', package_info.install, { silent = true, noremap = true })
      end
    end,
  })
end
