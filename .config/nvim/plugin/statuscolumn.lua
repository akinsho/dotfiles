if not as or not as.has('nvim-0.9') or not as.ui.statuscolumn.enable then return end

local fn, v, api, opt, optl = vim.fn, vim.v, vim.api, vim.opt, vim.opt_local
local ui, separators, falsy = as.ui, as.ui.icons.separators, as.falsy
local str = require('as.strings')

local SIGN_COL_WIDTH, GIT_COL_WIDTH, space = 2, 1, ' '
local fcs = opt.fillchars:get()
local fold_opened, fold_closed = fcs.foldopen, fcs.foldclose -- '▶'
local shade, separator = separators.light_shade_block, separators.left_thin_block -- '│'
local sep_hl = 'StatusColSep'

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
---@param line_count number
---@return string
local function nr(win, line_count)
  local col_width = api.nvim_strwidth(tostring(line_count))
  local padding = string.rep(space, col_width - 1)
  if v.virtnum < 0 then return padding .. shade end -- virtual line
  if v.virtnum > 0 then return padding .. space end -- wrapped line
  local num = vim.wo[win].relativenumber and not falsy(v.relnum) and v.relnum or v.lnum
  if line_count >= 1000 then col_width = col_width + 1 end
  local lnum = fn.substitute(num, '\\d\\zs\\ze\\%(\\d\\d\\d\\)\\+$', ',', 'g')
  local num_width = col_width - api.nvim_strwidth(lnum)
  return string.rep(space, num_width) .. lnum
end

---@param signs {name:string, text:string, texthl:string}[][]
---@return StringComponent[] sgns non-git signs
---@return StringComponent[] g_sgns list of git signs
local function signs_by_type(signs)
  local sgns, g_sgn = {}, {}
  for _, sn in ipairs(signs) do
    if sn[1].name:find('GitSign') then
      table.insert(g_sgn, { { { sn[1].text, sn[1].texthl } }, after = '' })
    else
      for _, s in ipairs(sn) do
        table.insert(sgns, { { { s.text, s.texthl } }, after = '' })
      end
    end
  end
  while #sgns < SIGN_COL_WIDTH or #g_sgn < GIT_COL_WIDTH do
    if #sgns < SIGN_COL_WIDTH then table.insert(sgns, str.spacer(1)) end
    if #g_sgn < GIT_COL_WIDTH then table.insert(g_sgn, str.spacer(1)) end
  end
  return sgns, g_sgn
end

--- TODO: currently auto-resizing the statuscolumn does not update each line but only the line with
--- the most signs. The simplest solution would be to use the "%s" signcolumn component but this
--- currently includes the git signs which I'm trying to specifically position at then end of the statuscolumn.
--- if gitsigns ever supports query signs per line refactor this to use that API and just use "%s"
--- alternatively calculate the max width of the statuscolumn and use that to adjust all lines.
function ui.statuscolumn.render()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)
  local signs = get_signs(curbuf)
  local sns, gitsign = signs_by_type(signs)

  local line_count = api.nvim_buf_line_count(curbuf)
  local is_absolute_lnum = v.virtnum >= 0 and falsy(v.relnum)
  local separator_hl = is_absolute_lnum and sep_hl or nil

  local statuscol = {}
  local add = str.append(statuscol)

  add(str.spacer(1), { { { nr(curwin, line_count) } } })
  add(unpack(sns))
  add(unpack(gitsign))
  add({ { { separator, separator_hl } }, after = '' }, { { { fdm() } } })

  return str.display({ {}, statuscol })
end

vim.o.statuscolumn = '%{%v:lua.as.ui.statuscolumn.render()%}'

as.augroup('StatusCol', {
  event = { 'BufEnter', 'FileType' },
  command = function(args)
    local has_statuscol = ui.decorations.get(vim.bo[args.buf].ft, 'statuscolumn', 'ft')
    if has_statuscol == false then optl.statuscolumn = '' end
  end,
})
