local M = {
  tmux = {},
  kitty = {}
}

local fn = vim.fn
local fmt = string.format
local loaded, devicons = pcall(require, "nvim-web-devicons")

--- Get the color of the current vim background and update tmux accordingly
---@param reset boolean?
function M.tmux.set_statusline(reset)
  local hl = reset and "Normal" or "MsgArea"
  local bg = require("as.highlights").hl_value(hl, "bg")
  -- TODO: we should correctly derive the previous bg value
  fn.jobstart(fmt("tmux set-option -g status-style bg=%s", bg))
end

function M.kitty.set_background()
  if vim.env.KITTY_LISTEN_ON then
    local bg = require("as.highlights").hl_value("MsgArea", "bg")
    fn.jobstart(fmt("kitty @ --to %s set-colors background=%s", vim.env.KITTY_LISTEN_ON, bg))
  end
end

---Reset the kitty terminal colors
function M.kitty.clear_background()
  if vim.env.KITTY_LISTEN_ON then
    local bg = require("as.highlights").hl_value("Normal", "bg")
    -- this is intentially synchronous so it has time to execute fully
    fn.system(fmt("kitty @ --to %s set-colors background=%s", vim.env.KITTY_LISTEN_ON, bg))
  end
end

local function fileicon()
  local name = fn.bufname()
  local icon, hl
  if loaded then
    icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ":e"), {default = true})
  end
  return icon, hl
end

function M.title_string()
  local dir = fn.fnamemodify(fn.getcwd(), ":t")
  local icon, hl = fileicon()
  return fmt("%s #[fg=%s]%s ", dir, require("as.highlights").hl_value(hl, "fg"), icon)
end

function M.tmux.clear_pane_title()
  fn.jobstart("tmux set-window-option automatic-rename on")
end

return M
