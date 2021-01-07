local M = {}
local fn = vim.fn
-- Source: https://teukka.tech/luanvim.html
function M.create(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd("autocmd!")
    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
      vim.cmd(command)
    end
    vim.cmd("augroup END")
  end
end

--- automatically clear commandline messages after a few seconds delay
--- source: https://unix.stackexchange.com/a/613645
local function clear_messages()
  local id
  return function()
    if id then
      fn.timer_stop(id)
    end
    id = fn.timer_start(2000, function()
      if fn.mode() == "n" then
        vim.cmd [[echon '']]
      end
    end)
  end
end

M.clear_messages = clear_messages()

M.create({
  ClearCommandMessages = {
    {"CmdlineLeave", ":","lua require('as.autocommands').clear_messages()"}
  }
})

return M
