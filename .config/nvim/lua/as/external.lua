local H = require('as.highlights')

local fn = vim.fn
local fmt = string.format

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

local function colors_to_string(colors)
  return as.fold(function(acc, c, name)
    if c then acc = acc .. fmt(' %s=%s', name, c) end
    return acc
  end, colors, '')
end

---@alias Process { pid: number, cmdline: table<number, string> }
---@alias KittyWindow { id: number, is_focused: boolean, is_self: boolean, foreground_processes: Process }
---@alias KittyTab { id: number, is_focused: boolean, windows: KittyWindow[] }
---@alias KittyWM { id: number, is_focused: boolean, tabs: KittyTab[] }
---@alias KittyState KittyWM[]

---@return KittyState
function M.kitty.get_state()
  local txt = vim.fn.system('kitty @ ls')
  if not txt then return {} end
  local ok, json = pcall(vim.json.decode, txt)
  if not ok then
    vim.notify_once('Failed to unmarshall kitty state from JSON', 'error', {
      title = 'Kitty Integration',
    })
  end
  return ok and json or {}
end

---Search through nested kitty state to see if the current focused kitty window is an nvim window
---@return boolean
local function is_current_window_vim()
  local state = M.kitty.get_state()
  for _, wm in ipairs(state) do
    if wm.is_focused then
      for _, tab in ipairs(wm.tabs) do
        if tab.is_focused then
          for _, win in ipairs(tab.windows) do
            if win.is_focused then
              for _, process in ipairs(win.foreground_processes) do
                return vim.tbl_contains(process.cmdline, 'nvim')
              end
            end
          end
        end
      end
    end
  end
  return false
end

function M.kitty.get_colors()
  local txt = fn.system(fmt('kitty @ --to %s get-colors', vim.env.KITTY_LISTEN_ON))
  if not txt then return end
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

function M.kitty.clear_colors()
  if not vim.env.KITTY_LISTEN_ON then return end

  local colors = M.kitty.get_colors()
  local str = colors_to_string({
    active_tab_background = colors.active_tab_background,
    inactive_tab_background = colors.inactive_tab_background,
    tab_bar_background = colors.tab_bar_background,
  })
  -- this is intentionally synchronous so it has time to execute fully
  fn.system(fmt('kitty @ --to %s set-colors %s', vim.env.KITTY_LISTEN_ON, str))
end

function M.kitty.delayed_clear_colors()
  vim.defer_fn(function()
    -- If the current window is an nvim window then do not bother doing anything
    -- since the window will have it's own autocommands it's executing
    if is_current_window_vim() then return end
    M.kitty.clear_colors()
  end, 200)
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
  local dir = fn.fnamemodify(fn.getcwd(), ':t')
  local icon, hl = fileicon()
  if not hl then return (icon or '') .. ' ' end
  local has_tmux = vim.env.TMUX ~= nil
  return has_tmux and fmt('%s #[fg=%s]%s ', dir, H.get_hl(hl, 'fg'), icon) or dir .. ' ' .. icon
end

--- Get the color of the current vim background and update tmux accordingly
---@param reset boolean?
function M.tmux.set_statusline(reset)
  local hl = reset and 'Normal' or 'MsgArea'
  local bg = H.get_hl(hl, 'bg')
  -- TODO: we should correctly derive the previous bg value
  fn.jobstart(fmt('tmux set-option -g status-style bg=%s', bg))
end

function M.tmux.clear_pane_title() fn.jobstart('tmux set-window-option automatic-rename on') end

return M
