----------------------------------------------------------------------------------
-- Async Job
----------------------------------------------------------------------------------
-- inspiration: https://stackoverflow.com/questions/48709262/neovim-fugitive-plugin-gpush-locking-up

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

--- We don't use stderr since it doesn seem like it is a trustworthy
--- sign of a true error given that programs like git tend to write
--- non error message to stderr
--- @param job string
--- @param _ boolean
--- @param data table
function on_read(job, _, data)
  if data then
    if not job then
      api.nvim_err_writeln(msg_prefix..'failed to find existing job with id '..job)
      return
    end
    for _, value in ipairs(data) do
      table.insert(job.data, value)
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
    formatted[i] = " " .. item .. " "
  end
  return vim.list_extend({top, mid, bot}, formatted)
end

--- @param job table
function open_window(job, code)
    local width = 60
    local header_size = 3
    local num_lines = table.getn(job.data)
    local height =  num_lines < 15 and num_lines + header_size or 15
    local statusline_padding = 2
    local row = vim.o.lines - vim.o.cmdheight - statusline_padding

    for _, line in pairs(job.data) do
        local line_length = string.len(line)
        if line_length > width and line_length < vim.o.columns / 2 then
          width = string.len(line) + 2
        end
    end
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
    local highlight = code > 0 and 'Identifier' or 'Question'

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
  vim.cmd("echo ".. vim.fn.shellescape(msg))
  vim.cmd("echohl clear")
end

--- @param job table
function handle_result(job, code, auto_close)
  local num_of_lines = table.getn(job.data)
  -- if the output is more than a few lines longer than
  -- the command msg area open a window
  if num_of_lines > vim.o.cmdheight + 2 then
    local win_id = open_window(job, code)
    -- only automatically close window if successful
    local timeout = code == 0 and 10000 or 15000
    if auto_close then
      vim.defer_fn(function()
        api.nvim_win_close(win_id, true)
      end, timeout)
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
--- @param count number @comment count's default is 0
function M.exec(cmd, count)
  local auto_close = true
  if type(count) == "number" and count > 0 then
    auto_close = false
  end

  ---@param pid number
  ---@param data table
  ---@param name string
  local handle_read = function (pid, data, name)
    if name == 'stdout' then
      on_read(jobs[pid], false, data)
    else
      on_read(jobs[pid], true, data)
    end
  end

  ---@param pid number
  ---@param code number
  ---@param _ string
  function handle_exit(pid, code, _)
      code = code or 0
      handle_result(jobs[pid], code, auto_close)
  end

  local pid = vim.fn.jobstart(cmd, {
      on_stdout = handle_read,
      on_stderr = handle_read,
      on_exit = handle_exit,
    })

  jobs[pid] = {
    cmd = cmd,
    pid = pid,
    data = {},
  }
end

function M.introspect()
  print("Existing jobs -> "..vim.inspect(jobs))
  return jobs
end

return M
