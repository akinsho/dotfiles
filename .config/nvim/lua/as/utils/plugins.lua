local M = {}

local fmt = string.format
local fn = vim.fn
M.is_work = vim.env.WORK ~= nil
M.is_home = not M.is_work

---A thin wrapper around vim.notify to add packer details to the message
---@param msg string
function M.packer_notify(msg, level)
  vim.notify(msg, level, { title = 'Packer' })
end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
-- NOTE: install packer as an opt plugin since it's loaded conditionally on my local machine
-- it needs to be installed as optional so the install dir is consistent across machines
function M.bootstrap_packer()
  local install_path = fmt('%s/site/pack/packer/opt/packer.nvim', fn.stdpath 'data')
  if fn.empty(fn.glob(install_path)) > 0 then
    M.packer_notify 'Downloading packer.nvim...'
    M.packer_notify(
      fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
    )
    vim.cmd 'packadd! packer.nvim'
    require('packer').sync()
  else
    -- FIXME: currently development versions of packer do not work
    -- local name = vim.env.DEVELOPING and 'local-packer.nvim' or 'packer.nvim'
    vim.cmd(fmt('packadd! %s', 'packer.nvim'))
  end
end

function M.not_headless()
  return #vim.api.nvim_list_uis() > 0
end

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
    opt = spec.local_opt,
    as = fmt('local-%s', name),
    cond = is_contributing and M.developing or spec.local_cond,
    disable = M.is_work or spec.local_disable,
  }

  spec.disable = not is_contributing and M.is_home or false
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

---Install an executable, returning the error if any
---@param binary string
---@param installer string
---@param cmd string
---@return string?
function M.install(binary, installer, cmd, opts)
  opts = opts or { silent = true }
  cmd = cmd or 'install'
  if not as.executable(binary) and as.executable(installer) then
    local install_cmd = fmt('%s %s %s', installer, cmd, binary)
    if opts.silent then
      vim.cmd('!' .. install_cmd)
    else
      -- open a small split, make it full width, run the command
      vim.cmd(fmt('25split | wincmd J | terminal %s', install_cmd))
    end
  end
end

return M
