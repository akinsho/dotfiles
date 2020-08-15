local luv = vim.loop
local api = vim.api

local msg_prefix = "[Async job]: "
-----------------------------------------------------------
-- Export
-----------------------------------------------------------
local M = {}

-----------------------------------------------------------
-- State
-----------------------------------------------------------
local jobs = {}

-----------------------------------------------------------
-- Functions
-----------------------------------------------------------
--- @param job string
--- @param err string
--- @param data table
function on_read(job, err, data)
  if err then
    vim.schedule_wrap(function()
      api.nvim_err_writeln(err)
    end)
  end
  if data then
    if not job then
      vim.schedule_wrap(function()
        api.nvim_err_writeln(msg_prefix..'failed to find existing job with id '..pid)
      end)
      return
    end
    local vals = vim.split(data, "\n")
    for _, value in pairs(vals) do
      if value == "" then goto continue end
        table.insert(job.data, value)
      ::continue::
    end
  end
end

--- @param title string
--- @param data table
--- @param width number
function format_data(title, data, width)
  local formatted = vim.deepcopy(data)
  -- If title is too long it should be truncated
  local remainder = width - string.len(title)
  local side_size = math.floor(remainder / 2) - 1
  local side = string.rep(" ", side_size)
  local heading = side .. title ..side
  if string.len(heading) ~= width - 2 then
    local offset = (width - 2) - string.len(heading)
    heading = heading .. string.rep(" ", offset)
  end
  local top = "╭" .. string.rep("─", width - 2) .. "╮"
  local mid = "│" ..         heading            .. "│"
  local bot = "╰" .. string.rep("─", width - 2) .. "╯"

  for i, item in ipairs(formatted) do
      formatted[i] = " " .. item
  end
  return vim.list_extend({top, mid, bot}, formatted)
end

--- @param job table
function open_window(job)
    local width = 60
    local height = 15
    local row = vim.o.lines - vim.o.cmdheight - 1

    local data = format_data(job.cmd, job.data, width)

    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buf, 0, -1, false, data)
    local opts = {
      relative = 'editor',
      width = width,
      height = height,
      col = vim.o.columns,
      row = row,
      anchor = 'SE',
      style = 'minimal'
    }
    local win = api.nvim_open_win(buf, 0, opts)

    vim.cmd('setlocal nomodifiable')
    return win
end

--- @param job table
function handle_result(job)
  if table.getn(job.data) > 1 then
    open_window(job)
  else
    api.nvim_out_write(table.concat(job.data, '\n'))
  end
  jobs[job.pid] = nil
end

--- @param cmd string
function M.exec(cmd)
  local parts = vim.split(cmd, " ")
  local program = table.remove(parts, 1)
  local handle
  local stdout = luv.new_pipe(false)
  local stderr = luv.new_pipe(false)
  handle, pid = luv.spawn(program, {
      args = parts,
      stdio = {stdout, stderr}
  },vim.schedule_wrap(function ()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      handle:close()
      handle_result(jobs[pid])
  end))

  jobs[pid] = {
    cmd = cmd,
    pid = pid,
    data = {},
  }

  local handle_read = function (err, data)
    on_read(jobs[pid], err, data)
  end
  luv.read_start(stdout,  handle_read)
  luv.read_start(stderr, handle_read)
end

function M.introspect()
  print("Existing jobs ->"..vim.inspect(jobs))
  return jobs
end

return M
