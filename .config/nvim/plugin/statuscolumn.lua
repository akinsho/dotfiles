if not as or not vim.o.statuscolumn then return end

local fn, g, v, api = vim.fn, vim.g, vim.v, vim.api

local space = ' '
local shade = '░'
local separator = '▏' -- '│'
local fold_opened = '▼'
local fold_closed = '▶'
local sep_hl = '%#StatusColSep#'

as.statuscolumn = {}

---@param group string
---@param text string
---@return string
local function hl(group, text) return '%#' .. group .. '#' .. text .. '%*' end

local function click(name, item) return '%@v:lua.as.statuscolumn.' .. name .. '@' .. item end

---@return {name:string, text:string, texthl:string}[]
local function get_signs()
  local buf = api.nvim_win_get_buf(g.statusline_winid)
  return vim.tbl_map(
    function(sign) return fn.sign_getdefined(sign.name)[1] end,
    fn.sign_getplaced(buf, { group = '*', lnum = v.lnum })[1].signs
  )
end

function as.statuscolumn.toggle_breakpoint(_, _, _, mods)
  local ok, dap = pcall(require, 'dap')
  if not ok then return end
  if mods:find('c') then
    vim.ui.input(
      { prompt = 'Breakpoint condition: ' },
      function(input) dap.set_breakpoint(input) end
    )
  else
    dap.toggle_breakpoint()
  end
end

local function fdm()
  if fn.foldlevel(v.lnum) <= fn.foldlevel(v.lnum - 1) then return space end
  return fn.foldclosed(v.lnum) == -1 and fold_closed or fold_opened
end

local function is_virt_line() return v.virtnum < 0 end

local function nr()
  if is_virt_line() then return shade end -- virtual line
  local is_relative = vim.wo[g.statusline_winid].relativenumber
  local num = (is_relative and not as.empty(v.relnum)) and v.relnum or v.lnum
  local lnum = fn.substitute(num, '\\d\\zs\\ze\\' .. '%(\\d\\d\\d\\)\\+$', ',', 'g')
  return click('toggle_breakpoint', lnum)
end

local function sep()
  local separator_hl = not is_virt_line() and as.empty(v.relnum) and sep_hl or ''
  return separator_hl .. separator
end

function as.statuscolumn.render()
  local sign, git_sign
  -- This is dependent on using normal signs (rather than extmarks) for git signs
  for _, s in ipairs(get_signs()) do
    if s.name:find('GitSign') then
      git_sign = s
    else
      sign = s
    end
  end
  local components = {
    sign and hl(sign.texthl, sign.text) or space,
    '%=',
    nr(),
    space,
    git_sign and hl(git_sign.texthl, git_sign.text:gsub(space, '')) or space,
    sep(),
    fdm(),
    space,
  }
  return table.concat(components, '')
end

local excluded = {
  'neo-tree',
  'NeogitStatus',
  'NeogitCommitMessage',
  'undotree',
  'log',
  'man',
  'dap-repl',
  'markdown',
  'vimwiki',
  'vim-plug',
  'gitcommit',
  'toggleterm',
  'fugitive',
  'list',
  'NvimTree',
  'startify',
  'help',
  'orgagenda',
  'org',
  'himalaya',
  'Trouble',
  'NeogitCommitMessage',
  'NeogitRebaseTodo',
}

vim.o.statuscolumn = [[%!v:lua.as.statuscolumn.render()]]

as.augroup('StatusCol', {
  {
    event = { 'BufEnter', 'FileType' },
    command = function(args)
      local buf = vim.bo[args.buf]
      if buf.bt ~= '' or vim.tbl_contains(excluded, buf.ft) then vim.opt_local.statuscolumn = '' end
    end,
  },
})
