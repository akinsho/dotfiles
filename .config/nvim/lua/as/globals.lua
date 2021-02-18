--[[
-----------------------------------------------------------------------------//
-- Globals
-----------------------------------------------------------------------------//
This file injects utilities under a namespace into the global scope so in any
part of my config I can call select helper methods.
--]]
local utils = require("as.utils")

-- TODO once commands can take functions as arguments natively remove this global
_G.CommandCallbacks = {}

_G.as_utils = {
  map = utils.map,
  command = utils.command,
  buf_map = utils.buf_map,
  profile = utils.profile,
  has = utils.has
}

-- inspect the contents of an object very quickly in your code or from the command-line:
-- usage:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
