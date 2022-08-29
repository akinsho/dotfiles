local fn = vim.fn
local api = vim.api
local fmt = string.format
local l = vim.log.levels

----------------------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------------------

--- Convert a list or map of items into a value by iterating all it's fields and transforming
--- them with a callback
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param accum T?
---@return T
function as.fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, 'The accumulator must be returned on each iteration')
  end
  return accum
end

---@generic T : table
---@param callback fun(item: T, key: string | number, list: T[]): T
---@param list T[]
---@return T[]
function as.map(callback, list)
  return as.fold(function(accum, v, k)
    accum[#accum + 1] = callback(v, k, accum)
    return accum
  end, list, {})
end

---@generic T : table
---@param callback fun(T, key: string | number): T
---@param list T[]
function as.foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

--- Check if the target matches  any item in the list.
---@param target string
---@param list string[]
---@return boolean
function as.any(target, list)
  return as.fold(function(accum, item)
    if accum then return accum end
    if target:match(item) then return true end
    return accum
  end, list, false)
end

---Find an item in a list
---@generic T
---@param matcher fun(arg: T):boolean
---@param haystack T[]
---@return T
function as.find(matcher, haystack)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

as.list_installed_plugins = (function()
  local plugins
  return function()
    if plugins then return plugins end
    local data_dir = fn.stdpath('data')
    local start = fn.expand(data_dir .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(data_dir .. '/site/pack/packer/opt/*', true, true)
    plugins = vim.list_extend(start, opt)
    return plugins
  end
end)()

---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function as.plugin_installed(plugin_name)
  for _, path in ipairs(as.list_installed_plugins()) do
    if vim.endswith(path, plugin_name) then return true end
  end
  return false
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function as.plugin_loaded(plugin_name)
  local plugins = packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end

---Check whether or not the location or quickfix list is open
---@return boolean
function as.is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == 'qf' or is_loc_list then return true end
  end
  return false
end

---@param str string
---@param max_len integer
---@return string
function as.truncate(str, max_len)
  assert(str and max_len, 'string and max_len must be provided')
  return api.nvim_strwidth(str) > max_len and str:sub(1, max_len) .. as.style.icons.misc.ellipsis
    or str
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function as.empty(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

---Require a module using `pcall` and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function as.require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    if opts.message then result = opts.message .. '\n' .. result end
    vim.notify(result, l.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@vararg any
---@return boolean, any
---@overload fun(fun: function, ...): boolean, any
function as.wrap_err(msg, func, ...)
  local args = { ... }
  if type(msg) == 'function' then
    args, func, msg = { func, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = msg and fmt('%s:\n%s', msg, err) or err
    vim.schedule(function() vim.notify(msg, l.ERROR, { title = 'ERROR' }) end)
  end, unpack(args))
end

---@alias Plug table<(string | number), string>

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
--- TODO: find out if it's possible to annotate the plugin as a module
---@param name string | Plug
---@param callback fun(module: table)
function as.ftplugin_conf(name, callback)
  local plugin_name = type(name) == 'table' and name.plugin or nil
  if plugin_name and not as.plugin_loaded(plugin_name) then return end

  local module = type(name) == 'table' and name[1] or name
  local info = debug.getinfo(1, 'S')
  local ok, plugin = as.require(module, { message = fmt('In file: %s', info.source) })

  if ok then callback(plugin) end
end

---Reload lua modules
---@param path string
---@param recursive boolean
function as.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= '_G' and value and fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

---Check that the current nvim version is greater than or equal to the given version
---@param major number
---@param minor number
---@param _ number patch
---@return unknown
function as.version(major, minor, _)
  assert(major and minor, 'major and minor must be provided')
  local v = vim.version()
  return major >= v.major and minor >= v.minor
end

P = vim.pretty_print

--- Validate the keys passed to as.augroup are valid
---@param name string
---@param cmd Autocommand
local function validate_autocmd(name, cmd)
  local keys = { 'event', 'buffer', 'pattern', 'desc', 'command', 'group', 'once', 'nested' }
  local incorrect = as.fold(function(accum, _, key)
    if not vim.tbl_contains(keys, key) then table.insert(accum, key) end
    return accum
  end, cmd, {})
  if #incorrect == 0 then return end
  vim.schedule(
    function()
      vim.notify('Incorrect keys: ' .. table.concat(incorrect, ', '), 'error', {
        title = fmt('Autocmd: %s', name),
      })
    end
  )
end

---@class AutocmdArgs
---@field id number
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string
---@field event  string | string[] list of autocommand events
---@field pattern string | string[] list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function as.augroup(name, commands)
  assert(name ~= 'User', 'The name of an augroup CANNOT be User')
  assert(#commands > 0, fmt('You must specify at least one autocommand for %s', name))
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
function as.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

---Check if a cmd is executable
---@param e string
---@return boolean
function as.executable(e) return fn.executable(e) > 0 end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return string
function as.replace_termcodes(str) return api.nvim_replace_termcodes(str, true, true, true) end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function as.has(feature) return vim.fn.has(feature) > 0 end

----------------------------------------------------------------------------------------------------
-- Mappings
----------------------------------------------------------------------------------------------------

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { desc = opts } or opts and vim.deepcopy(opts) or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('keep', opts, parent_opts))
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive commandline mapping
as.nmap = make_mapper('n', map_opts)
-- A recursive select mapping
as.xmap = make_mapper('x', map_opts)
-- A recursive terminal mapping
as.imap = make_mapper('i', map_opts)
-- A recursive operator mapping
as.vmap = make_mapper('v', map_opts)
-- A recursive insert mapping
as.omap = make_mapper('o', map_opts)
-- A recursive visual & select mapping
as.tmap = make_mapper('t', map_opts)
-- A recursive visual mapping
as.smap = make_mapper('s', map_opts)
-- A recursive normal mapping
as.cmap = make_mapper('c', { remap = true, silent = false })
-- A non recursive normal mapping
as.nnoremap = make_mapper('n', noremap_opts)
-- A non recursive visual mapping
as.xnoremap = make_mapper('x', noremap_opts)
-- A non recursive visual & select mapping
as.vnoremap = make_mapper('v', noremap_opts)
-- A non recursive insert mapping
as.inoremap = make_mapper('i', noremap_opts)
-- A non recursive operator mapping
as.onoremap = make_mapper('o', noremap_opts)
-- A non recursive terminal mapping
as.tnoremap = make_mapper('t', noremap_opts)
-- A non recursive select mapping
as.snoremap = make_mapper('s', noremap_opts)
-- A non recursive commandline mapping
as.cnoremap = make_mapper('c', { silent = false })
