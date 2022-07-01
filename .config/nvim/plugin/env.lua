local api = vim.api
local fn = vim.fn
local fmt = string.format

local function read_file(file, line_handler)
  for line in io.lines(file) do
    line_handler(line)
  end
end

api.nvim_create_user_command('DotEnv', function()
  local dir = fn.getcwd()
  local sep, env_file = '/', '.env'
  local filename = dir .. sep .. env_file
  if fn.filereadable(filename) == 0 then
    return
  end
  local lines = {}
  read_file(filename, function(line)
    if #line > 0 then
      table.insert(lines, line)
    end
    if not vim.startswith(line, '#') then
      local name, value = unpack(vim.split(line, '='))
      fn.setenv(name, value)
    end
  end)
  local markdown = table.concat(vim.tbl_flatten({"", '```sh', lines, '```', "" }), '\n')
  vim.notify(fmt('Read **%s**\n', filename) .. markdown, 'info', {
    title = 'Nvim Env',
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    end,
  })
end, {})
