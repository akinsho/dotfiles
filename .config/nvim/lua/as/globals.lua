--[[
-----------------------------------------------------------------------------//
-- Globals
-----------------------------------------------------------------------------//
This file injects utilities under a namespace into the global scope so in any
part of my config I can call select helper methods.
--]]
local utils = require("as.utils")

_G.as_utils = {
  lsp = {},
  -- TODO: once commands and mappings can take functions
  -- as arguments natively remove these globals
  command_callbacks = {},
  mapping_callbacks = {},
  command = utils.command,
  profile = utils.profile,
  --- @type fun(feature: string): boolean
  has = utils.has,
  --- @type fun(item: string | any[]): boolean
  is_empty = utils.is_empty,
  --- @type fun(t1: table, t2: table): table @comment merge two table giving t2 preference
  deep_merge = utils.deep_merge,
  map = utils.map,
  --- @type fun(lhs: string, rhs: string, opts: table)
  nnoremap = utils.nnoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  xnoremap = utils.xnoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  vnoremap = utils.vnoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  inoremap = utils.inoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  onoremap = utils.onoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  cnoremap = utils.cnoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  tnoremap = utils.tnoremap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  nmap = utils.nmap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  vmap = utils.vmap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  imap = utils.imap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  xmap = utils.xmap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  smap = utils.smap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  omap = utils.omap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  cmap = utils.cmap,
  --- @type fun(lhs: string, rhs: string, opts: table)
  tmap = utils.tmap,
  buf_map = utils.buf_map,
}

-- inspect the contents of an object very quickly in your code or from the command-line:
-- usage:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
