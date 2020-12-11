local autocommands = require("autocommands")
local synIDattr = vim.fn.synIDattr
local hlID = vim.fn.hlID

local M = {}

local explorer_fts = {"LuaTree"}

--- @param win_id integer
function M.has_win_highlight(win_id)
  local win_hl = vim.wo[win_id].winhighlight
  return win_hl ~= nil and win_hl ~= "", win_hl
end

local function find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---@param win_id number
---@param target string
---@param name string
---@param default string
function M.adopt_winhighlight(win_id, target, name, default)
  name = name .. win_id
  local _, win_hl = M.has_win_highlight(win_id)
  local hl_exists = vim.fn.hlexists(name) > 0
  if not hl_exists then
    local parts = vim.split(win_hl, ",")
    local found =
      find(
      parts,
      function(part)
        return part:match(target)
      end
    )
    if found then
      local hl_group = vim.split(found, ":")[2]
      local bg = M.hl_value(hl_group, "bg")
      local fg = M.hl_value(default, "fg")
      local gui = M.gui_attr(default)
      M.highlight(name, {guibg = bg, guifg = fg, gui = gui})
    end
  end
  return name
end

---@param name string
---@param opts table
function M.highlight(name, opts)
  local guifg = opts.guifg
  local guibg = opts.guibg
  local gui = opts.gui
  local guisp = opts.guisp
  local cterm = opts.cterm
  if name and vim.tbl_count(opts) > 0 then
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
    if guisp and guisp ~= "" then
      table.insert(cmd, "guisp=" .. guisp)
    end
    if cterm and cterm ~= "" then
      table.insert(cmd, "cterm=" .. cterm)
    end
    local success = pcall(vim.cmd, table.concat(cmd, " "))
    if not success then
      vim.api.nvim_err_writeln(
        "Failed setting " ..
          name .. " highlight, something isn't configured correctly" .. "\n"
      )
    end
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
  local normal_bg = M.hl_value("Normal", "bg")
  local split_color = M.hl_value("VertSplit", "fg")
  local shade_color = require("bufferline").shade_color
  local bg_color = shade_color(normal_bg, -8)
  local st_color = shade_color(M.hl_value("Visual", "bg"), -20)
  local hls = {
    {"ExplorerBackground", {guibg = bg_color}},
    {"ExplorerVertSplit", {guifg = split_color, guibg = bg_color}},
    {"ExplorerStNC", {guibg = st_color, cterm = "italic"}},
    {"ExplorerSt", {guibg = st_color}}
  }
  for _, grp in ipairs(hls) do
    M.highlight(unpack(grp))
  end
end

function M.on_enter()
  if vim.tbl_contains(explorer_fts, vim.bo.filetype) then
    local highlights =
      table.concat(
      {
        "Normal:ExplorerBackground",
        "StatusLine:ExplorerSt",
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
