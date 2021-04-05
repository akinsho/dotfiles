local M = {}

local fn = vim.fn
local fmt = string.format
local loaded, devicons = pcall(require, "nvim-web-devicons")

function M.statusline_colors()
  -- Get the color of the current vim background and update tmux accordingly
  local bg_color = fn.synIDattr(fn.hlID("Normal"), "bg")
  fn.jobstart(fmt("tmux set-option -g status-style bg=%s", bg_color))
  -- TODO: on vim leave we should set this back to what it was
end

function M.on_enter()
  local session = fn.fnamemodify(vim.loop.cwd(), ":t") or "Neovim"
  local window_title = session

  local fname = fn.expand("%:t")
  if not loaded or as_utils.is_empty(fname) then
    return
  end
  local name = fn.bufname()
  local icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ":e"), {default = true})
  if icon and hl then
    local hl_value = require("as.highlights").hl_value
    window_title = fmt("%s • #[fg=%s]%s", session, hl_value(hl, "fg"), icon)
  end
  fn.jobstart(fmt("tmux rename-window '%s'", window_title))
end

function M.on_leave()
  fn.jobstart("tmux set-window-option automatic-rename on")
end

return M
