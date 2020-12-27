function _G.plugin_loaded (name)
  return vim.fn.PluginLoaded(name) > 0
end

require("as.settings")
require("as.lsp")
require("as.mappings")
require("as.statusline")
require("as.highlights")
