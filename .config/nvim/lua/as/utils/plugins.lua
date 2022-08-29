local M = {}

local fn, fmt = vim.fn, string.format
local is_work = vim.env.WORK ~= nil
local is_home = not is_work

---A thin wrapper around vim.notify to add packer details to the message
---@param msg string
function M.packer_notify(msg, level) vim.notify(msg, level, { title = 'Packer' }) end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
-- NOTE: install packer as an opt plugin since it's loaded conditionally on my local machine
-- it needs to be installed as optional so the install dir is consistent across machines
function M.bootstrap_packer()
  local install_path = fmt('%s/site/pack/packer/opt/packer.nvim', fn.stdpath('data'))
  if fn.empty(fn.glob(install_path)) > 0 then
    M.packer_notify('Downloading packer.nvim...')
    M.packer_notify(
      fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
    )
    vim.cmd.packadd({ 'packer.nvim', bang = true })
    require('packer').sync()
  else
    -- FIXME: currently development versions of packer do not work
    -- local name = vim.env.DEVELOPING and 'local-packer.nvim' or 'packer.nvim'
    vim.cmd.packadd({ 'packer.nvim', bang = true })
  end
end

function M.not_headless() return #vim.api.nvim_list_uis() > 0 end

---@param path string
function M.dev(path) return vim.env.HOME .. '/projects/' .. path end

local function enabled_checker(spec)
  if spec.local_enabled then return function() return true end, function() return false end end
  return function() return false end, function() return true end
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
  if fn.isdirectory(fn.expand(path)) < 1 then return spec, nil end
  local is_contributing = spec.local_path:match('contributing') ~= nil

  local enabled, not_enabled = enabled_checker(spec)

  local local_spec = {
    path,
    config = spec.config,
    setup = spec.setup,
    rocks = spec.rocks,
    opt = spec.local_opt,
    as = fmt('local-%s', name),
    cond = is_contributing and enabled or spec.local_cond,
    disable = is_work or spec.local_disable,
  }

  -- Criteria for disabling the upstream plugin:
  -- 1. If this is a personal plugin and I'm on my own machine
  -- 2. If this is an "enabled" plugin I'm contributing to and I'm on my own machine
  spec.disable = ((not is_contributing or enabled()) and is_home) or false
  spec.cond = is_contributing and not_enabled or nil

  --- swap the keys and event if we are currently developing
  if is_contributing and enabled() and spec.keys or spec.event then
    local_spec.keys, local_spec.event, spec.keys, spec.event = spec.keys, spec.event, nil, nil
  end

  -- clean up the jerry rigged fields so packer doesn't complain about them
  for key, _ in pairs(spec) do
    if type(key) == 'string' and key:match('^local_') then spec[key] = nil end
  end

  return local_spec, spec
end

---local variant of packer's use function that specifies both a local and
---upstream version of a plugin
---@param original table
function M.use_local(original)
  local use = require('packer').use
  local local_spec, spec = M.with_local(original)
  use({ spec, local_spec })
end

---Require a plugin config
---@param name string
---@return any
function M.conf(name) return require(fmt('as.plugins.%s', name)) end

return M
