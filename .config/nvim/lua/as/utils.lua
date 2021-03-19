local M = {}
local fn = vim.fn
local api = vim.api

function M.total_plugins()
  local base_path = fn.stdpath("data") .. "/site/pack/packer/"
  local start = vim.split(fn.globpath(base_path .. "start", "*"), "\n")
  local opt = vim.split(fn.globpath(base_path .. "opt", "*"), "\n")
  local start_count = vim.tbl_count(start)
  local opt_count = vim.tbl_count(opt)
  return {total = start_count + opt_count, start = start_count, lazy = opt_count}
end

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function M.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      M.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

--- Usage:
--- 1. Call `local stop = utils.profile('my-log')` at the top of the file
--- 2. At the bottom of the file call `stop()`
--- 3. Restart neovim, the newly created log file should open
function M.profile(filename)
  local base = "/tmp/config/profile/"
  fn.mkdir(base, "p")
  local success, profile = pcall(require, "plenary.profile.lua_profiler")
  if not success then
    vim.api.nvim_echo({"Plenary is not installed.", "Title"}, true, {})
  end
  profile.start()
  return function()
    profile.stop()
    local logfile = base .. filename .. ".log"
    profile.report(logfile)
    vim.defer_fn(
      function()
        vim.cmd("tabedit " .. logfile)
      end,
      1000
    )
  end
end

function M.has(feature)
  return vim.fn.has(feature) > 0
end

local function get_defaults(mode)
  return {noremap = true, silent = not mode == "c"}
end

local function validate_opts(opts)
  if not opts then
    return true
  end

  if opts.buffer and type(opts.buffer) ~= "number" then
    return false, "The buffer key should be a number"
  end

  return true
end

local function make_mapper(mode, _opts)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(_opts)
  return function(lhs, rhs, __opts)
    local opts = __opts and vim.deepcopy(__opts) or {}
    vim.validate {
      lhs = {lhs, "string"},
      rhs = {rhs, "string"},
      opts = {opts, validate_opts, "mapping options are incorrect"}
    }
    if opts.buffer then
      -- Remove the buffer from the args sent to the key map function
      local bufnr = opts.buffer
      opts.buffer = nil
      opts = vim.tbl_extend("keep", opts, parent_opts)
      api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    else
      api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend("keep", opts, parent_opts))
    end
  end
end

local map_opts = {noremap = false, silent = true}
M.nmap = make_mapper("n", map_opts)
M.xmap = make_mapper("x", map_opts)
M.imap = make_mapper("i", map_opts)
M.vmap = make_mapper("v", map_opts)
M.omap = make_mapper("o", map_opts)
M.tmap = make_mapper("t", map_opts)
M.smap = make_mapper("s", map_opts)
M.cmap = make_mapper("c", {noremap = false, silent = false})

local noremap_opts = {noremap = true, silent = true}
M.nnoremap = make_mapper("n", noremap_opts)
M.xnoremap = make_mapper("x", noremap_opts)
M.vnoremap = make_mapper("v", noremap_opts)
M.inoremap = make_mapper("i", noremap_opts)
M.onoremap = make_mapper("o", noremap_opts)
M.tnoremap = make_mapper("t", noremap_opts)
M.cnoremap = make_mapper("c", {noremap = true, silent = false})

function M.map(mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function M.buf_map(bufnr, mode, lhs, rhs, opts)
  opts = opts or get_defaults(mode)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

function M.command(args)
  local commands_table_name = "as_utils.command_callbacks"
  local nargs = args.nargs or 0
  local name = args[1]
  local rhs = args[2]
  local types = (args.types and type(args.types) == "table") and table.concat(args.types, " ") or ""

  if type(rhs) == "function" then
    table.insert(as_utils.command_callbacks, rhs)
    rhs =
      string.format(
      "lua %s[%d](%s)",
      commands_table_name,
      #as_utils.command_callbacks,
      nargs == 0 and "" or "<f-args>"
    )
  end

  vim.cmd(string.format("command! -nargs=%s %s %s %s", nargs, types, name, rhs))
end

function M.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= "_G" and value and vim.fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

return M
