local M = {
  tmux = {},
  kitty = {},
}

---@alias bg_type "light" | "dark"

---@type table<bg_type, string>
local hl_names = {
  light = 'Normal',
  dark = 'BufferLineFill',
}

local hl_ok, mod = as.safe_require('as.highlights', { silent = true })

---@module "as.highlights"
local H = mod

local fn = vim.fn
local fmt = string.format

local function colors_to_string(colors)
  return as.fold(function(acc, c, name)
    if c then
      acc = acc .. fmt(' %s=%s', name, c)
    end
    return acc
  end, colors, '')
end

function M.kitty.get_colors()
  local txt = fn.system('kitty @ get-colors')
  if not txt then
    return
  end
  local colors = as.fold(function(acc, line)
    local key, value = unpack(vim.split(line, '%s+'))
    acc[key] = value
    return acc
  end, vim.split(txt, '\n'), {})
  return colors
end

--- Sets the color of kitty's tab bar
---@param bg_type bg_type
function M.kitty.set_colors(bg_type)
  if not hl_ok then
    return
  end
  local name = hl_names[bg_type]
  local bg = H.get(name, 'bg')
  local colors = {
    active_tab_background = bg,
    inactive_tab_background = bg,
    tab_bar_background = bg,
  }
  if vim.env.KITTY_LISTEN_ON then
    fn.jobstart(
      fmt('kitty @ --to %s set-colors %s', vim.env.KITTY_LISTEN_ON, colors_to_string(colors))
    )
  end
end

---Reset the kitty terminal colors
function M.kitty.clear_colors()
  if not hl_ok then
    return
  end
  if not vim.env.KITTY_LISTEN_ON then
    return
  end
  local colors = M.kitty.get_colors()
  local str = colors_to_string({
    active_tab_background = colors.active_tab_background,
    inactive_tab_background = colors.inactive_tab_background,
    tab_bar_background = colors.tab_bar_background,
  })
  -- this is intentionally synchronous so it has time to execute fully
  fn.system(fmt('kitty @ --to %s set-colors %s', vim.env.KITTY_LISTEN_ON, str))
end

local function fileicon()
  local name = fn.bufname()
  local icon, hl
  local loaded, devicons = as.safe_require('nvim-web-devicons')
  if loaded then
    icon, hl = devicons.get_icon(name, fn.fnamemodify(name, ':e'), { default = true })
  end
  return icon, hl
end

function M.title_string()
  if not hl_ok then
    return
  end
  local dir = fn.fnamemodify(fn.getcwd(), ':t')
  local icon, hl = fileicon()
  if not hl then
    return (icon or '') .. ' '
  end
  local has_tmux = vim.env.TMUX ~= nil
  return has_tmux and fmt('%s #[fg=%s]%s ', dir, H.get_hl(hl, 'fg'), icon) or dir .. ' ' .. icon
end

--- Get the color of the current vim background and update tmux accordingly
---@param reset boolean?
function M.tmux.set_statusline(reset)
  if not hl_ok then
    return
  end
  local hl = reset and 'Normal' or 'MsgArea'
  local bg = H.get_hl(hl, 'bg')
  -- TODO: we should correctly derive the previous bg value
  fn.jobstart(fmt('tmux set-option -g status-style bg=%s', bg))
end

function M.tmux.clear_pane_title()
  fn.jobstart('tmux set-window-option automatic-rename on')
end

return M
