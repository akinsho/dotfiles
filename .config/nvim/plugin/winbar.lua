local gps = require('nvim-gps')
local devicons = require('nvim-web-devicons')
local highlights = require('as.highlights')
local utils = require('as.utils.statusline')
local component = utils.component
local empty = as.empty

local fn = vim.fn
local api = vim.api
local fmt = string.format
local icons = as.style.icons.misc

local separator = icons.chevron_right
local ellipsis = icons.ellipsis

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

vim.cmd([[
function! HandleWinbarClick(minwid, clicks, btn, modifiers) abort
  call v:lua.as.winbar_click(a:minwid, a:clicks, a:btn, a:modifiers)
endfunction
]])

--- A mapping of each winbar items ID to its path
--- @type table<string, string>
as.winbar_state = {}

---@param id number
---@param _ number number of clicks
---@param _ "l"|"r"|"m" the button clicked
---@param _ string modifiers
function as.winbar_click(id, _, _, _)
  if id then
    vim.cmd('edit ' .. as.winbar_state[id])
  end
end

local hls = as.fold(
  function(accum, hl_name, name)
    accum[fmt('Winbar%sIcon', name:gsub('^%l', string.upper))] = { foreground = { from = hl_name } }
    return accum
  end,
  hl_map,
  {
    Winbar = { bold = true },
    WinbarNC = { bold = false },
    WinbarCrumb = { bold = true },
    WinbarIcon = { inherit = 'Function' },
    WinbarDirectory = { inherit = 'Directory' },
    WinbarCurrent = { bold = true, underline = true, sp = { from = 'Directory', attr = 'fg' } },
  }
)

highlights.plugin('winbar', hls)

local function breadcrumbs()
  local data = gps.is_available() and gps.get_data() or nil
  if not data or type(data) ~= 'table' or vim.tbl_isempty(data) then
    return { utils.component(ellipsis, 'NonText', { priority = 0 }) }
  end
  return as.fold(function(accum, item, index)
    local has_next = index < #data
    table.insert(
      accum,
      component(item.text, 'WinbarCrumb', {
        prefix = item.icon,
        prefix_color = get_icon_hl(item.type),
        suffix = has_next and separator or nil,
        suffix_color = has_next and 'WinbarDirectory' or nil,
        priority = index,
      })
    )
    return accum
  end, data, {})
end

---@param current_win number the actual real window
---@return string
function as.winbar(current_win)
  local winbar = {}
  local add = utils.winline(winbar)

  add(utils.spacer(1))

  local bufname = api.nvim_buf_get_name(api.nvim_get_current_buf())
  if empty(bufname) then
    return add(component('[No name]', 'Winbar', { priority = 0 }))
  end

  local is_current = current_win == api.nvim_get_current_win()
  local parts = vim.split(fn.fnamemodify(bufname, ':.'), '/')
  local icon, color = devicons.get_icon(bufname, nil, { default = true })

  as.foreach(function(part, index)
    local priority = (#parts - (index - 1)) * 2
    local has_next = index < #parts
    as.winbar_state[priority] = table.concat(vim.list_slice(parts, 1, index), '/')
    add(component(part, (not has_next and is_current) and 'WinbarCurrent' or nil, {
      id = priority,
      click = 'HandleWinbarClick',
      suffix = (has_next or is_current) and separator or nil,
      suffix_color = (has_next or is_current) and 'WinbarDirectory' or nil,
      prefix = not has_next and icon or nil,
      prefix_color = not has_next and color or nil,
      priority = priority,
    }))
  end, parts)
  if is_current then
    add(unpack(breadcrumbs()))
  end
  return utils.display(winbar, api.nvim_win_get_width(api.nvim_get_current_win()))
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
          and empty(fn.win_gettype(win))
          and empty(vim.bo[buf].buftype)
          and not empty(vim.bo[buf].filetype)
        then
          vim.wo[win].winbar = fmt('%%{%%v:lua.as.winbar(%d)%%}', current)
        elseif
          not empty(vim.wo[win].winbar)
          and not vim.tbl_contains(allow_list, vim.bo[buf].filetype)
        then
          vim.wo[win].winbar = ''
        end
      end
    end,
  },
})
