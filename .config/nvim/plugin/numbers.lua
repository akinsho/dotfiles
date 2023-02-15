if not as then return end
local ui = as.ui

-- Inspiration
-- 1. vim-relativity
-- 2. numbers.vim - https://github.com/myusuf3/numbers.vim/blob/master/plugin/numbers.vim

local api = vim.api
local M = {}

local number_buftype_exclusions = {
  'prompt',
  'terminal',
  'help',
  'nofile',
  'acwrite',
  'quickfix',
}

local number_buftype_ignored = { 'quickfix' }

local function is_floating_win() return vim.fn.win_gettype() == 'popup' end

local is_enabled = true

---Determines whether or not a window should be ignored by this plugin
---@return boolean
local function is_ignored()
  return vim.tbl_contains(number_buftype_ignored, vim.bo.buftype) or is_floating_win()
end

-- block list certain plugins and buffer types
local function is_blocked()
  local win_type = vim.fn.win_gettype()

  if not api.nvim_buf_is_valid(0) and not api.nvim_buf_is_loaded(0) then return true end

  if vim.wo.diff then return true end

  if win_type == 'command' then return true end

  if vim.wo.previewwindow then return true end

  local ft_settings = ui.settings.filetypes[vim.bo.ft]
  local bt_settings = ui.settings.buftypes[vim.bo.buftype]
  if (ft_settings and not ft_settings.number) or (bt_settings and not bt_settings.number) then
    return true
  end
  return false
end

local function enable_relative_number()
  if not is_enabled then return end
  if is_ignored() then return end
  if is_blocked() then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end

local function disable_relative_number()
  if is_ignored() then return end
  if is_blocked() then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end

as.command('ToggleRelativeNumber', function()
  is_enabled = not is_enabled
  if is_enabled then
    enable_relative_number()
  else
    disable_relative_number()
  end
end)

as.augroup('ToggleRelativeLineNumbers', {
  {
    event = { 'BufEnter', 'FileType', 'FocusGained', 'InsertLeave' },
    pattern = { '*' },
    command = function() enable_relative_number() end,
  },
  {
    event = { 'FocusLost', 'BufLeave', 'InsertEnter', 'TermOpen' },
    pattern = { '*' },
    command = function() disable_relative_number() end,
  },
})

return M
