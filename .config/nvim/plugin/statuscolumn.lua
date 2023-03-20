if not as or not as.has('nvim-0.9') then return end

local fn, v, api, opt, optl = vim.fn, vim.v, vim.api, vim.opt, vim.opt_local
local ui, separators = as.ui, as.ui.icons.separators
local str = require('as.strings')

local SIGN_COL_WIDTH, GIT_COL_WIDTH, space = 2, 1, ' '
local fcs = opt.fillchars:get()
local fold_opened, fold_closed = fcs.foldopen, fcs.foldclose -- '▶'
local shade, separator = separators.light_shade_block, separators.left_thin_block -- '│'
local sep_hl = 'StatusColSep'

ui.statuscolumn = {}

---@param buf number
---@return {name:string, text:string, texthl:string}[][]
local function get_signs(buf)
  return vim.tbl_map(function(sign)
    local signs = fn.sign_getdefined(sign.name)
    for _, s in ipairs(signs) do
      if s.text then s.text = s.text:gsub('%s', '') end
    end
    return signs
  end, fn.sign_getplaced(buf, { group = '*', lnum = v.lnum })[1].signs)
end

local function fdm()
  if fn.foldlevel(v.lnum) <= fn.foldlevel(v.lnum - 1) then return space end
  return fn.foldclosed(v.lnum) == -1 and fold_closed or fold_opened
end

---@param win number
---@return string
local function nr(win)
  if v.virtnum < 0 then return shade end -- virtual line
  if v.virtnum > 0 then return space end -- wrapped line
  local num = vim.wo[win].relativenumber and not as.empty(v.relnum) and v.relnum or v.lnum
  local lnum = fn.substitute(num, '\\d\\zs\\ze\\%(\\d\\d\\d\\)\\+$', ',', 'g')
  local num_width = (vim.wo[win].numberwidth - 1) - api.nvim_strwidth(lnum)
  local padding = string.rep(space, num_width)
  return padding .. lnum
end

---@param signs {name:string, text:string, texthl:string}[][]
---@return StringComponent[] sgns non-git signs
---@return StringComponent[] g_sgns list of git signs
local function signs_by_type(signs)
  local sgns, g_sgn, opts = {}, {}, { after = '' }
  for _, sn in ipairs(signs) do
    if sn[1].name:find('GitSign') then
      table.insert(g_sgn, str.component(sn[1].text, sn[1].texthl, opts))
    else
      as.foreach(function(s) table.insert(sgns, str.component(s.text, s.texthl, opts)) end, sn)
    end
  end
  while #sgns < SIGN_COL_WIDTH or #g_sgn < GIT_COL_WIDTH do
    if #sgns < SIGN_COL_WIDTH then table.insert(sgns, str.spacer(1)) end
    if #g_sgn < GIT_COL_WIDTH then table.insert(g_sgn, str.spacer(1)) end
  end
  return sgns, g_sgn
end

function ui.statuscolumn.render()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)
  local signs = get_signs(curbuf)
  local sns, gitsign = signs_by_type(signs)
  local is_absolute_lnum = v.virtnum >= 0 and as.empty(v.relnum)

  local statuscol = {}
  local add = str.append(statuscol)

  add(str.spacer(1), str.separator(), str.component(nr(curwin)))
  add(unpack(sns))
  add(unpack(gitsign))
  add(
    str.component(separator, is_absolute_lnum and sep_hl or '', { after = '' }),
    str.component(fdm())
  )
  return str.display(statuscol)
end

vim.o.statuscolumn = '%{%v:lua.as.ui.statuscolumn.render()%}'

as.augroup('StatusCol', {
  event = { 'BufEnter', 'FileType' },
  command = function(args)
    local has_statuscol = ui.decorations.get(vim.bo[args.buf].ft, 'statuscolumn', 'ft')
    if has_statuscol == false then optl.statuscolumn = '' end
  end,
})
