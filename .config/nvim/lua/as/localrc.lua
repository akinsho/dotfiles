local luv = vim.loop
local echo = require("as.utils").echomsg

local sep = "/"
local default_target = "localrc.lua"

local M = {}

local function get_parent(str)
  local parts = vim.split(str, "[/\\]")
  parts[#parts] = nil
  return table.concat(parts, sep)
end

local function setup_localrc(path)
  require("as.autocommands").create(
    {
      LocalRC = {
        {"BufWritePost", path, string.format([[lua require('as.localrc').reload('%s')]], path)}
      }
    }
  )
end

function M.reload(path)
  vim.cmd("luafile " .. path)
  echo("Reloaded " .. path)
end

---@param path string|nil
---@param target string|nil
function M.load(path, target)
  path = path and #path > 0 and path or vim.fn.getcwd()
  target = target or default_target

  local found
  local is_home = path == os.getenv("HOME")
  if is_home then
    return
  end

  luv.fs_opendir(
    path,
    function(err, entries)
      if err then
        print(err)
        vim.defer_fn(
          function()
            echo("[Local init @ " .. path .. " failed]: " .. err, "ErrorMsg")
          end,
          100
        )
        return
      end
      while true do
        local entry = luv.fs_readdir(entries)
        if not entry or found then
          break
        end
        for _, item in ipairs(entry) do
          if item and item.name == target then
            found = item
          end
        end
      end
      if found then
        vim.defer_fn(
          function()
            local rc_path = path .. sep .. found.name
            local success, msg = pcall(dofile, rc_path)
            echo("Found " .. target .. " at " .. rc_path)
            if success then
              setup_localrc(rc_path)
            end
            local message = success and "Successfully loaded." or "Failed to load because: " .. msg
            echo(message)
          end,
          100
        )
        return
      elseif not is_home then
        M.load(get_parent(path), target)
      end
    end
  )
end

require("as.autocommands").create(
  {
    LoadLocalInit = {
      {
        "SessionLoadPost",
        "*",
        [[lua require("as.localrc").load()]]
      }
    }
  }
)

return M
