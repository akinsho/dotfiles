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

local marks = {}

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
      local id = api.nvim_buf_set_extmark(0, org_ns, index - 1, start_col, {
        end_col = end_col,
        hl_group = highlight,
        virt_text = { { symbol, highlight } },
        virt_text_pos = "overlay",
        hl_mode = "combine",
      })
      marks[index] = id
    end
  end
end

add_conceal_markers()

as.augroup("OrgBullets", {
  {
    events = { "InsertLeave", "TextChanged", "TextChangedI" },
    targets = { "<buffer>" },
    command = add_conceal_markers,
  },
  -- TODO: add functionality to remove extmarks whilst on a given line, like conceal cursor
  -- {
  --   events = { "CursorMoved" },
  --   targets = { "<buffer>" },
  --   command = function()
  --     local lnum = fn.line "."
  --     local id = marks[lnum]
  --     if not id then
  --       return
  --     end
  --     local mark = api.nvim_buf_get_extmark_by_id(0, org_ns, id, { details = true })
  --   end,
  -- },
})
