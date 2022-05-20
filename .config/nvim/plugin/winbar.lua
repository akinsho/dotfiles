if not as.version(0, 8) then
  return
end

as.winbar = {}

local fn = vim.fn
local api = vim.api
local fmt = string.format
local devicons = require('nvim-web-devicons')
local highlights = require('as.highlights')
local icons = as.style.icons.misc

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

local function hl(str)
  return '%#' .. str .. '#'
end

local hl_end = '%*'

local hl_map = {
  ['class'] = 'Class',
  ['function'] = 'Function',
  ['method'] = 'Method',
  ['container'] = 'Typedef',
  ['tag'] = 'Tag',
  ['array'] = 'Directory',
  ['object'] = 'Structure',
  ['null'] = 'Comment',
  ['boolean'] = 'Boolean',
  ['number'] = 'Number',
  ['string'] = 'String',
}

local function get_icon_hl(t)
  if not t then
    return hl('WinbarIcon')
  end
  local icon_type = vim.split(t, '-')[1]
  return hl(hl_map[icon_type] or 'WinbarIcon')
end

local hls = {
  WinbarIcon = { inherit = 'Function' },
  WinbarDirectory = { inherit = 'Directory' },
  WinbarCurrent = { bold = true, underline = true, sp = { from = 'Directory', attr = 'fg' } },
}
for name, hl_name in pairs(hl_map) do
  hls[fmt('Winbar%sIcon', name:gsub('^%l', string.upper))] = { foreground = { from = hl_name } }
end

highlights.plugin('winbar', hls)

function as.winbar.render()
  local buf = api.nvim_get_current_buf()
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

local function breadcrumbs_available()
  return require('nvim-gps').is_available()
end

function as.winbar.breadcrumbs()
  local gps = require('nvim-gps')
  local data = gps.get_data()
  local winline = ' '
  if vim.tbl_isempty(data) then
    return as.winbar.render()
  end
  for index, item in ipairs(data) do
    winline = winline .. get_icon_hl(item.type) .. item.icon .. hl_end .. item.text .. hl_end
    if next(data, index) then
      winline = winline .. hl('WinbarDirectory') .. fmt(' %s ', icons.chevron_right) .. hl_end
    end
  end
  return winline
end

local excluded = { 'NeogitStatus', 'NeogitCommitMessage' }

as.augroup('AttachWinbar', {
  {
    event = { 'WinEnter', 'BufEnter', 'WinClosed' },
    desc = 'Toggle winbar',
    command = function()
      local valid_wins = get_valid_wins()
      for _, win in ipairs(valid_wins) do
        local buf = api.nvim_win_get_buf(win)
        local is_current = win == api.nvim_get_current_win()
        if
          not vim.tbl_contains(excluded, vim.bo[buf].filetype)
          and vim.bo[buf].buftype == ''
          and vim.bo[buf].filetype ~= ''
          and breadcrumbs_available()
        then
          -- The current buffer should show breadcrumbs and others should show their paths
          local str = is_current and 'breadcrumbs' or 'render'
          vim.wo[win].winbar = '%{%v:lua.as.winbar.' .. str .. '()%}'
        else
          vim.wo[win].winbar = ''
        end
      end
    end,
  },
})
