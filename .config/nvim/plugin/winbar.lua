---@diagnostic disable: duplicate-doc-param

if not as or not as.ui.winbar.enable then return end

local str = require('as.strings')
local decorations = as.ui.decorations

local fn, api = vim.fn, vim.api
local component = str.component
local empty = as.empty
local icons = as.ui.icons.misc
local lsp_hl = as.ui.lsp.highlights

local dir_separator = '/'
local separator = icons.arrow_right
local ellipsis = icons.ellipsis

--- A mapping of each winbar items ID to its path
--- @type table<string, string>
as.ui.winbar.state = {}

---@param id number
---@param _ number number of clicks
---@param _ "l"|"r"|"m" the button clicked
---@param _ string modifiers
function as.ui.winbar.click(id, _, _, _)
  if not id then return end
  local item = as.ui.winbar.state[id]
  if type(item) == 'string' then vim.cmd.edit(as.ui.winbar.state[id]) end
  if type(item) == 'table' and item.start then
    local win = fn.getmousepos().winid
    api.nvim_win_set_cursor(win, { item.start.line, item.start.character })
  end
end

as.highlight.plugin('winbar', {
  { Winbar = { bold = false } },
  { WinbarNC = { bold = false } },
  { WinbarCrumb = { bold = true } },
  { WinbarIcon = { inherit = 'Function' } },
  { WinbarDirectory = { inherit = 'Directory' } },
})

local function breadcrumbs()
  local ok, navic = pcall(require, 'nvim-navic')
  local empty_state = { component(ellipsis, 'NonText', { priority = 0 }) }
  if not ok or not navic.is_available() then return empty_state end
  local navic_ok, data = pcall(navic.get_data)
  if not navic_ok or empty(data) then return empty_state end
  return as.map(function(crumb, index)
    local priority = #as.ui.winbar.state + #data - index
    as.ui.winbar.state[priority] = crumb.scope
    return component(crumb.name, 'WinbarCrumb', {
      priority = priority,
      id = priority,
      click = 'v:lua.as.ui.winbar.click',
      max_size = 35,
      prefix = crumb.icon,
      prefix_color = lsp_hl[crumb.type] or 'NonText',
      suffix = #data > index and separator or '',
      suffix_color = 'Directory',
    })
  end, data)
end

---@return string
function as.ui.winbar.get()
  local winbar = {}
  local add = str.append(winbar)

  add(str.spacer(1))

  local bufname = api.nvim_buf_get_name(api.nvim_get_current_buf())
  if empty(bufname) then
    add(component('[No name]', 'Winbar', { priority = 0 }))
    return winbar
  end

  local parts = vim.split(fn.fnamemodify(bufname, ':.'), '/')

  as.foreach(function(part, index)
    local priority = (#parts - (index - 1)) * 2
    local is_last = index == #parts
    local sep = is_last and separator or dir_separator
    local hl = is_last and 'Winbar' or 'NonText'
    local suffix_hl = is_last and 'WinbarDirectory' or 'NonText'
    as.ui.winbar.state[priority] = table.concat(vim.list_slice(parts, 1, index), '/')
    add(component(part, hl, {
      id = priority,
      priority = priority,
      click = 'v:lua.as.ui.winbar.click',
      suffix = sep,
      suffix_color = suffix_hl,
    }))
  end, parts)
  add(unpack(breadcrumbs()))
  return str.display(winbar, api.nvim_win_get_width(api.nvim_get_current_win()))
end

local function set_winbar()
  as.foreach(function(w)
    local buf, win = vim.bo[api.nvim_win_get_buf(w)], vim.wo[w]
    local bt, ft, is_diff = buf.buftype, buf.filetype, win.diff
    local ft_setting = decorations.get(ft, 'winbar', 'ft')
    local bt_setting = decorations.get(bt, 'winbar', 'bt')
    local ignored = ft_setting == 'ignore' or bt_setting == 'ignore'
    if not ignored then
      if
        not ft_setting
        and fn.win_gettype(api.nvim_win_get_number(w)) == ''
        and bt == ''
        and ft ~= ''
        and not is_diff
      then
        win.winbar = '%{%v:lua.as.ui.winbar.get()%}'
      elseif is_diff then
        win.winbar = nil
      end
    end
  end, api.nvim_tabpage_list_wins(0))
end

as.augroup('AttachWinbar', {
  event = { 'BufWinEnter', 'TabNew', 'TabEnter', 'BufEnter', 'WinClosed' },
  desc = 'Toggle winbar',
  command = set_winbar,
}, {
  event = 'User',
  pattern = { 'DiffviewDiffBufRead', 'DiffviewDiffBufWinEnter' },
  desc = 'Toggle winbar',
  command = set_winbar,
})
