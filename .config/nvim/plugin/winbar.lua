local gps = require('nvim-gps')
local devicons = require('nvim-web-devicons')
local highlights = require('as.highlights')
local utils = require('as.utils.statusline')

local fn = vim.fn
local api = vim.api
local fmt = string.format
local icons = as.style.icons.misc

local separator = icons.chevron_right

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
    return 'WinbarIcon'
  end
  local icon_type = vim.split(t, '-')[1]
  return hl_map[icon_type] or 'WinbarIcon'
end

local hls = as.fold(
  function(accum, hl_name, name)
    accum[fmt('Winbar%sIcon', name:gsub('^%l', string.upper))] = { foreground = { from = hl_name } }
    return accum
  end,
  hl_map,
  {
    Winbar = { bold = true },
    WinbarCrumb = { bold = true },
    WinbarIcon = { inherit = 'Function' },
    WinbarDirectory = { inherit = 'Directory' },
    WinbarCurrent = { bold = true, underline = true, sp = { from = 'Directory', attr = 'fg' } },
  }
)

highlights.plugin('winbar', hls)

local function breadcrumbs()
  local priority = 0
  local data = gps.is_available() and gps.get_data() or nil
  if not data or type(data) ~= 'table' or vim.tbl_isempty(data) then
    return { { utils.item('⋯', 'NonText'), priority } }
  end
  return as.fold(function(accum, item, index)
    table.insert(accum, { utils.item(item.icon, get_icon_hl(item.type)), priority })
    table.insert(accum, { utils.item(item.text, 'WinbarCrumb'), priority })
    if next(data, index) then
      table.insert(accum, { utils.item(separator, 'WinbarDirectory'), priority })
    end
    return accum
  end, data, {})
end

---@param current_win number the actual real window
---@return string
function as.winbar(current_win)
  local winbar = {}
  local add = utils.winline(winbar)
  local bufname = api.nvim_buf_get_name(api.nvim_get_current_buf())
  if bufname == '' then
    return add({ utils.item('[No name]', 'Winbar'), 0 })
  end
  local is_current = current_win == api.nvim_get_current_win()
  local parts = vim.split(fn.fnamemodify(bufname, ':.'), '/')
  local icon, color = devicons.get_icon(bufname, nil, { default = true })
  local width = api.nvim_win_get_width(api.nvim_get_current_win())
  as.foreach(function(part, index)
    local priority = #parts - index
    if next(parts, index) then
      add(
        { utils.item(part, 'Winbar'), priority },
        { utils.item(separator, 'WinbarDirectory'), priority }
      )
    else
      add({ utils.item(icon, color), priority }, { utils.item(part, 'WinbarCurrent'), priority })
      if is_current then
        add(unpack(breadcrumbs()))
      end
    end
  end, parts)
  return utils.display(winbar, width)
end

local excluded = { 'NeogitStatus', 'NeogitCommitMessage', 'toggleterm' }
local allow_list = { 'toggleterm' }

as.augroup('AttachWinbar', {
  {
    event = { 'WinEnter', 'BufEnter', 'WinClosed' },
    desc = 'Toggle winbar',
    command = function()
      local current = api.nvim_get_current_win()
      for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        local buf = api.nvim_win_get_buf(win)
        if
          not vim.tbl_contains(excluded, vim.bo[buf].filetype)
          and as.empty(fn.win_gettype(win))
          and as.empty(vim.bo[buf].buftype)
          and not as.empty(vim.bo[buf].filetype)
        then
          vim.wo[win].winbar = fmt('%%{%%v:lua.as.winbar(%d)%%}', current)
        elseif not vim.tbl_contains(allow_list, vim.bo[buf].filetype) then
          vim.wo[win].winbar = ''
        end
      end
    end,
  },
})
