--[[
-----------------------------------------------------------------------------//
-- Globals
-----------------------------------------------------------------------------//
This file injects utilities under a namespace into the global scope so in any
part of my config I can call select helper methods.
--]]
local utils = require("as.utils")

_G.as_utils = {
  map = utils.map,
  nnoremap = utils.nnoremap,
  xnoremap = utils.xnoremap,
  vnoremap = utils.vnoremap,
  inoremap = utils.inoremap,
  onoremap = utils.onoremap,
  cnoremap = utils.cnoremap,
  nmap = utils.nmap,
  vmap = utils.vmap,
  imap = utils.imap,
  xmap = utils.xmap,
  omap = utils.omap,
  cmap = utils.cmap,
  command = utils.command,
  buf_map = utils.buf_map,
  profile = utils.profile,
  has = utils.has,
  -- TODO once commands can take functions as arguments natively remove this global
  command_callbacks = {},
  lsp = {}
}

-- inspect the contents of an object very quickly in your code or from the command-line:
-- usage:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
