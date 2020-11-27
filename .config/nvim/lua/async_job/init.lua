----------------------------------------------------------------------------------
-- Async Job
----------------------------------------------------------------------------------
-- inspiration: https://stackoverflow.com/questions/48709262/neovim-fugitive-plugin-gpush-locking-up

local api = vim.api

local msg_prefix = "[Async job]: "

--- current regex is hacked out of vim-highlighturl
local url_regex =
  [[\v\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%(]] ..
  [[[&:#*@~%_\-=?!+;/0-9A-Za-z]+%(%([.,;/?]|[.][.]+)[&:#*@~%_\-=?!+/0-9A-Za-z]+|:\d+)*|]] ..
    [[\([&:#*@~%_\-=?!+;/.0-9A-Za-z]*\)|\[[&:#*@~%_\-=?!+;/.0-9A-Za-z]*\]|]] ..
      [[\{%([&:#*@~%_\-=?!+;/.0-9A-Za-z]*|\{[&:#*@~%_\-=?!+;/.0-9A-Za-z]*\})\})+]]
-----------------------------------------------------------
-- Export
-----------------------------------------------------------
local M = {}

-----------------------------------------------------------
-- State
-----------------------------------------------------------
local jobs = {}
local last_open_window = -1

--- We don't use stderr since it doesn seem like it is a trustworthy
--- sign of a true error given that programs like git tend to write
--- non error message to stderr
--- @param job string
--- @param _ boolean
--- @param data table
local function on_read(job, _, data)
  if data then
    if not job then
      api.nvim_err_writeln(
        msg_prefix .. "failed to find existing job with id " .. job
      )
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
local function add_highlight(buf_id, hl, lines)
  local namespace_id = api.nvim_create_namespace("async-job")
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

--- @param data table
local function format_data(data)
  local formatted = {}
  for _, item in ipairs(data) do
    table.insert(formatted, " " .. item .. " ")
  end
  return formatted
end

local function publish_events(is_git_cmd)
  if is_git_cmd then
    vim.cmd("doautocmd User AsyncGitJobComplete")
  else
    vim.cmd("doautocmd User AsyncJobComplete")
  end
end

-- TODO find a way to dismiss oldest window if messages collide
--- @param job table
local function open_window(job, code)
  local width = 60
  local statusline_padding = 2
  local row = vim.o.lines - vim.o.cmdheight - statusline_padding
  if last_open_window > -1 then
    local config = api.nvim_win_get_config(last_open_window)
    row = row - config.height - 1
  end

  for _, line in pairs(job.data) do
    local line_length = string.len(line)
    if line_length > width and line_length < vim.o.columns / 2 then
      width = string.len(line) + 2
    end
  end
  local data = format_data(job.data)

  local title = job.cmd
  -- If title is too long it should be truncated
  local remainder = width - 1 - string.len(title)
  local side_size = math.floor(remainder) - 1
  local side = string.rep("═", side_size)
  local heading = title .. side

  local height = #data < 15 and #data or 15

  local top = "╔" .. heading .. "╗"
  local content = {top}
  local padding = string.rep(" ", width - 2)
  for _ = 1, height do
    table.insert(content, "║" .. padding .. "║")
  end
  local bot = "╚" .. string.rep("═", width - 2) .. "╝"
  table.insert(content, bot)

  height = #content

  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, content)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = vim.o.columns,
    row = row,
    anchor = "SE",
    style = "minimal",
    focusable = false
  }
  local highlight = code > 0 and "Identifier" or "Question"

  add_highlight(
    buf,
    highlight,
    {
      {number = 0, column_end = #title + 3, column_start = 3}
    }
  )
  local parent_win = api.nvim_open_win(buf, false, opts)
  vim.wo[parent_win].winblend = 10

  opts.row = opts.row - 1
  opts.height = opts.height - 2
  opts.col = opts.col - 2
  opts.width = opts.width - 4
  opts.focusable = true

  local child = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(child, 0, -1, false, data)
  api.nvim_buf_set_option(child, "modifiable", false)

  local child_win = api.nvim_open_win(child, true, opts)
  vim.cmd(
    string.format(
      [[au BufWipeout,WinClosed <buffer=%d> exe 'bw %d']],
      child,
      buf
    )
  )
  vim.wo[child_win].wrap = true
  vim.wo[child_win].winblend = 10

  -- we need to place the cursor in the window to make sure it is
  -- brought to the foreground but a naked wincmd doesn't work to
  -- restore focus so we defer the call
  vim.defer_fn(
    function()
      vim.cmd("wincmd p")
    end,
    1
  )

  last_open_window = parent_win
  return child_win
end

---@param msg string
---@param hl string
local function echo(msg, hl)
  vim.cmd("echohl " .. hl)
  vim.cmd("echo " .. vim.fn.shellescape(msg))
  vim.cmd("echohl clear")
end

local function save_urls(lines)
  local matches = {}
  for _, line in ipairs(lines) do
    local url = vim.fn.matchstr(line, url_regex)
    if url ~= "" then
      table.insert(
        matches,
        {
          module = "Async Job ",
          text = url,
          pattern = "URL",
          valid = false
        }
      )
    end
  end
  if #matches > 0 then
    vim.fn.setqflist(matches)
    vim.cmd(":copen")
  end
end

local function reload_fugitive()
  -- if this was a git related command reload the vim fugitive status buffer
  -- for alternatives consider using windo
  -- https://github.com/wookayin/dotfiles/commit/5c7ab2347c8e46b3980c0f6a51fe6477ad8675ba
  if vim.fn.exists("*fugitive#ReloadStatus") > 0 then
    vim.fn["fugitive#ReloadStatus"]()
  end
end

--- @param job table
local function handle_result(job, code, auto_close)
  local num_of_lines = #job.data
  -- if the output is more than a few lines longer than
  -- the command msg area open a window
  if num_of_lines > vim.o.cmdheight + 2 then
    local win_id = open_window(job, code)
    -- only automatically close window if successful
    local timeout = code == 0 and 3000 or 15000
    if auto_close then
      vim.defer_fn(
        function()
          -- clear the last open window
          last_open_window = -1
          api.nvim_win_close(win_id, true)
          if code <= 0 then
            local is_git_cmd = job.cmd:match("git")
            publish_events(is_git_cmd)
            if is_git_cmd then
              reload_fugitive()
            end
          end
          save_urls(job.data)
        end,
        timeout
      )
    end
  else
    local default_msg = job.cmd
    if code > 0 then
      default_msg = default_msg .. " exited with code: " .. code
    else
      default_msg = default_msg .. " completed successfully"
    end
    local msg = num_of_lines > 0 and table.concat(job.data, "\n") or default_msg
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
  local handle_read = function(pid, data, name)
    if name == "stdout" then
      on_read(jobs[pid], false, data)
    else
      on_read(jobs[pid], true, data)
    end
  end

  ---@param pid number
  ---@param code number
  ---@param _ string
  local function handle_exit(pid, code, _)
    code = code or 0
    handle_result(jobs[pid], code, auto_close)
  end

  local pid =
    vim.fn.jobstart(
    cmd,
    {
      on_stdout = handle_read,
      on_stderr = handle_read,
      on_exit = handle_exit
    }
  )

  jobs[pid] = {
    cmd = cmd,
    pid = pid,
    data = {}
  }
  return pid
end

---@param pid number
function M.wait(pid)
  return vim.fn.jobwait({pid})
end

---@param cmds table<string>
function M.execSync(cmds)
  for _, cmd in ipairs(cmds) do
    local pid = M.exec(cmd, 0)
    local result = M.wait(pid)
    if result[1] > 0 then
      local err_cmd = string.format('echoerr "Failed to complete task %s"', cmd)
      local escaped_cmd = string.format("%q", err_cmd)
      vim.cmd(escaped_cmd)
      return
    end
  end
end

function M.introspect()
  print("Existing jobs -> " .. vim.inspect(jobs))
  return jobs
end

return M
