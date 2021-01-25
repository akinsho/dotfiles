local luv = vim.loop

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

local echo = function(msg, hl)
  hl = hl or "Title"
  vim.api.nvim_echo({{msg, hl}}, true, {})
end

local function load_rc(found, target, path)
  local rc_path = path .. sep .. found.name
  local success, msg = pcall(dofile, rc_path)
  echo("Found " .. target .. " at " .. rc_path)
  if success then
    setup_localrc(rc_path)
  end
  local message = success and "Successfully loaded." or "Failed to load because: " .. msg
  echo(message)
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
    function(err, dir)
      if err then
        return vim.defer_fn(
          function()
            echo("[Local init @ " .. path .. " failed]: " .. err, "ErrorMsg")
          end,
          100
        )
      end
      repeat
        local entry = luv.fs_readdir(dir)
        if entry then
          for _, item in ipairs(entry) do
            if item and item.name == target then
              found = item
            end
          end
        end
      until not entry or found
      if found then
        vim.defer_fn(
          function()
            load_rc(found, target, path)
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

function M.setup(event)
  event = event or "VimEnter"
  require("as.autocommands").create(
    {
      LoadLocalInit = {
        {
          event,
          "*",
          [[lua require("as.localrc").load()]]
        }
      }
    }
  )
end

return M
