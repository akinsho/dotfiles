local api = vim.api
local fn = vim.fn
-----------------------------------------------------------
-- Export
-----------------------------------------------------------
local M = {}

-----------------------------------------------------------
-- Constants
-----------------------------------------------------------
local default_size = 12
-----------------------------------------------------------
-- State
-----------------------------------------------------------
local terminals = {}

function create_term()
  local no_of_terms = table.getn(terminals)
  local next_num = no_of_terms == 0 and 1 or no_of_terms + 1
  return {
    window = -1,
    job_id = -1,
    bufnr = -1,
    dir = vim.fn.getcwd(),
    number = next_num,
  }
end

---@param size number
function open_split(size)
  vim.cmd(size..'sp')
  vim.cmd('wincmd J')
end

---@param win_id number
function find_window(win_id)
  return fn.win_gotoid(win_id) > 0
end

function find_term(num)
  return terminals[num] or create_term()
end

---@param term table
function set_directory(term)
  local cwd = fn.getcwd()
  if term.dir ~= cwd then
    fn.chansend(term.job_id, "cd "..cwd.."\n".."clear\n")
    term.dir = cwd
  end
end

---@param num number
---@param size number
function M.open(num, size)
  size = size or default_size
  local term = find_term(num)

  if vim.fn.bufexists(term.bufnr) == 0 then
    open_split(size)
    term.window = fn.win_getid()
    term.bufnr = api.nvim_create_buf(false, false)
    api.nvim_set_current_buf(term.bufnr)
    api.nvim_win_set_buf(term.window, term.bufnr)
    term.job_id = fn.termopen(vim.o.shell..';#toggleterm', { detach = 1 })
    vim.b.filetype = 'toggleterm'
    vim.b.winfixwidth = true
    vim.b.winfixheight = true
    terminals[num] = term
  else
    open_split(size)
    vim.cmd('keepalt buffer '..term.bufnr)
    vim.b.winfixwidth = true
    vim.b.winfixheight = true
    set_directory(term)
    term.window = fn.win_getid()
  end
end

function M.exec(cmd, size)
end

function M.close(num)
  local term = find_term(num)
  if find_window(term.window) then
    vim.cmd('hide')
  end
end

function M.toggle(num, size)
  local term = find_term(num)
  if find_window(term.window) then
    M.close(num)
  else
    M.open(num, size)
  end
end

function M.introspect()
  print('All terminals: '..vim.inspect(terminals))
end

return M
