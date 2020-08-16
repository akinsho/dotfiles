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

--- @param size number
function open_split(size)
  local has_open = term_is_open()
  local split_cmd = has_open and 'vsp' or size .. 'sp'
  vim.cmd(split_cmd)
end

--- @param win_id number
function find_window(win_id)
  return fn.win_gotoid(win_id) > 0
end

function find_term(num)
  return terminals[num] or create_term()
end

--- @param term table
function set_directory(term)
  local cwd = fn.getcwd()
  if term.dir ~= cwd then
    fn.chansend(term.job_id, "cd "..cwd.."\n".."clear\n")
    term.dir = cwd
  end
end

function term_is_open()
  local wins = api.nvim_list_wins()
  local is_open = false
  local term_win
  for _, win in pairs(wins) do
      local buf = api.nvim_win_get_buf(win)
      local filetype = api.nvim_buf_get_option(buf, 'filetype')
      if filetype == 'toggleterm' then
        is_open = true
        term_win = win
        break
      end
  end
  return is_open, term_win
end

--- TODO make sure terminal list stays up to date
--- currently not triggering
--- @param num string
function add_autocommands(num)
  vim.cmd('augroup ToggleTerm'..num)
  vim.cmd('au!')
  vim.cmd(string.format('autocmd BufDelete <buffer> lua require"toggle_term".delete(%d)', num))
  vim.cmd('augroup END')
end

function M.on_term_open()
  local title = fn.bufname()
  local parts = vim.split(title, '#')
  local num = tonumber(parts[#parts])
  if not terminals[num] then
    local term = create_term()
    term.bufnr = fn.bufnr()
    term.window = fn.win_getid()
    term.job_id = vim.b.terminal_job_id
    terminals[num] = term

    vim.cmd("resize "..default_size)
    vim.wo[term.window].winfixheight = true
    vim.bo[term.bufnr].buflisted = false
    vim.bo[term.bufnr].filetype = 'toggleterm'
    api.nvim_buf_set_var(term.bufnr, "toggle_number", num)
  end
end

function M.delete(num)
  vim.cmd(string.format('echom "Buffer to delete: %d"', num))
  terminals[num] = nil
end

--- @param num number
--- @param size number
function M.open(num, size)
  vim.validate{num={num, 'number'}, size={size, 'number', true}}

  size = (size and size > 0) and size or default_size
  local term = find_term(num)

  if vim.fn.bufexists(term.bufnr) == 0 then
    open_split(size)
    term.window = fn.win_getid()
    term.bufnr = api.nvim_create_buf(false, false)
    api.nvim_set_current_buf(term.bufnr)
    api.nvim_win_set_buf(term.window, term.bufnr)
    local name = vim.o.shell..';#toggleterm#'..num
    term.job_id = fn.termopen(name, { detach = 1 })
    --- TODO this is duplicating work done in on_term_open but
    --- which one gets called and when is a little unclear
    vim.b.filetype = 'toggleterm'
    vim.wo.winfixheight = true
    api.nvim_buf_set_var(term.bufnr, "toggle_number", num)
    add_autocommands(num)
    terminals[num] = term
  else
    open_split(size)
    vim.cmd('resize '.. size)
    vim.cmd('keepalt buffer '..term.bufnr)
    vim.wo.winfixheight = true
    set_directory(term)
    term.window = fn.win_getid()
  end
end

--- TODO fails on the first call
--- @param cmd string
--- @param num number
--- @param size number
function M.exec(cmd, num, size)
  vim.validate{
    cmd={cmd, "string"},
    num={num, "number"},
    size={size, "number", true},
  }
  local term = find_term(num)
  if not find_window(term.window) then
    M.open(num, size)
  end
  term = find_term(num)
  fn.chansend(term.job_id, "clear".."\n"..cmd.."\n")
  vim.cmd('normal! G')
  vim.cmd('wincmd p')
  vim.cmd('stopinsert!')
end

function M.close(num)
  local term = find_term(num)
  if find_window(term.window) then
    vim.cmd('hide')
  end
end

function M.toggle(num, size)
  vim.validate{num={num, 'number'}, size={size, 'number', true}}
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
