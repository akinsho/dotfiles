local M = {}

function M.is_plugin_loaded(plugin)
  local success, plug = pcall(require, plugin)
  return success, plug
end

return M
