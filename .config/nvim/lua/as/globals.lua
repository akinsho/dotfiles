local fn, api, cmd, fmt = vim.fn, vim.api, vim.cmd, string.format
local l = vim.log.levels

----------------------------------------------------------------------------------------------------
-- Utils
----------------------------------------------------------------------------------------------------

--- Autosize horizontal split to match its minimum content
--- https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
---@param min_height number
---@param max_height number
function as.adjust_split_height(min_height, max_height)
  api.nvim_win_set_height(0, math.max(math.min(fn.line('$'), max_height), min_height))
end

---------------------------------------------------------------------------------
-- Quickfix and Location List
---------------------------------------------------------------------------------

as.list = { qf = {}, loc = {} }

---@param list_type "loclist" | "quickfix"
---@return boolean
local function is_list_open(list_type)
  return vim.iter(fn.getwininfo()):find(function(win) return not as.falsy(win[list_type]) end) ~= nil
end

local silence = { mods = { silent = true, emsg_silent = true } }

---@param callback fun(...)
local function preserve_window(callback, ...)
  local win = api.nvim_get_current_win()
  callback(...)
  if win ~= api.nvim_get_current_win() then cmd.wincmd('p') end
end

function as.list.qf.toggle()
  if is_list_open('quickfix') then
    cmd.cclose(silence)
  elseif #fn.getqflist() > 0 then
    preserve_window(cmd.copen, silence)
  end
end

function as.list.loc.toggle()
  if is_list_open('loclist') then
    cmd.lclose(silence)
  elseif #fn.getloclist(0) > 0 then
    preserve_window(cmd.lopen, silence)
  end
end

-- @see: https://vi.stackexchange.com/a/21255
-- using range-aware function
function as.list.qf.delete(buf)
  buf = buf or api.nvim_get_current_buf()
  local list = fn.getqflist()
  local line = api.nvim_win_get_cursor(0)[1]
  local mode = api.nvim_get_mode().mode
  if mode:match('[vV]') then
    local first_line = fn.getpos("'<")[2]
    local last_line = fn.getpos("'>")[2]
    list = vim.iter(ipairs(list)):filter(function(i) return i < first_line or i > last_line end)
  else
    table.remove(list, line)
  end
  -- replace items in the current list, do not make a new copy of it; this also preserves the list title
  fn.setqflist({}, 'r', { items = list })
  fn.setpos('.', { buf, line, 1, 0 }) -- restore current line
end
---------------------------------------------------------------------------------

---@param str string
---@param max_len integer
---@return string
function as.truncate(str, max_len)
  assert(str and max_len, 'string and max_len must be provided')
  return api.nvim_strwidth(str) > max_len and str:sub(1, max_len) .. as.ui.icons.misc.ellipsis or str
end

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function as.falsy(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'boolean' then return not item end
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

--- Call the given function and use `vim.notify` to notify of any errors
--- this function is a wrapper around `xpcall` which allows having a single
--- error handler for all errors
---@param msg string
---@param func function
---@param ... any
---@return boolean, any
---@overload fun(func: function, ...): boolean, any
function as.pcall(msg, func, ...)
  local args = { ... }
  if type(msg) == 'function' then
    local arg = func --[[@as any]]
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and fmt('%s:\n%s\n%s', msg, vim.inspect(args), err) or err)
    vim.schedule(function() vim.notify(msg, l.ERROR, { title = 'ERROR' }) end)
  end, unpack(args))
end

local LATEST_NIGHTLY_MINOR = 10
function as.nightly() return vim.version().minor >= LATEST_NIGHTLY_MINOR end

----------------------------------------------------------------------------------------------------
--  FILETYPE HELPERS
----------------------------------------------------------------------------------------------------

---@class FiletypeSettings
---@field g table<string, any>
---@field bo vim.bo
---@field wo vim.wo
---@field opt vim.opt
---@field plugins {[string]: fun(module: table)}

---@param args {[1]: string, [2]: string, [3]: string, [string]: boolean | integer}[]
---@param buf integer
local function apply_ft_mappings(args, buf)
  vim.iter(args):each(function(m)
    assert(#m == 3, 'map args must be a table with at least 3 items')
    local opts = vim.iter(m):fold({ buffer = buf }, function(acc, key, item)
      if type(key) == 'string' then acc[key] = item end
      return acc
    end)
    map(m[1], m[2], m[3], opts)
  end)
end

--- A convenience wrapper that calls the ftplugin config for a plugin if it exists
--- and warns me if the plugin is not installed
---@param configs table<string, fun(module: table)>
function as.ftplugin_conf(configs)
  if type(configs) ~= 'table' then return end
  for name, callback in pairs(configs) do
    local ok, plugin = as.pcall(require, name)
    if ok then callback(plugin) end
  end
end

--- This function is an alternative API to using ftplugin files. It allows defining
--- filetype settings in a single place, then creating FileType autocommands from this definition
---
--- e.g.
--- ```lua
---   as.filetype_settings({
---     lua = {
---      opt = {foldmethod = 'expr' },
---      bo = { shiftwidth = 2 }
---     },
---    [{'c', 'cpp'}] = {
---      bo = { shiftwidth = 2 }
---    }
---   })
--- ```
---
---@param map {[string|string[]]: FiletypeSettings | {[integer]: fun(args: AutocmdArgs)}}
function as.filetype_settings(map)
  local commands = vim.iter(map):map(function(ft, settings)
    local name = type(ft) == 'table' and table.concat(ft, ',') or ft
    return {
      pattern = ft,
      event = 'FileType',
      desc = ('ft settings for %s'):format(name),
      command = function(args)
        vim.iter(settings):each(function(key, value)
          if key == 'opt' then key = 'opt_local' end
          if key == 'mappings' then return apply_ft_mappings(value, args.buf) end
          if key == 'plugins' then return as.ftplugin_conf(value) end
          if type(key) == 'function' then return as.pcall(key, args) end
          vim.iter(value):each(function(option, setting) vim[key][option] = setting end)
        end)
      end,
    }
  end)
  as.augroup('filetype-settings', unpack(commands:totable()))
end

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

local autocmd_keys = { 'event', 'buffer', 'pattern', 'desc', 'command', 'group', 'once', 'nested' }
--- Validate the keys passed to as.augroup are valid
---@param name string
---@param command Autocommand
local function validate_autocmd(name, command)
  local incorrect = vim.iter(command):map(function(key, _)
    if not vim.tbl_contains(autocmd_keys, key) then return key end
  end)
  if #incorrect > 0 then
    vim.schedule(function()
      local msg = ('Incorrect keys: %s'):format(table.concat(incorrect, ', '))
      vim.notify(msg, 'error', { title = ('Autocmd: %s'):format(name) })
    end)
  end
end

---@class AutocmdArgs
---@field id number autocmd ID
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string?
---@field event  (string | string[])? list of autocommand events
---@field pattern (string | string[])? list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean?
---@field once    boolean?
---@field buffer  number?

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number
function as.augroup(name, ...)
  local commands = { ... }
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
---@param name string
---@param rhs string | fun(args: CommandArgs)
---@param opts table?
function as.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function as.has(feature) return fn.has(feature) > 0 end

---@generic T
---Given a table return a new table which if the key is not found will search
---all the table's keys for a match using `string.match`
---@param map T
---@return T
function as.p_table(map)
  return setmetatable(map, {
    __index = function(tbl, key)
      if not key then return end
      for k, v in pairs(tbl) do
        if key:match(k) then return v end
      end
    end,
  })
end

------------------------------------------------------------------------------------------------------------------------
--  Lazy Requires
------------------------------------------------------------------------------------------------------------------------
--- source: https://github.com/tjdevries/lazy-require.nvim

--- Require on index.
---
--- Will only require the module after the first index of a module.
--- Only works for modules that export a table.
function as.reqidx(require_path)
  return setmetatable({}, {
    __index = function(_, key) return require(require_path)[key] end,
    __newindex = function(_, key, value) require(require_path)[key] = value end,
  })
end

--- Require when an exported method is called.
---
--- Creates a new function. Cannot be used to compare functions,
--- set new values, etc. Only useful for waiting to do the require until you actually
--- call the code.
---
--- ```lua
--- -- This is not loaded yet
--- local lazy_mod = lazy.require_on_exported_call('my_module')
--- local lazy_func = lazy_mod.exported_func
---
--- -- ... some time later
--- lazy_func(42)  -- <- Only loads the module now
---
--- ```
---@param require_path string
---@return table<string, fun(...): any>
function as.reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) return require(require_path)[k](...) end
    end,
  })
end
