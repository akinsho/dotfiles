--- dynamically load all the plugin settings in this module
--- this essentially replicates the "runtime" call in vimscript
local function load_settings(dir)
  for filename in io.popen('dir "' .. dir .. '" -1'):lines() do
    if not filename:match("init") then
      local mod = filename:gsub("%.lua", "")
      require("as.settings." .. mod)
    end
  end
end

load_settings(vim.fn.stdpath("config") .. "/lua/as/settings")
