as.winbar = {}

local fn = vim.fn
local api = vim.api
local fmt = string.format
local devicons = require('nvim-web-devicons')
local highlights = require('as.highlights')
local icons = as.style.icons.misc

highlights.plugin('winbar', {
  WinbarDirectory = { inherit = 'Directory' },
  WinbarCurrent = { bold = true, underline = true, sp = { from = 'Directory', attr = 'fg' } },
})

local function hl(str)
  return '%#' .. str .. '#'
end

local hl_end = '%*'

local excluded = { 'NeogitStatus' }

function as.winbar.render()
  local buf = api.nvim_win_get_buf(vim.g.statusline_winid)
  local bufname = api.nvim_buf_get_name(buf)
  local winline = ' ' -- 1 space padding
  if vim.tbl_contains(excluded, vim.bo.filetype) and api.nvim_win_get then
    return ''
  end
  if bufname == '' then
    return winline .. '[No name]'
  end
  local parts = vim.split(fn.fnamemodify(bufname, ':.'), '/')
  for idx, part in ipairs(parts) do
    if next(parts, idx) then
      winline = winline
        .. as.truncate(part, 20)
        .. hl('WinbarDirectory')
        .. fmt(' %s ', icons.chevron_right)
        .. hl_end
    else
      local icon, color = devicons.get_icon(bufname, nil, { default = true })
      winline = winline .. hl(color) .. icon .. ' ' .. hl('WinbarCurrent') .. part .. hl_end
    end
  end
  return winline
end

as.augroup('AttachWinbar', {
  {
    event = { 'WinEnter' },
    desc = 'Clear winbar for active window',
    command = function()
      vim.wo.winbar = ''
    end,
  },
  {
    event = { 'WinLeave' },
    desc = 'Add path winbar for inactive window',
    command = function()
      vim.wo.winbar = '%!v:lua.as.winbar.render()'
    end,
  },
})
