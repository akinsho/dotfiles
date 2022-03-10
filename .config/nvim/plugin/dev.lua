local M = {}
local fmt = string.format
local fn = vim.fn

---@see https://gist.github.com/windwp/c2b91ab679a66efeb489a359291c2719
---@param plugin string
function M.auto_reload(plugin)
  if _G._require == nil then
    _G._require = require
    _G.require = function(path)
      local module = fmt('^%s[^_]*$', vim.pesc(plugin))
      if string.find(path, module) ~= nil then
        require('plenary.reload').reload_module(path)
      end
      return _G._require(path)
    end
  end
end

function M.setup(enabled)
  if not enabled then
    return
  end
  as.augroup('DevReload', {
    {
      event = { 'VimEnter' },
      pattern = { '*' },
      command = function()
        local cwd = vim.loop.cwd()
        if not cwd:match(vim.env.PROJECTS_DIR) then
          return
        end
        local lua_dir = cwd .. '/lua/'
        if fn.isdirectory(lua_dir) == 0 then
          return
        end
        local names = require('pl.dir').getdirectories(lua_dir)
        if not names[1] then
          return
        end
        local name = fn.fnamemodify(names[1], ':t')
        M.auto_reload(name)
        vim.schedule(function()
          vim.notify(fmt('autoreloading %s', name))
        end)
      end,
    },
  })
end

return M
