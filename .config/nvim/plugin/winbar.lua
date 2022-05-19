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

function as.winbar.render()
  local buf = api.nvim_win_get_buf(vim.g.statusline_winid)
  local bufname = api.nvim_buf_get_name(buf)
  local winline = ' ' -- 1 space padding
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

-- Count the number of windows but ignore floating ones.
local function get_valid_wins()
  local wins = {}
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    if fn.win_gettype(api.nvim_win_get_number(win)) == '' then
      table.insert(wins, win)
    end
  end
  return wins
end

local excluded = { 'NeogitStatus', 'NeogitCommitMessage' }

as.augroup('AttachWinbar', {
  {
    event = { 'WinEnter', 'BufEnter', 'WinClosed', 'BufDelete' },
    desc = 'Toggle winbar',
    command = function()
      local valid_wins = get_valid_wins()
      for _, win in ipairs(valid_wins) do
        local buf = api.nvim_win_get_buf(win)
        if
          not vim.tbl_contains(excluded, vim.bo[buf].filetype)
          and vim.bo[buf].buftype == ''
          and vim.bo[buf].filetype ~= ''
          and #valid_wins > 1
        then
          vim.wo[win].winbar = '%!v:lua.as.winbar.render()'
        else
          vim.wo[win].winbar = ''
        end
      end
    end,
  },
})
