if not as or not as.has('nvim-0.9') or not as.ui.statuscolumn.enable then return end

local fn, v, api, opt, optl = vim.fn, vim.v, vim.api, vim.opt, vim.opt_local
local ui, separators, falsy = as.ui, as.ui.icons.separators, as.falsy
local str = require('as.strings')

local SIGN_COL_WIDTH, GIT_COL_WIDTH, space = 2, 1, ' '
local fcs = opt.fillchars:get()
local fold_opened, fold_closed = fcs.foldopen, fcs.foldclose -- '▶'
local shade, separator = separators.light_shade_block, separators.left_thin_block -- '│'
local sep_hl = 'StatusColSep'

local function fdm()
  if fn.foldlevel(v.lnum) <= fn.foldlevel(v.lnum - 1) then return space end
  return fn.foldclosed(v.lnum) == -1 and fold_opened or fold_closed
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

---@param curbuf integer
---@return StringComponent[] sgns non-git signs
local function signplaced_signs(curbuf)
  local sgns = {}
  local signs = fn.sign_getplaced(curbuf, { group = '*', lnum = v.lnum })[1].signs
  for _, sn in ipairs(signs) do
    for _, s in ipairs(sn) do
      table.insert(sgns, { { { s.text:gsub('%s', ''), s.texthl } }, after = '' })
    end
  end
  while #sgns < SIGN_COL_WIDTH do
    table.insert(sgns, str.spacer(1))
  end
  return sgns
end

---@param curbuf integer
---@return StringComponent[]
--- TODO: this currently does not separate signs by type, it just assumes that only git signs are extmark signs
local function extmark_signs(curbuf)
  local lnum = v.lnum - 1
  ---@type {[1]: number, [2]: number, [3]: number, [4]: {sign_text: string, sign_hl_group: string}}
  local g_signs = api.nvim_buf_get_extmarks(curbuf, -1, { lnum, 0 }, { lnum, -1 }, { details = true, type = 'sign' })
  local sns = as.map(
    function(item) return { { { item[4].sign_text:gsub('%s', ''), item[4].sign_hl_group } }, after = '' } end,
    g_signs
  )
  while #sns < GIT_COL_WIDTH do
    table.insert(sns, str.spacer(1))
  end
  return sns
end

--- TODO: currently auto-resizing the statuscolumn does not update each line but only the line with
--- the most signs. The simplest solution would be to use the "%s" signcolumn component but this
--- currently includes the git signs which I'm trying to specifically position at then end of the statuscolumn.
--- if gitsigns ever supports querying signs per line refactor this to use that API and just use "%s"
--- alternatively calculate the max width of the statuscolumn and use that to adjust all lines.
function ui.statuscolumn.render()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)
  local gitsign, sns = extmark_signs(curbuf), signplaced_signs(curbuf)

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
    local decor = ui.decorations.get({
      ft = vim.bo[args.buf].ft,
      fname = fn.bufname(args.buf),
      setting = 'statuscolumn',
    })
    if decor.ft == false or decor.fname == false then optl.statuscolumn = '' end
  end,
})
