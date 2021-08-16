local M = {}

local fmt = string.format
local fn = vim.fn
local is_work = as.has 'mac'
local is_home = not is_work

---@param path string
function M.dev(path)
  return os.getenv 'HOME' .. '/projects/' .. path
end

function M.developing()
  return vim.env.DEVELOPING ~= nil
end

function M.not_developing()
  return not vim.env.DEVELOPING
end

--- Automagically register local and remote plugins as well as managing when they are enabled or disabled
--- 1. Local plugins that I created should be used but specified with their git URLs so they are
--- installed from git on other machines
--- 2. If DEVELOPING is set to true then local plugins I contribute to should be loaded vs their
--- remote counterparts
---@param spec table
function M.with_local(spec)
  assert(type(spec) == 'table', fmt('spec must be a table', spec[1]))
  assert(spec.local_path, fmt('%s has no specified local path', spec[1]))

  local name = vim.split(spec[1], '/')[2]
  local path = M.dev(fmt('%s/%s', spec.local_path, name))
  if fn.isdirectory(fn.expand(path)) < 1 then
    return spec, nil
  end
  local is_contributing = spec.local_path:match 'contributing' ~= nil

  local local_spec = {
    path,
    config = spec.config,
    setup = spec.setup,
    rocks = spec.rocks,
    as = fmt('local-%s', name),
    cond = is_contributing and M.developing or spec.local_cond,
    disable = is_work or spec.local_disable,
  }

  spec.disable = not is_contributing and is_home or false
  spec.cond = is_contributing and M.not_developing or nil

  --- swap the keys and event if we are currently developing
  if is_contributing and M.developing() and spec.keys or spec.event then
    local_spec.keys, local_spec.event, spec.keys, spec.event = spec.keys, spec.event, nil, nil
  end

  spec.event = not M.developing() and spec.event or nil
  spec.local_path = nil
  spec.local_cond = nil
  spec.local_disable = nil

  return spec, local_spec
end

---local variant of packer's use function that specifies both a local and
---upstream version of a plugin
---@param original table
function M.use_local(original)
  local use = require('packer').use
  local spec, local_spec = M.with_local(original)
  if local_spec then
    use(local_spec)
  end
  use(spec)
end

---Require a plugin config
---@param name string
---@return any
function M.conf(name)
  return require(fmt('as.plugins.%s', name))
end

return M
