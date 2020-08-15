----------------------------------------------------------------------------------
-- Async Job
----------------------------------------------------------------------------------
-- inspiration: https://stackoverflow.com/questions/48709262/neovim-fugitive-plugin-gpush-locking-up

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
-- TODO reproduce in lua
-- func! s:open_preview(size) abort
--   let s:shell_tmp_output = tempname()
--   execute 'pedit '.s:shell_tmp_output
--   wincmd P
--   wincmd J
--   execute('resize '. a:size)
--   setlocal modifiable
--   setlocal nobuflisted
--   setlocal winfixheight
--   setlocal nolist
--   nnoremap <silent><nowait><buffer>q :bd<cr>
--   nnoremap <silent><nowait><buffer><CR> :bd<cr>
-- endfunc

-- function! s:close_preview_window() abort
--   normal! G
--   setlocal nomodifiable
--   setlocal nomodified
--   " return to original window
--   " wincmd p
-- endfunction

-- function! s:echo(msgs) abort
--   let msg = join(a:msgs, '\n')
--   echohl MoreMsg
--   " double quote message so \n is interpolated
--   " https://stackoverflow.com/questions/13435586/should-i-use-single-or-double-quotes-in-my-vimrc-file
--   echom a:msgs
--   execute('echo "'.shellescape(msg).'"')
--   echohl clear
-- endfunction

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

--- @param buf_id number
--- @param hl string
--- @param lines table
function add_highlight(buf_id, hl, lines)
  local namespace_id = api.nvim_create_namespace('async-job')
  for _, line in ipairs(lines) do
    api.nvim_buf_add_highlight(
      buf_id,
      namespace_id,
      hl,
      line.number,
      line.column_start,
      line.column_end
    )
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
function open_window(job, code)
    local width = 60
    local height = 15
    local statusline_padding = 2
    local row = vim.o.lines - vim.o.cmdheight - statusline_padding

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
    local highlight = code > 0 and 'Error' or 'Question'

    add_highlight(buf, highlight, {
        {number = 0, column_end = -1, column_start = 0},
        {number = 1, column_end = -1, column_start = 0},
        {number = 2, column_end = -1, column_start = 0},
      })
    local win = api.nvim_open_win(buf, false, opts)
    api.nvim_buf_set_option(buf, 'modifiable', false)

    return win
end

---@param msg string
---@param hl string
function echo(msg, hl)
  vim.cmd("echohl ".. hl)
  vim.cmd("echom ".. vim.fn.shellescape(msg))
  vim.cmd("echohl clear")
end

--- @param job table
function handle_result(job, code, auto_close)
  local num_of_lines = table.getn(job.data)
  if num_of_lines > vim.o.cmdheight then
    local win_id = open_window(job, code)

    if code == 0 and auto_close then -- only automatically close window if successful
      vim.defer_fn(function()
        api.nvim_win_close(win_id, true)
      end, 10000)
    end
  else
    local default_msg = job.cmd
    if code > 0 then
      default_msg = default_msg .. ' exited with code: '.. code
    else
      default_msg = default_msg .. ' completed successfully'
    end
    local msg = num_of_lines > 0 and table.concat(job.data, '\n') or default_msg
    echo(msg, "Title")
  end
  jobs[job.pid] = nil
end

--- @param cmd string
--- @param count number
function M.exec(cmd, count)
  local auto_close = true
  if type(count) == "number" then
    auto_close = false
  end
  local parts = vim.split(cmd, " ")
  local program = parts[1]

  local handle
  local stdout = luv.new_pipe(false)
  local stderr = luv.new_pipe(false)

  handle, pid = luv.spawn(program, {
      args = {unpack(parts, 2)},
      stdio = {stdout, stderr}
  }, vim.schedule_wrap(function (code, _) -- signal is the second argument
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      handle:close()
      code = code or 0
      handle_result(jobs[pid], code, auto_close)
  end))

  jobs[pid] = {
    cmd = cmd,
    pid = pid,
    data = {},
  }

  ---@param err table
  ---@param data table
  local handle_read = function (err, data)
    on_read(jobs[pid], err, data)
  end
  luv.read_start(stdout,  handle_read)
  luv.read_start(stderr, handle_read)
end

function M.introspect()
  print("Existing jobs -> "..vim.inspect(jobs))
  return jobs
end

return M
