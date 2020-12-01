local autocommands = require("autocommands")

local M = {}

function M.highlight(opts)
  local name = opts.name
  local guifg = opts.guifg
  local guibg = opts.guibg
  local gui = opts.gui
  if name and #opts then
    local cmd = {"highlight", name}
    if guifg then
      table.insert(cmd, "guifg=" .. guifg)
    end
    if guibg then
      table.insert(cmd, "guibg=" .. guibg)
    end
    if gui then
      table.insert(cmd, "gui=" .. gui)
    end
    vim.cmd(table.concat(cmd, " "))
  end
end

function M.set_explorer_highlight()
  local normal_bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
  local bg_color = require("bufferline").shade_color(normal_bg, -15)
  local hls = {
    {name = "ExplorerBackground", guibg = bg_color},
    {name = "ExplorerVertSplit", guifg = bg_color, guibg = bg_color}
  }
  for _, grp in ipairs(hls) do
    M.highlight(grp)
  end
end

function M.on_enter()
  if vim.bo.filetype == "LuaTree" then
    local highlights =
      table.concat(
      {
        "Normal:ExplorerBackground",
        "StatusLine:ExplorerBackground",
        "SignColumn:ExplorerBackground",
        "VertSplit:ExplorerVertSplit"
      },
      ","
    )
    vim.cmd("setlocal winhighlight=" .. highlights)
  end
end

autocommands.create(
  {
    ExplorerHighlights = {
      {
        "VimEnter,ColorScheme",
        "*",
        "lua require('highlights').set_explorer_highlight()"
      },
      {
        "FileType",
        "LuaTree",
        "lua require('highlights').on_enter()"
      }
    }
  }
)

return M
