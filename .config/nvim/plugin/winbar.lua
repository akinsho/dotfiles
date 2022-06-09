---@diagnostic disable: duplicate-doc-param

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

local dir_separator = '/'
local separator = icons.arrow_right
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

local function append_icon_hl(accum, hl_name, name)
  accum[fmt('Winbar%sIcon', name:gsub('^%l', string.upper))] = { foreground = { from = hl_name } }
  return accum
end

local hls = as.fold(append_icon_hl, hl_map, {
  Winbar = { bold = false },
  WinbarNC = { bold = false },
  WinbarCrumb = { bold = true },
  WinbarIcon = { inherit = 'Function' },
  WinbarDirectory = { inherit = 'Directory' },
})

highlights.plugin('winbar', hls)

local function breadcrumbs()
  local data = gps.get_data()
  if not data or vim.tbl_isempty(data) then
    return { component(ellipsis, 'NonText', { priority = 0 }) }
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
function as.ui.winbar(current_win)
  local winbar = {}
  local add = utils.winline(winbar)

  add(utils.spacer(1))

  local bufname = api.nvim_buf_get_name(api.nvim_get_current_buf())
  if empty(bufname) then
    return add(component('[No name]', 'Winbar', { priority = 0 }))
  end

  local parts = vim.split(fn.fnamemodify(bufname, ':.'), '/')
  local icon, color = devicons.get_icon(bufname, nil, { default = true })

  as.foreach(function(part, index)
    local priority = (#parts - (index - 1)) * 2
    local is_first = index == 1
    local is_last = index == #parts
    local sep = is_last and separator or dir_separator
    local hl = is_last and 'Winbar' or 'NonText'
    local suffix_hl = is_last and 'WinbarDirectory' or 'NonText'
    as.winbar_state[priority] = table.concat(vim.list_slice(parts, 1, index), '/')
    add(component(part, hl, {
      id = priority,
      priority = priority,
      click = 'HandleWinbarClick',
      suffix = sep,
      suffix_color = suffix_hl,
      prefix = is_first and icon or nil,
      prefix_color = is_first and color or nil,
    }))
  end, parts)
  if current_win == api.nvim_get_current_win() then
    add(unpack(breadcrumbs()))
  end
  return utils.display(winbar, api.nvim_win_get_width(api.nvim_get_current_win()))
end

local blocked = {
  'NeogitStatus',
  'NeogitCommitMessage',
  'toggleterm',
  'DressingInput',
}
local allowed = { 'toggleterm' }

as.augroup('AttachWinbar', {
  {
    event = { 'BufWinEnter', 'BufEnter', 'WinClosed' },
    desc = 'Toggle winbar',
    command = function()
      local current = api.nvim_get_current_win()
      for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        local buf = api.nvim_win_get_buf(win)
        if
          not vim.tbl_contains(blocked, vim.bo[buf].filetype)
          and empty(fn.win_gettype(win))
          and empty(vim.bo[buf].buftype)
          and not empty(vim.bo[buf].filetype)
        then
          vim.wo[win].winbar = fmt('%%{%%v:lua.as.ui.winbar(%d)%%}', current)
        elseif not vim.tbl_contains(allowed, vim.bo[buf].filetype) then
          vim.wo[win].winbar = ''
        end
      end
    end,
  },
})
