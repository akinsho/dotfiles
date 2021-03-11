local synIDattr = vim.fn.synIDattr
local hlID = vim.fn.hlID

local M = {}

--- @param win_id integer
function M.has_win_highlight(win_id)
  local win_hl = vim.wo[win_id].winhighlight
  return win_hl ~= nil and win_hl ~= "", win_hl
end

local function find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---@param win_id number
---@param target string
---@param name string
---@param default string
function M.adopt_winhighlight(win_id, target, name, default)
  name = name .. win_id
  local _, win_hl = M.has_win_highlight(win_id)
  local hl_exists = vim.fn.hlexists(name) > 0
  if not hl_exists then
    local parts = vim.split(win_hl, ",")
    local found =
      find(
      parts,
      function(part)
        return part:match(target)
      end
    )
    if found then
      local hl_group = vim.split(found, ":")[2]
      local bg = M.hl_value(hl_group, "bg")
      local fg = M.hl_value(default, "fg")
      local gui = M.hl_value(default, "gui")
      M.highlight(name, {guibg = bg, guifg = fg, gui = gui})
    end
  end
  return name
end

--- TODO eventually move to using `nvim_set_hl`
--- however for the time being that expects colors
--- to be specified as rgb not hex
---@param name string
---@param opts table
function M.highlight(name, opts)
  local force = opts.force or false
  if name and vim.tbl_count(opts) > 0 then
    if opts.link and opts.link ~= "" then
      vim.cmd("highlight" .. (force and "!" or "") .. " link " .. name .. " " .. opts.link)
    else
      local cmd = {"highlight", name}
      if opts.guifg and opts.guifg ~= "" then
        table.insert(cmd, "guifg=" .. opts.guifg)
      end
      if opts.guibg and opts.guibg ~= "" then
        table.insert(cmd, "guibg=" .. opts.guibg)
      end
      if opts.gui and opts.gui ~= "" then
        table.insert(cmd, "gui=" .. opts.gui)
      end
      if opts.guisp and opts.guisp ~= "" then
        table.insert(cmd, "guisp=" .. opts.guisp)
      end
      if opts.cterm and opts.cterm ~= "" then
        table.insert(cmd, "cterm=" .. opts.cterm)
      end
      vim.cmd(table.concat(cmd, " "))
    end
  end
end

function M.hl_value(grp, attr)
  if attr == "gui" then
    return M.gui_attr(grp)
  end
  return synIDattr(hlID(grp), attr)
end

function M.gui_attr(hl_group)
  local bold = M.hl_value(hl_group, "bold")
  local italic = M.hl_value(hl_group, "italic")
  local underline = M.hl_value(hl_group, "underline")
  local gui = {}
  if bold ~= "" and tonumber(bold) > 0 then
    table.insert(gui, "bold")
  end
  if italic ~= "" and tonumber(italic) > 0 then
    table.insert(gui, "italic")
  end
  if underline ~= "" and tonumber(underline) > 0 then
    table.insert(gui, "underline")
  end
  return table.concat(gui, ",")
end

function M.all(hls)
  for _, hl in ipairs(hls) do
    M.highlight(unpack(hl))
  end
end
-----------------------------------------------------------------------------//
-- Color Scheme {{{1
-----------------------------------------------------------------------------//
vim.g.one_allow_italics = 1
vim.cmd [[colorscheme one-nvim]]

-----------------------------------------------------------------------------//
-- One dark
-----------------------------------------------------------------------------//
-- These overrides should be called before the plugin loads
local function one_dark_overrides()
  local override = vim.fn["onedark#extend_highlight"]
  override("Title", {gui = "bold"})
  override("Type", {gui = "italic,bold"})
  override("htmlArg", {gui = "italic,bold"})
  override("Include", {gui = "italic"})
  override("jsImport", {gui = "italic"})
  override("jsExport", {gui = "italic"})
  override("jsExportDefault", {gui = "italic,bold"})
  override("jsFuncCall", {gui = "italic"})
  override("TabLineSel", {bg = {gui = "#61AFEF", cterm = 8}})
  override(
    "SpellRare",
    {
      gui = "undercurl",
      bg = {gui = "transparent", cterm = "NONE"},
      fg = {gui = "transparent", cterm = "NONE"}
    }
  )
end

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
local function plugin_highlights()
  if plugin_loaded("vim-which-key") then
    M.highlight("WhichKeySeperator", {guifg = "LightGreen"})
    M.highlight("WhichKeyFloating", {link = "Normal", force = true})
  end

  if plugin_loaded("conflict-marker.vim") then
    M.all {
      {"ConflictMarkerBegin", {guibg = "#2f7366"}},
      {"ConflictMarkerOurs", {guibg = "#2e5049"}},
      {"ConflictMarkerTheirs", {guibg = "#344f69"}},
      {"ConflictMarkerEnd", {guibg = "#2f628e"}},
      {"ConflictMarkerCommonAncestorsHunk", {guibg = "#754a81"}}
    }
  else
    -- Highlight VCS conflict markers
    vim.cmd [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]
  end
end

local function general_overrides()
  M.all {
    {"Todo", {gui = "bold"}},
    {"Credit", {gui = "bold"}},
    {"CursorLineNr", {guifg = "yellow", gui = "bold"}},
    {"FoldColumn", {guibg = "background"}},
    {"Folded", {link = "Comment", force = true}},
    {"TermCursor", {ctermfg = "green", guifg = "green"}},
    {"MsgSeparator", {link = "Comment"}},
    {"MatchParen", {gui = "bold", guifg = "LightGreen", guibg = "NONE"}},
    {"IncSearch", {guibg = "NONE", guifg = "LightGreen", gui = "italic,bold,underline"}},
    -- Floating window overrides
    {"mkdLineBreak", {link = "None", force = true}},
    {"typescriptParens", {link = "None", force = true}},
    -- Add undercurl to existing spellbad highlight
    {"SpellBad", {gui = "undercurl", guibg = "transparent", guifg = "transparent", guisp = "green"}},
    {"dartStorageClass", {link = "Statement", force = true}},
    -- Customize Diff highlighting
    {"DiffAdd", {guibg = "green", guifg = "NONE"}},
    {"DiffDelete", {guibg = "red", guifg = "#5c6370", gui = "NONE"}},
    {"DiffChange", {guibg = "#344f69", guifg = "NONE"}},
    {"DiffText", {guibg = "#2f628e", guifg = "NONE"}}
    -- NOTE: these highlights are used by fugitive's Git buffer
    --  {"DiffAdded", {link = "DiffAdd", force = true}},
    --  {"DiffRemoved", {link = "DiffAdd", force = true}},
  }
end

-----------------------------------------------------------------------------//
-- Colorscheme highlights
-----------------------------------------------------------------------------//
local function colorscheme_overrides()
  if vim.g.colors_name == "one" then
    local one_highlight = vim.fn["one#highlight"]
    one_highlight("Include", "61afef", "", "italic")
    one_highlight("VertSplit", "2c323c", "bg", "")
    one_highlight("jsImport", "61afef", "", "italic")
    one_highlight("jsExport", "61afef", "", "italic")
    one_highlight("Type", "e5c07b", "", "italic,bold")
    one_highlight("typescriptImport", "c678dd", "", "italic")
    one_highlight("typescriptExport", "61afef", "", "italic")
    one_highlight("vimCommentTitle", "c678dd", "", "bold,italic")
    one_highlight("jsxComponentName", "61afef", "", "bold,italic")
  else -- " No specific colour scheme with overrides then do it manually
    M.all {
      {"jsFuncCall", {gui = "italic"}},
      {"Comment", {gui = "italic", cterm = "italic"}},
      {"xmlAttrib", {gui = "italic,bold", cterm = "italic,bold", ctermfg = 121}},
      {"jsxAttrib", {cterm = "italic,bold", ctermfg = 121}},
      {"Type", {gui = "italic,bold", cterm = "italic,bold"}},
      {"jsThis", {ctermfg = 224, gui = "italic"}},
      {"Include", {gui = "italic", cterm = "italic"}},
      {"jsFuncArgs", {gui = "italic", cterm = "italic", ctermfg = 217}},
      {"jsClassProperty", {ctermfg = 14, cterm = "bold,italic", term = "bold,italic"}},
      {"jsExportDefault", {gui = "italic,bold", cterm = "italic", ctermfg = 179}},
      {"htmlArg", {gui = "italic,bold", cterm = "italic,bold", ctermfg = "yellow"}},
      {"Folded", {gui = "bold,italic", cterm = "bold"}},
      {"typescriptExport", {link = "jsImport"}},
      {"typescriptImport", {link = "jsImport"}}
    }
  end
end

function M.darken_color(color, amount)
  local success, module = pcall(require, "bufferline")
  if not success then
    vim.notify("Failed to load bufferline", 2, {})
    return color
  else
    return module.shade_color(color, amount)
  end
end

local function set_explorer_highlight()
  local normal_bg = M.hl_value("Normal", "bg")
  local split_color = M.hl_value("VertSplit", "fg")
  local bg_color = M.darken_color(normal_bg, -8)
  local st_color = M.darken_color(M.hl_value("Visual", "bg"), -20)
  local hls = {
    {"ExplorerBackground", {guibg = bg_color}},
    {"ExplorerVertSplit", {guifg = split_color, guibg = bg_color}},
    {"ExplorerStNC", {guibg = st_color, cterm = "italic"}},
    {"ExplorerSt", {guibg = st_color}}
  }
  for _, grp in ipairs(hls) do
    M.highlight(unpack(grp))
  end
end

local explorer_fts = {"NvimTree"}

function M.on_explorer_enter()
  local highlights =
    table.concat(
    {
      "Normal:ExplorerBackground",
      "EndOfBuffer:ExplorerBackground",
      "StatusLine:ExplorerSt",
      "StatusLineNC:ExplorerStNC",
      "SignColumn:ExplorerBackground",
      "VertSplit:ExplorerVertSplit"
    },
    ","
  )
  vim.cmd("setlocal winhighlight=" .. highlights)
end

function M.apply_user_highlights()
  plugin_highlights()
  general_overrides()
  colorscheme_overrides()
  set_explorer_highlight()

  if plugin_loaded("onedark.vim") then
    one_dark_overrides()
  end
end

require("as.autocommands").augroup(
  "ExplorerHighlights",
  {
    {
      events = {"VimEnter", "ColorScheme"},
      targets = {"*"},
      command = "lua require('as.highlights').apply_user_highlights()"
    },
    {
      events = {"FileType"},
      targets = explorer_fts,
      command = "lua require('as.highlights').on_explorer_enter()"
    }
  }
)

return M
