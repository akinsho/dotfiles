local loaded, devicons = pcall(require, "nvim-web-devicons")
local palette = require "statusline/palette"

local exists = vim.fn.exists
local expand = vim.fn.expand
local strwidth = vim.fn.strwidth
local contains = vim.tbl_contains

local highlight_cache = {}

local M = {}

local plain_filetypes = {
  "help",
  "ctrlsf",
  "minimap",
  "tsplayground",
  "coc-explorer",
  "LuaTree",
  "undotree",
  "neoterm",
  "vista",
  "fugitive",
  "startify",
  "vimwiki",
  "markdown"
}

local plain_buftypes = {
  "terminal",
  "quickfix",
  "nofile",
  "nowrite",
  "acwrite"
}

--- @param value table
local function serialize(value)
  if type(value) ~= "table" then
    return value
  end
  local key = ""
  for _, v in pairs(value) do
    key = key .. v.component
  end
  return key
end

local function sum_lengths(tbl)
  local length = 0
  for _, c in ipairs(tbl) do
    if c.length then
      length = c.length + length
    end
  end
  return length
end

--- memoizing a function in lua
--- https://stackoverflow.com/a/141689
local function memoize(fn)
  local cache = {}
  setmetatable(cache, {__mode = "v"}) -- make values weak
  return function(stl, space, length)
    local key =
      table.concat(
      {
        serialize(stl),
        tostring(space),
        tostring(length)
      },
      "-"
    )
    if cache[key] then
      return cache[key]
    else
      local y = fn(stl, space, length)
      cache[key] = y
      return y
    end
  end
end

--- Take the lowest priority items out of the statusline if we don't have
--- space for them.
--- TODO currently this doesn't account for if an item that has a lower priority
--- could be fit in instead
--- @param statusline table
--- @param space number
--- @param length number
local function prioritize(statusline, space, length)
  length = length or sum_lengths(statusline)
  if length <= space then
    return statusline
  end
  local lowest
  local index_to_remove
  for idx, c in ipairs(statusline) do
    if c.priority and (not lowest or c.priority > lowest.priority) then
      lowest = c
      index_to_remove = idx
    end
  end
  table.remove(statusline, index_to_remove)
  return prioritize(statusline, space, length - lowest.length)
end

M.prioritize = memoize(prioritize)

--- @param ctx table
function M.is_plain(ctx)
  return contains(plain_filetypes, ctx.filetype) or
    contains(plain_buftypes, ctx.buftype) or
    ctx.preview or
    exists("#goyo") > 0
end

--- This function allow me to specify titles for special case buffers
--- like the preview window or a quickfix window
--- CREDIT: https://vi.stackexchange.com/a/18090
--- @param ctx table
local function special_buffers(ctx)
  local location_list = vim.fn.getloclist(0, {filewinid = 0})
  local is_loc_list = location_list.filewinid > 0
  local normal_term = ctx.buftype == "terminal" and ctx.filetype == ""

  if is_loc_list then
    return "Location List"
  end
  if ctx.buftype == "quickfix" then
    return "Quickfix"
  end
  if normal_term then
    return "Terminal(" .. vim.fn.fnamemodify(vim.env.SHELL, ":t") .. ")"
  end
  if ctx.preview then
    return "preview"
  end

  return nil
end

--- @param ctx table
--- @param icon string | nil
function M.modified(ctx, icon)
  icon = icon or "✎"
  if ctx.filetype == "help" then
    return ""
  end
  return ctx.modified and icon or ""
end

--- @param ctx table
--- @param icon string | nil
local function readonly(ctx, icon)
  icon = icon or ""
  if ctx.filetype == "help" or ctx.preview or ctx.readonly then
    return icon
  else
    return ""
  end
end

local function get_toggleterm_name(_, bufnum)
  local shell = vim.fn.fnamemodify(vim.env.SHELL, ":t")
  local terminal_prefix = "Terminal(" .. shell .. ")["
  return terminal_prefix .. vim.fn.getbufvar(bufnum, "toggle_number") .. "]"
end

local exceptions = {
  buftypes = {
    terminal = " ",
    quickfix = ""
  },
  filetypes = {
    dbui = "",
    vista = "פּ",
    tsplayground = "侮",
    fugitive = "",
    fugitiveblame = "",
    gitcommit = "",
    startify = "",
    defx = "⌨",
    ctrlsf = "🔍",
    ["vim-plug"] = "⚉",
    vimwiki = "ﴬ",
    help = "",
    undotree = "פּ",
    ["coc-explorer"] = "",
    LuaTree = "פּ",
    toggleterm = " ",
    calendar = ""
  },
  names = {
    minimap = "minimap",
    dbui = "Dadbod UI",
    tsplayground = "Treesitter",
    vista = "Vista",
    fugitive = "Fugitive",
    fugitiveblame = "Git blame",
    gitcommit = "Git commit",
    startify = "Startify",
    defx = "Defx",
    ctrlsf = "CtrlSF",
    ["vim-plug"] = "vim plug",
    vimwiki = "vim wiki",
    help = "help",
    undotree = "UndoTree",
    ["coc-explorer"] = "Coc Explorer",
    LuaTree = "Lua Tree",
    toggleterm = get_toggleterm_name
  }
}

--- @param bufnum number
--- @param mod string
local function buf_expand(bufnum, mod)
  return expand("#" .. bufnum .. mod)
end

--- @param ctx table
--- @param modifier string
function M.filename(ctx, modifier)
  local special_buf = special_buffers(ctx)
  if special_buf then
    return "", special_buf
  end

  local readonly_indicator = " " .. readonly(ctx)
  modifier = modifier or ":t"
  local fname = buf_expand(ctx.bufnum, modifier)

  local name = exceptions.names[ctx.filetype]
  if type(name) == "function" then
    return "", name(fname, ctx.bufnum)
  end

  if name then
    return "", name
  end

  if not fname then
    return "", "No Name"
  end

  local directory
  if ctx.buftype == "" and not ctx.preview then
    directory = buf_expand(ctx.bufnum, ":h") .. "/"
  end

  fname = fname .. readonly_indicator
  return (directory or ""), (fname or "")
end

--- @param hl string | nil
local function or_none(hl)
  return (hl and hl ~= "") and hl or "NONE"
end

--- @param name string
--- @param hl table
function M.set_highlight(name, hl)
  if hl and vim.tbl_count(hl) > 0 then
    local cmd = "highlight! " .. name
    cmd = cmd .. " " .. "gui=" .. or_none(hl.gui)
    cmd = cmd .. " " .. "guifg=" .. or_none(hl.guifg)
    cmd = cmd .. " " .. "guibg=" .. or_none(hl.guibg)
    -- TODO using api here as it warns of an error if setting highlight fails
    local success, err = pcall(vim.api.nvim_command, cmd)
    if not success then
      vim.api.nvim_err_writeln(
        "Failed setting " ..
          name ..
            " highlight, something isn't configured correctly" .. "\n" .. err
      )
    end
  end
end

--- @param hl string
--- @param attr string
function M.get_hl_color(hl, attr)
  return vim.fn.synIDattr(vim.fn.hlID(hl), attr)
end

--- @param hl string
--- @param bg_hl string
local function set_ft_icon_highlight(hl, bg_hl)
  if not hl then
    return ""
  end
  local name = hl .. "Statusline"
  -- prevent recreating highlight group for every buffer instead save
  -- the newly created highlight name's status i.e. created or not
  local created = highlight_cache[name]

  if created then
    return name
  end
  local bg_color = M.get_hl_color(bg_hl, "bg")
  local fg_color = M.get_hl_color(hl, "fg")
  if bg_color and fg_color then
    local cmd = {"highlight ", name, " guibg=", bg_color, " guifg=", fg_color}
    local str = table.concat(cmd)
    vim.cmd(string.format("silent execute '%s'", str))
    vim.cmd("augroup " .. name)
    vim.cmd("autocmd!")
    vim.cmd("autocmd ColorScheme * " .. str)
    vim.cmd("augroup END")
    highlight_cache[name] = true
  end
  return name
end

--- @param ctx table
function M.filetype(ctx)
  local ft_exception = exceptions.filetypes[ctx.filetype]
  if ft_exception then
    return ft_exception, ""
  end
  local bt_exception = exceptions.buftypes[ctx.buftype]
  if bt_exception then
    return bt_exception, ""
  end
  local icon, hl
  if loaded then
    local extension = vim.fn.fnamemodify(ctx.bufname, ":e")
    icon, hl = devicons.get_icon(ctx.bufname, extension, {default = true})
    hl = set_ft_icon_highlight(hl, "Normal")
  end
  return icon, hl
end

--- @param id number
function M.encoding(id)
  return vim.fn.winwidth(0) > 70 and (vim.bo[id].fenc or vim.bo[id].enc) or ""
end

function M.line_info()
  return "%.15(%l/%L %p%%%)"
end

-- Sometimes special characters are passed into statusline components
-- this sanitizes theses strings to prevent them mangling the statusline
-- See: https://vi.stackexchange.com/questions/17704/how-to-remove-character-returned-by-system
local function sanitize_string(item)
  return vim.fn.substitute(item, "\n", "", "g")
end

function M.diagnostic_info()
  local msgs = {error = nil, warning = nil, information = nil}
  local info = vim.b.coc_diagnostic_info
  if not info then
    return msgs
  end
  local warning_sign = vim.g.coc_status_warning_sign or "W"
  local error_sign = vim.g.coc_status_error_sign or "E"
  local information_sign = vim.g.coc_status_information_sign or ""

  if info.error > 0 then
    msgs.error = error_sign .. info.error
  end
  if info.warning > 0 then
    msgs.warning = warning_sign .. info.warning
  end
  if info.information > 0 then
    msgs.information = information_sign .. info.information
  end
  return msgs
end

function M.lsp_status()
  local lsp_status = vim.g.coc_status or ""
  return vim.fn.trim(lsp_status)
end

function M.current_fn()
  local current = vim.b.coc_current_function or ""
  local sanitized = sanitize_string(current)
  return vim.fn.trim(sanitized)
end

function M.git_status()
  -- symbol opts -  , "\uf408"
  local prefix = ""
  local repo_status = vim.g.coc_git_status or ""
  local buffer_status = vim.fn.trim(vim.b.coc_git_status or "") -- remove excess whitespace

  local parts = vim.split(repo_status, " ")
  if #parts > 0 then
    prefix = parts[1]
    table.remove(parts, 1)
    repo_status = table.concat(parts, " ")
  end

  local component = repo_status .. " " .. buffer_status
  -- if there is no branch info show nothing
  if not repo_status then
    return "", ""
  end
  return prefix, component
end

local function mode_highlight(mode)
  local visual_regex = vim.regex([[\(v\|V\|\)]])
  local command_regex = vim.regex([[\(c\|cv\|ce\)]])
  local inc_search_bg = M.get_hl_color("Search", "bg")
  if mode == "i" then
    M.set_highlight("StModeText", {guifg = palette.dark_blue, gui = "bold"})
  elseif visual_regex:match_str(mode) then
    M.set_highlight("StModeText", {guifg = palette.magenta, gui = "bold"})
  elseif mode == "R" then
    M.set_highlight("StModeText", {guifg = palette.dark_red, gui = "bold"})
  elseif command_regex:match_str(mode) then
    M.set_highlight("StModeText", {guifg = inc_search_bg, gui = "bold"})
  else
    M.set_highlight("StModeText", {guifg = palette.green, gui = "bold"})
  end
end

function M.mode()
  local current_mode = vim.fn.mode()
  mode_highlight(current_mode)

  local mode_map = {
    ["n"] = "NORMAL",
    ["no"] = "N·OPERATOR PENDING ",
    ["v"] = "VISUAL",
    ["V"] = "V·LINE",
    [""] = "V·BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S·LINE",
    ["^S"] = "S·BLOCK",
    ["i"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rv"] = "V·REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "VIM EX",
    ["ce"] = "EX",
    ["r"] = "PROMPT",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL"
  }
  return mode_map[current_mode] or "UNKNOWN"
end

--- @param hl string
function M.wrap(hl)
  return "%#" .. hl .. "#"
end

--- @param item string
--- @param opts table
function M.sep(item, opts)
  local before = opts.before or " "
  local prefix = opts.prefix or ""
  local small = opts.small or false
  local padding = opts.padding or "prefix"
  local item_color = opts.color or "StItem"
  local prefix_color = opts.prefix_color or "StPrefix"
  local prefix_sep_color = opts.prefix_sep_color or "StPrefixSep"
  local sep_color = opts.sep_color or "StSep"
  local sep_color_left = prefix and prefix_sep_color or sep_color
  local prefix_item = prefix_color .. prefix
  -- depending on how padding is specified extra space
  -- will be injected at specific points
  if padding == "prefix" or padding == "full" then
    prefix_item = prefix_item .. " "
  end

  if padding == "full" then
    item = " " .. item
  end

  -- %* resets the highlighting at the end of the separator so it
  -- doesn't interfere with the next component
  local sep_icon_right = small and "%*" or "█%*"
  local sep_icon_left =
    prefix ~= "" and "" .. prefix_item or small and "" or "█"

  local parts = {
    before,
    M.wrap(sep_color_left),
    sep_icon_left,
    M.wrap(item_color),
    item,
    M.wrap(sep_color),
    sep_icon_right
  }

  return {
    table.concat(parts),
    #item + strwidth(sep_icon_left) + strwidth(sep_icon_right)
  }
end

--- @param item string
--- @param condition boolean
--- @param opts table
function M.sep_if(item, condition, opts)
  if not condition then
    return {"", 0}
  end
  return M.sep(item, opts)
end

--- @param component string
--- @param hl string
--- @param opts table
function M.item(component, hl, opts)
  if not component or component == "" then
    return {"", 0}
  end
  opts = opts or {}
  local before = opts.before or ""
  local after = opts.after or " "
  local prefix = opts.prefix or ""

  local prefix_color = opts.prefix_color or hl
  prefix = prefix ~= "" and M.wrap(prefix_color) .. prefix or ""

  --- handle numeric inputs etc.
  if type(component) ~= "string" then
    component = tostring(component)
  end

  local parts = {
    before,
    prefix,
    " ",
    M.wrap(hl),
    component,
    after,
    "%*"
  }
  return {table.concat(parts), #component}
end

--- @param item string
--- @param condition boolean
--- @param hl string
--- @param opts table
function M.item_if(item, condition, hl, opts)
  if not condition then
    return {"", 0}
  end
  return M.item(item, hl, opts)
end

return M
