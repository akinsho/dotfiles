require("as.globals.utils")

local fn = vim.fn

if vim.notify then
  ---Override of vim.notify to open floating window
  --@param message of the notification to show to the user
  --@param log_level Optional log level
  --@param opts Dictionary with optional options (timeout, etc)
  vim.notify = function(message, log_level, _)
    as.notify({message}, {timeout = 5000, log_level = log_level})
  end
end

-- inspired/copied from @tjdevries
P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- USAGE:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function as.plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath("data") .. "/site/pack/packer/start/*", true, true)
    local opt = fn.expand(fn.stdpath("data") .. "/site/pack/packer/opt/*", true, true)
    vim.list_extend(dirs, opt)
    installed =
      vim.tbl_map(
      function(path)
        return fn.fnamemodify(path, ":t")
      end,
      dirs
    )
  end
  return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function _G.plugin_loaded(plugin_name)
  local plugins = _G.packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end
