local fn = vim.fn
local api = vim.api
local fmt = string.format

local M = {}

local ts_playground_loaded, ts_hl_info

-----------------------------------------------------------------------------//
-- CREDIT: @Cocophon
-- This function allows you to see the syntax highlight token of the cursor word and that token's links
---> https://github.com/cocopon/pgmnt.vim/blob/master/autoload/pgmnt/dev.vim
-----------------------------------------------------------------------------//
local function hi_chain(syn_id)
  local name = fn.synIDattr(syn_id, "name")
  local names = {}
  table.insert(names, name)
  local original = fn.synIDtrans(syn_id)
  if syn_id ~= original then
    table.insert(names, fn.synIDattr(original, "name"))
  end

  return names
end

function M.token_inspect()
  if not ts_playground_loaded then
    ts_playground_loaded, ts_hl_info = pcall(require, "nvim-treesitter-playground.hl-info")
  end
  if vim.tbl_contains(as.ts.get_filetypes(), vim.bo.filetype) then
    ts_hl_info.show_hl_captures()
  else
    local syn_id = fn.synID(fn.line("."), fn.col("."), 1)
    local names = hi_chain(syn_id)
    as.echomsg(fn.join(names, " -> "))
  end
end

--- Check if the current window has a winhighlight
--- which includes the specific target highlight
--- @param win_id integer
--- @vararg string
function M.has_win_highlight(win_id, ...)
  local win_hl = vim.wo[win_id].winhighlight
  local has_match = false
  for _, target in ipairs({...}) do
    if win_hl:match(target) ~= nil then
      has_match = true
      break
    end
  end
  return (win_hl ~= nil and has_match), win_hl
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

---A mechanism to allow inheritance of the winhighlight of a specific
---group in a window
---@param win_id number
---@param target string
---@param name string
---@param default string
function M.adopt_winhighlight(win_id, target, name, default)
  name = name .. win_id
  local _, win_hl = M.has_win_highlight(win_id, target)
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
  local keys = {guifg = true, guibg = true, guisp = true, gui = true, cterm = true}
  local force = opts.force or false
  if name and vim.tbl_count(opts) > 0 then
    if opts.link and opts.link ~= "" then
      vim.cmd("highlight" .. (force and "!" or "") .. " link " .. name .. " " .. opts.link)
    else
      local cmd = {"highlight", name}
      for k, v in pairs(opts) do
        if keys[k] and keys[k] ~= "" then
          table.insert(cmd, fmt("%s=", k) .. v)
        end
      end
      vim.cmd(table.concat(cmd, " "))
    end
  end
end

local gui_attr = {"underline", "bold", "undercurl", "italic"}
local attrs = {fg = "foreground", bg = "background"}

---get the color value of part of a highlight group
---@param grp string
---@param attr string
---@param fallback string
---@return string
function M.hl_value(grp, attr, fallback)
  attr = attrs[attr] or attr
  local hl = api.nvim_get_hl_by_name(grp, true)
  if attr == "gui" then
    local gui = {}
    for name, value in pairs(hl) do
      if value and vim.tbl_contains(gui_attr, name) then
        table.insert(gui, name)
      end
    end
    return table.concat(gui, ",")
  end
  local color = hl[attr] or fallback
  -- convert the decimal rgba value from the hl by name to a 6 character hex + padding if needed
  if not color then
    vim.notify(fmt("%s %s does not exist", grp, attr))
    return "NONE"
  end
  return "#" .. bit.tohex(color, 6)
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
vim.cmd [[colorscheme doom-one]]

---------------------------------------------------------------------------------
-- Plugin highlights
---------------------------------------------------------------------------------
local function plugin_highlights()
  if plugin_loaded("telescope.nvim") then
    M.highlight("TelescopePathSeparator", {link = "Directory"})
    M.highlight("TelescopeQueryFilter", {link = "IncSearch"})
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
  local cursor_line_bg = M.hl_value("CursorLine", "bg")
  local comment_fg = M.hl_value("Comment", "fg")
  local msg_area_bg = M.darken_color(M.hl_value("Normal", "bg"), -10)
  M.all {
    {"Todo", {guibg = "Red", guifg = "bg", gui = "bold"}},
    {"mkdLineBreak", {link = "NONE", force = true}},
    -----------------------------------------------------------------------------//
    -- Commandline
    -----------------------------------------------------------------------------//
    {"MsgArea", {guibg = msg_area_bg}},
    {"MsgSeparator", {guifg = comment_fg, guibg = msg_area_bg}},
    -----------------------------------------------------------------------------//
    {"CursorLineNr", {guifg = "yellow", gui = "bold"}},
    {"FoldColumn", {guibg = "background"}},
    {"Folded", {link = "Comment", force = true}},
    {"TermCursor", {ctermfg = "green", guifg = "royalblue"}},
    {"IncSearch", {guibg = "NONE", guifg = "LightGreen", gui = "italic,bold,underline"}},
    {"Substitute", {guifg = comment_fg, guibg = "NONE", gui = "strikethrough,bold"}},
    {"Error", {link = "WarningMsg", force = true}},
    {"ErrorMsg", {guibg = "NONE"}}, -- set the error message background to match the msg area
    -- Add undercurl to existing spellbad highlight
    {"SpellBad", {gui = "undercurl", guibg = "transparent", guifg = "transparent", guisp = "green"}},
    -----------------------------------------------------------------------------//
    -- Diff
    -----------------------------------------------------------------------------//
    {"DiffAdd", {guibg = "green", guifg = "NONE"}},
    {"DiffDelete", {guibg = "red", guifg = "#5c6370", gui = "NONE"}},
    {"DiffChange", {guibg = "#344f69", guifg = "NONE"}},
    {"DiffText", {guibg = "#2f628e", guifg = "NONE"}},
    -- colorscheme overrides
    {"Comment", {gui = "italic", cterm = "italic"}},
    {"Type", {gui = "italic,bold", cterm = "italic,bold"}},
    {"Include", {gui = "italic", cterm = "italic"}},
    {"Folded", {gui = "bold,italic", cterm = "bold"}},
    -----------------------------------------------------------------------------//
    -- Treesitter
    -----------------------------------------------------------------------------//
    {"TSKeyword", {link = "Statement"}},
    {"TSParameter", {gui = "italic,bold"}},
    -- highlight FIXME comments
    {"TSDanger", {guibg = "#FBBF24", guifg = "bg", gui = "bold"}},
    -----------------------------------------------------------------------------//
    -- LSP
    -----------------------------------------------------------------------------//
    {"LspReferenceText", {guibg = cursor_line_bg, gui = "underline"}},
    {"LspReferenceRead", {guibg = cursor_line_bg, gui = "underline"}},
    {"LspDiagnosticsSignHint", {guifg = "#FAB005"}},
    {"LspDiagnosticsDefaultHint", {guifg = "#FAB005"}},
    {"LspDiagnosticsDefaultError", {guifg = "#E06C75"}},
    {"LspDiagnosticsDefaultWarning", {guifg = "#FF922B"}},
    {"LspDiagnosticsDefaultInformation", {guifg = "#15AABF"}},
    {"LspDiagnosticsUnderlineError", {gui = "undercurl", guisp = "#E06C75", guifg = "none"}},
    {"LspDiagnosticsUnderlineHint", {gui = "undercurl", guisp = "#FAB005", guifg = "none"}},
    {"LspDiagnosticsUnderlineWarning", {gui = "undercurl", guisp = "orange", guifg = "none"}},
    {"LspDiagnosticsUnderlineInformation", {gui = "undercurl", guisp = "#15AABF", guifg = "none"}},
    {"LspDiagnosticsFloatingWarning", {guibg = "NONE"}},
    {"LspDiagnosticsFloatingError", {guibg = "NONE"}},
    {"LspDiagnosticsFloatingHint", {guibg = "NONE"}},
    {"LspDiagnosticsFloatingInformation", {guibg = "NONE"}},
    -----------------------------------------------------------------------------//
    -- Notifications
    -----------------------------------------------------------------------------//
    {"NvimNotificationError", {link = "ErrorMsg"}},
    {"NvimNotificationInfo", {guifg = "#51afef"}}
  }
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

local function set_sidebar_highlight()
  local normal_bg = M.hl_value("Normal", "bg")
  local split_color = M.hl_value("VertSplit", "fg")
  local bg_color = M.darken_color(normal_bg, -8)
  local st_color = M.darken_color(M.hl_value("Visual", "bg"), -20)
  local hls = {
    {"PanelBackground", {guibg = bg_color}},
    {"PanelHeading", {guibg = bg_color, gui = "bold"}},
    {"PanelVertSplit", {guifg = split_color, guibg = bg_color}},
    {"PanelStNC", {guibg = st_color, cterm = "italic"}},
    {"PanelSt", {guibg = st_color}}
  }
  for _, grp in ipairs(hls) do
    M.highlight(unpack(grp))
  end
end

local sidebar_fts = {"NvimTree", "dap-repl"}

function M.on_sidebar_enter()
  local highlights =
    table.concat(
    {
      "Normal:PanelBackground",
      "EndOfBuffer:PanelBackground",
      "StatusLine:PanelSt",
      "StatusLineNC:PanelStNC",
      "SignColumn:PanelBackground",
      "VertSplit:PanelVertSplit"
    },
    ","
  )
  vim.cmd("setlocal winhighlight=" .. highlights)
end

function M.clear_hl(name)
  if not name then
    return
  end
  vim.cmd(fmt("highlight clear %s", name))
end

local function colorscheme_overrides()
  local keyword_fg = M.hl_value("Keyword", "fg")
  if vim.g.colors_name == "doom-one" then
    M.all {
      {"TSVariable", {guifg = "NONE"}},
      {"WhichKeyFloat", {link = "PanelBackground"}},
      {"Cursor", {guibg = keyword_fg, gui = "NONE"}}
    }
  end
end

function M.apply_user_highlights()
  plugin_highlights()
  general_overrides()
  colorscheme_overrides()
  set_sidebar_highlight()
end

as.augroup(
  "PanelHighlights",
  {
    {
      events = {"VimEnter", "ColorScheme"},
      targets = {"*"},
      command = "lua require('as.highlights').apply_user_highlights()"
    },
    {
      events = {"FileType"},
      targets = sidebar_fts,
      command = "lua require('as.highlights').on_sidebar_enter()"
    }
  }
)

return M
