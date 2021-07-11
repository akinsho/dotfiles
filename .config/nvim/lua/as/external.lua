local M = {
  tmux = {},
  kitty = {},
}

local highlights_loaded, H = pcall(require, 'as.highlights')

local fn = vim.fn
local fmt = string.format
local loaded, devicons = pcall(require, 'nvim-web-devicons')

--- Get the color of the current vim background and update tmux accordingly
---@param reset boolean?
function M.tmux.set_statusline(reset)
  if not highlights_loaded then
    return
  end
  local hl = reset and 'Normal' or 'MsgArea'
  local bg = H.get_hl(hl, 'bg')
  -- TODO: we should correctly derive the previous bg value
  fn.jobstart(fmt('tmux set-option -g status-style bg=%s', bg))
end

function M.kitty.set_background()
  if not highlights_loaded then
    return
  end
  if vim.env.KITTY_LISTEN_ON then
    local bg = H.get_hl('MsgArea', 'bg')
    fn.jobstart(fmt('kitty @ --to %s set-colors background=%s', vim.env.KITTY_LISTEN_ON, bg))
  end
end

---Reset the kitty terminal colors
function M.kitty.clear_background()
  if not highlights_loaded then
    return
  end
  if vim.env.KITTY_LISTEN_ON then
    local bg = H.get_hl('Normal', 'bg')
    -- this is intentionally synchronous so it has time to execute fully
    fn.system(fmt('kitty @ --to %s set-colors background=%s', vim.env.KITTY_LISTEN_ON, bg))
  end
end

local function fileicon()
  local name = fn.bufname()
  local icon, hl
  if loaded then
    icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ':e'), { default = true })
  end
  return icon, hl
end

function M.title_string()
  if not highlights_loaded then
    return
  end
  local dir = fn.fnamemodify(fn.getcwd(), ':t')
  local icon, hl = fileicon()
  return fmt('%s #[fg=%s]%s ', dir, H.get_hl(hl, 'fg'), icon)
end

function M.tmux.clear_pane_title()
  fn.jobstart 'tmux set-window-option automatic-rename on'
end

return M
