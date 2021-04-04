local M = {}

local fn = vim.fn
local fmt = string.format
local empty = as_utils.is_empty
local loaded, devicons = pcall(require, "nvim-web-devicons")

function M.statusline_colors()
  -- Get the color of the current vim background and update tmux accordingly
  local bg_color = fn.synIDattr(fn.hlID("Normal"), "bg")
  fn.jobstart(fmt("tmux set-option -g status-style bg=%s", bg_color))
  -- TODO: on vim leave we should set this back to what it was
end

function M.on_enter()
  local fname = fn.expand("%:t")
  local session = ""
  if fn.strlen(fname) then
    local this_session = vim.v.this_session
    local session_file = not empty(this_session) and this_session or "Neovim"
    local window_title = session

    if session_file:match("_") then
      local parts = vim.split(session_file, "%.")
      session = parts[#parts - 1]
    elseif session_file:match("%%") then
      -- NOTE this is here for plugins like "prosession/obsession"
      -- which modify the session name into "path/to/session/file%name%.vim
      -- explainer ->
      -- :t -> get the tail
      -- :gs?subject?replacement?
      -- get the tail of that -> :r remove the extension
      -- see :h filename-modifier for details
      session = fn.fnamemodify(session_file, ":t:gs?%?/?:t:r")
    else
      session = fn.fnamemodify(session_file, ":t")
    end
    if loaded then
      local name = fn.bufname()
      local icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ":e"), {default = true})
      if icon and hl then
        local hl_value = require("as.highlights").hl_value
        window_title = fmt("%s • #[fg=%s]%s", session, hl_value(hl, "fg"), icon)
      end
    end
    fn.jobstart(fmt("tmux rename-window '%s'", window_title))
  end
end

function M.on_leave()
  fn.jobstart("tmux set-window-option automatic-rename on")
end

return M
