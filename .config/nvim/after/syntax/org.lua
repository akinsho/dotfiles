local fn = vim.fn
local api = vim.api
local fmt = string.format

local org_ns = api.nvim_create_namespace "org_bullets"

local symbols = {
  "◉",
  "○",
  "✸",
  "✿",
}

---@type table<integer,integer>
local marks = {}
local in_normal_mode = true

---@type table
local last_lnum = nil

---Check if the current line is the same as the last
---@param lnum integer
---@return table
local line_changed = function(lnum)
  return last_lnum and last_lnum.lnum ~= lnum
end

local function set_mark(virt_text, lnum, start_col, end_col, highlight)
  local id = api.nvim_buf_set_extmark(0, org_ns, lnum, start_col, {
    end_col = end_col,
    hl_group = highlight,
    virt_text = { virt_text },
    virt_text_pos = "overlay",
    hl_mode = "combine",
  })
  marks[lnum] = id
end

---Re-add the lnum that was revealed on the last cursor move
---@param lnum number
local function reapply_previous_extmark(lnum)
  if not last_lnum or not line_changed(lnum) then
    return
  end
  local mark = last_lnum.mark[3]
  if not mark then
    return
  end
  local start_col = last_lnum.mark[2]
  local end_col = mark.end_col
  set_mark(mark.virt_text[1], last_lnum.lnum, start_col, end_col, mark.hl_group)
end

local function add_conceal_markers()
  api.nvim_buf_clear_namespace(0, org_ns, 0, -1)
  marks = {}

  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  for index, line in ipairs(lines) do
    local match = vim.fn.matchstrpos(line, [[^\*\{1,}\ze\s]])
    local str, start_col, end_col = match[1], match[2], match[3]
    if start_col > -1 and end_col > -1 then
      local level = #str
      local padding = level <= 0 and "" or string.rep(" ", level - 1)
      local symbol = padding .. (symbols[level] or symbols[1]) .. " "
      local highlight = fmt("OrgHeadlineLevel%s", level)
      set_mark({ symbol, highlight }, index - 1, start_col, end_col, highlight)
    end
  end
end

local commands = {
  {
    events = { "InsertLeave", "TextChanged", "TextChangedI" },
    targets = { "<buffer>" },
    command = add_conceal_markers,
  },
}

if in_normal_mode then
  table.insert(commands, {
    events = { "CursorMoved" },
    targets = { "<buffer>" },
    command = function()
      local pos = api.nvim_win_get_cursor(0)
      local lnum = pos[1] - 1
      reapply_previous_extmark(lnum)
      local id = marks[lnum]
      if not id then
        return
      end
      local mark = api.nvim_buf_get_extmark_by_id(0, org_ns, id, { details = true })
      api.nvim_buf_del_extmark(0, org_ns, id)
      if not last_lnum or line_changed(lnum) then
        last_lnum = {
          lnum = lnum,
          mark = mark,
        }
      end
    end,
  })
end

as.augroup("OrgBullets", commands)
add_conceal_markers()
