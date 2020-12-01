local autocommands = require("autocommands")
local synIDattr = vim.fn.synIDattr
local hlID = vim.fn.hlID

local M = {}

local explorer_fts = {"LuaTree"}

function M.highlight(opts)
  local name = opts.name
  local guifg = opts.guifg
  local guibg = opts.guibg
  local gui = opts.gui
  local cterm = opts.cterm
  if name and #opts then
    local cmd = {"highlight", name}
    if guifg and guifg ~= "" then
      table.insert(cmd, "guifg=" .. guifg)
    end
    if guibg and guibg ~= "" then
      table.insert(cmd, "guibg=" .. guibg)
    end
    if gui and gui ~= "" then
      table.insert(cmd, "gui=" .. gui)
    end
    if cterm and cterm ~= "" then
      table.insert(cmd, "cterm=" .. cterm)
    end
    vim.cmd(table.concat(cmd, " "))
  end
end

function M.hl_value(grp, attr)
  return synIDattr(hlID(grp), attr)
end

function M.gui_attr(hl_group)
  local bold = M.hl_value(hl_group, "bold")
  local italic = M.hl_value(hl_group, "italic")
  local underline = M.hl_value(hl_group, "underline")
  local gui = {}
  if bold ~= "" and tonumber(bold) > 0 then
    table.insert(gui, "bold")
  end
  if italic ~= "" and tonumber(italic) > 0 then
    table.insert(gui, "italic")
  end
  if underline ~= "" and tonumber(underline) > 0 then
    table.insert(gui, "underline")
  end
  return table.concat(gui, ",")
end

function M.set_explorer_highlight()
  local normal_bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
  local bg_color = require("bufferline").shade_color(normal_bg, -15)
  local hls = {
    {name = "ExplorerBackground", guibg = bg_color},
    {name = "ExplorerVertSplit", guifg = bg_color, guibg = bg_color},
    {name = "ExplorerStNC", guibg = bg_color, cterm = "italic"}
  }
  for _, grp in ipairs(hls) do
    M.highlight(grp)
  end
end

function M.on_enter()
  if vim.tbl_contains(explorer_fts, vim.bo.filetype) then
    local highlights =
      table.concat(
      {
        "Normal:ExplorerBackground",
        "StatusLine:ExplorerBackground",
        "StatusLineNC:ExplorerStNC",
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
