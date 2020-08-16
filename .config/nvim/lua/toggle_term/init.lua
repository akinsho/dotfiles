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
local term_ft = 'toggleterm'
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
  local has_open = find_first_open_window()
  if has_open then
    vim.cmd('vsp')
  else
    vim.cmd(size .. 'sp')
    -- move horizontal split to the bottom
    vim.cmd('wincmd J')
  end
end

--- @param win_id number
function find_window(win_id)
  return fn.win_gotoid(win_id) > 0
end

--- get existing terminal or create an empty term table
--- @param num number
function find_term(num)
  return terminals[num] or create_term()
end

--- Change the directory of the current terminal
--- to vim's cwd/the project root
--- @param term table
function set_directory(term)
  local cwd = fn.getcwd()
  if term.dir ~= cwd then
    fn.chansend(term.job_id, "cd "..cwd.."\n".."clear\n")
    term.dir = cwd
  end
end

--- get the toggle term number from
--- the name e.g. term://~/.dotfiles//3371887:/usr/bin/zsh;#toggleterm#1
--- the number in this case is 1
--- @param name string
function get_number_from_name(name)
  local parts = vim.split(name, '#')
  local num = tonumber(parts[#parts])
  return num
end

--- Find the the first open terminal window
--- by iterating all windows and matching the
--- containing buffers filetype
function find_first_open_window()
  local wins = api.nvim_list_wins()
  local is_open = false
  local term_win
  for _, win in pairs(wins) do
      local buf = api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == term_ft then
        is_open = true
        term_win = win
        break
      end
  end
  return is_open, term_win
end

--- Add terminal buffer specific options
--- @param num number
--- @param bufnr number
--- @param win_id number
function set_opts(num, bufnr, win_id)
  vim.wo[win_id].winfixheight = true
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].filetype = term_ft
  api.nvim_buf_set_var(bufnr, "toggle_number", num)
end

function M.__reparent_term()
  local win = fn.win_getid()
  local is_term = vim.bo.filetype ~= term_ft
  if is_term then return end
  local buf = fn.bufnr()
  local name = fn.bufname()
  local name_matches = string.find(name, term_ft)
  if name_matches then
    print("Setting details")
    local num = get_number_from_name(name)
    set_opts(num, buf, win)
  end
end

--- @param num string
--- @param bufnr string
function add_autocommands(num, bufnr)
  vim.cmd('augroup ToggleTerm'..num)
  vim.cmd('au!')
  vim.cmd(string.format('autocmd TermClose <buffer=%d> lua require"toggle_term".delete(%d)', bufnr, num))
  -- vim.cmd('autocmd WinEnter term://*toggleterm#* lua require"toggle_term".__reparent_term()')
  vim.cmd('augroup END')
end

--- @param bufnr number
function find_windows_by_bufnr(bufnr)
  return fn.win_findbuf(bufnr)
end

--- @param size number
function smart_toggle(_, size)
  local already_open = find_first_open_window()
  if not already_open then
    M.open(1, size)
  else
    local target = #terminals
    -- count backwards from the end of the list
    for i = #terminals, 1, -1 do
      local term = terminals[i]
      local wins = find_windows_by_bufnr(term.bufnr)
      if table.getn(wins) > 0 then
        target = i
        break
      end
    end
    M.close(target)
  end
end

--- @param num number
--- @param size number
function toggle_nth_term(num, size)
  local term = find_term(num)
  if find_window(term.window) then
    M.close(num)
  else
    M.open(num, size)
  end
end

function M.on_term_open()
  local title = fn.bufname()
  local num = get_number_from_name(title)
  if not terminals[num] then
    local term = create_term()
    term.bufnr = fn.bufnr()
    term.window = fn.win_getid()
    term.job_id = vim.b.terminal_job_id
    terminals[num] = term

    vim.cmd("resize "..default_size)
    set_opts(num, term.bufnr, term.window)
  end
end

---@param num string
function M.delete(num)
  if terminals[num] then terminals[num] = nil end
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

    local name = vim.o.shell..';#'..term_ft..'#'..num
    term.job_id = fn.termopen(name, { detach = 1 })

    add_autocommands(num, term.bufnr)
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

--- @param num number
function M.close(num)
  local term = find_term(num)
  if find_window(term.window) then
    vim.cmd('hide')
  else if num then
      vim.cmd(string.format('echoerr "Failed to close window: %d does not exist"', num))
    else
      print(vim.inspect(num))
      vim.cmd('echoerr "Failed to close window: invalid term number"')
    end
  end
end

--- If a count is provided we operate on the specific terminal buffer
--- i.e. 2ToggleTerm => open or close Term 2
--- if the count is 1 we use a heuristic which is as follows
--- if there is no open terminal window we toggle the first one i.e. assumed
--- to be the primary. However if several are open we close them.
--- this can be used with the count commands to allow specific operations
--- per term or mass actions
--- @param count number
--- @param size number
function M.toggle(count, size)
  vim.validate{
    count={count, 'number', true},
    size={size, 'number', true},
  }
  if count > 1 then
    toggle_nth_term(count, size)
  else
    smart_toggle(count, size)
  end
end

function M.introspect()
  print('All terminals: '..vim.inspect(terminals))
end

return M
