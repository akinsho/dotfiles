local uv = vim.loop
local fmt = string.format
local levels = vim.log.levels

local sep = '/'
local default_target = '.localrc.lua'

local found_rc = nil

local function notify(msg, level, delay)
  vim.defer_fn(function()
    vim.notify(msg, level, delay)
  end, delay or 200)
end

local function reload(path)
  vim.cmd('luafile ' .. path)
  notify('Reloaded ' .. path)
end

local function open()
  if found_rc then
    vim.cmd('vsplit ' .. found_rc)
  else
    notify 'No LocalRC found'
  end
end

local function get_parent(str)
  local parts = vim.split(str, '[/\\]')
  parts[#parts] = nil
  return table.concat(parts, sep)
end

local function setup_localrc(path)
  as.augroup('LocalRC', {
    {
      event = { 'BufWritePost' },
      pattern = { path },
      command = function()
        reload(path)
      end,
    },
  })
end

local function load_rc(path)
  local stat = uv.fs_stat(path)
  -- check if we own the localrc file before opening it
  if stat and stat.uid ~= uv.getuid() then
    return notify(
      fmt('Found localrc at %s but not opening it as it is owned by someone else', path),
      vim.log.levels.WARN
    )
  end
  local success, msg = pcall(dofile, path)
  if success then
    setup_localrc(path)
  end
  local message = success and 'Successfully loaded ' .. vim.fn.fnamemodify(path, ':~:.')
    or 'Failed to load because: ' .. msg
  notify(message)
end

---@param path string|nil
---@param target string|nil
local function load(path, target)
  path = path and #path > 0 and path or vim.fn.getcwd()
  target = target or default_target

  local found
  local is_home = path == os.getenv 'HOME'
  if is_home then
    return
  end

  local dir, err = uv.fs_opendir(path)
  if not dir and err then
    return notify(fmt('[Local init @ %s failed]: %s', path, err), levels.Error)
  end
  repeat
    local entry = uv.fs_readdir(dir)
    if entry then
      for _, item in ipairs(entry) do
        if item and item.name == target then
          found = item
          assert(uv.fs_closedir(dir), 'unable to close directory ' .. path)
        end
      end
    end
  until not entry or found
  if found then
    local rc_path = path .. sep .. found.name
    found_rc = rc_path
    load_rc(rc_path)
  elseif not is_home then
    load(get_parent(path), target)
  end
end

as.augroup('LoadLocalInit', {
  {
    event = { 'VimEnter' },
    pattern = { '*' },
    command = function()
      load()
    end,
  },
})

as.command { 'LocalrcEdit', open }
