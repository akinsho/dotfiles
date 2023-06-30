if not as then return end
local ui = as.ui

-- Inspiration
-- 1. vim-relativity
-- 2. numbers.vim - https://github.com/myusuf3/numbers.vim/blob/master/plugin/numbers.vim

local api, fn = vim.api, vim.fn
local M = {}

local function is_floating_win() return fn.win_gettype() == 'popup' end

local is_enabled = true

---Determines whether or not a window should be ignored by this plugin
---@return boolean
local function is_ignored() return is_floating_win() end

-- block list certain plugins and buffer types
local function is_blocked()
  local win_type = fn.win_gettype()
  if not api.nvim_buf_is_valid(0) and not api.nvim_buf_is_loaded(0) then return true end
  if win_type == 'command' or vim.wo.diff or vim.wo.previewwindow then return true end

  local decs = ui.decorations.get({ ft = vim.bo.ft, bt = vim.bo.bt, setting = 'number' })
  return decs.ft == false or decs.bt == false
end

local function enable_relative_number()
  if not is_enabled then return end
  if is_ignored() then return end
  local enabled = not is_blocked()
  vim.wo.number, vim.wo.relativenumber = enabled, enabled
end

local function disable_relative_number()
  if is_ignored() then return end
  vim.wo.number, vim.wo.relativenumber = not is_blocked(), false
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
  event = { 'BufEnter', 'FileType', 'FocusGained', 'InsertLeave' },
  command = enable_relative_number,
}, {
  event = { 'FocusLost', 'BufLeave', 'InsertEnter', 'TermOpen' },
  command = disable_relative_number,
})

return M
