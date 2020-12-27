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
  plugin_loaded = utils.plugin_loaded,
  profile = utils.profile
}

