local loaded, devicons = pcall(require, "nvim-web-devicons")
local palette = require("akinsho.statusline.palette")
local H = require("akinsho.highlights")

local fn = vim.fn
local exists = fn.exists
local expand = fn.expand
local strwidth = fn.strwidth
local fnamemodify = fn.fnamemodify
local contains = vim.tbl_contains

local M = {}
local highlight_cache = {}

local function get_toggleterm_name(_, bufnum)
  local shell = fnamemodify(vim.env.SHELL, ":t")
  local terminal_prefix = "Terminal(" .. shell .. ")["
  return terminal_prefix .. fn.getbufvar(bufnum, "toggle_number") .. "]"
end

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

local function sum_lengths(tbl)
  local length = 0
  for _, c in ipairs(tbl) do
    if c.length then
      length = c.length + length
    end
  end
  return length
end

local function is_lowest(item, lowest)
  -- if there hasn't been a lowest selected so far
  -- then the item is the lowest
  if not lowest or not lowest.length then
    return true
  end
  -- if the item doesn't have a priority or a length
  -- it is likely a special character so should never
  -- be the lowest
  if not item.priority or not item.length then
    return false
  end
  -- if the item has the same priority as the lowest then if the item
  -- has a greater length it should become the lowest
  if item.priority == lowest.priority then
    return item.length > lowest.length
  end

  return item.priority > lowest.priority
end

--- Take the lowest priority items out of the statusline if we don't have
--- space for them.
--- TODO currently this doesn't account for if an item that has a lower priority
--- could be fit in instead
--- @param statusline table
--- @param space number
--- @param length number
function M.prioritize(statusline, space, length)
  length = length or sum_lengths(statusline)
  if length <= space then
    return statusline
  end
  local lowest
  local index_to_remove
  for idx, c in ipairs(statusline) do
    if is_lowest(c, lowest) then
      lowest = c
      index_to_remove = idx
    end
  end
  table.remove(statusline, index_to_remove)
  return M.prioritize(statusline, space, length - lowest.length)
end

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
  local location_list = fn.getloclist(0, {filewinid = 0})
  local is_loc_list = location_list.filewinid > 0
  local normal_term = ctx.buftype == "terminal" and ctx.filetype == ""

  if is_loc_list then
    return "Location List"
  end
  if ctx.buftype == "quickfix" then
    return "Quickfix"
  end
  if normal_term then
    return "Terminal(" .. fnamemodify(vim.env.SHELL, ":t") .. ")"
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
    return " " .. icon
  else
    return ""
  end
end

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

  local readonly_indicator = readonly(ctx)
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

--- @param hl string
--- @param attr string
function M.get_hl_color(hl, attr)
  return fn.synIDattr(fn.hlID(hl), attr)
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
    local extension = fnamemodify(ctx.bufname, ":e")
    icon, hl = devicons.get_icon(ctx.bufname, extension, {default = true})
    hl = set_ft_icon_highlight(hl, "Normal")
  end
  return icon, hl
end

--- This function gets and decorates the current and total line count
--- it derives this using the line() function rather than the %l/%L statusline
--- format strings because these cannot be
-- @param opts table
function M.line_info(opts)
  local sep = opts.sep or "/"
  local prefix = opts.prefix or "L"
  local prefix_color = opts.prefix_color or "StMetadataPrefix"
  local current_hl = opts.current_hl or "Title"
  local total_hl = opts.total_hl or "Comment"
  local sep_hl = opts.total_hl or "NonText"

  local current = fn.line(".")
  local last = fn.line("$")

  local length = strwidth(prefix .. current .. sep .. last)
  return {
    table.concat(
      {
        " ",
        M.wrap(prefix_color),
        prefix,
        " ",
        M.wrap(current_hl),
        current,
        M.wrap(sep_hl),
        sep,
        M.wrap(total_hl),
        last,
        " "
      }
    ),
    length
  }
end

-- Sometimes special characters are passed into statusline components
-- this sanitizes theses strings to prevent them mangling the statusline
-- See: https://vi.stackexchange.com/questions/17704/how-to-remove-character-returned-by-system
local function sanitize_string(item)
  return fn.substitute(item, "\n", "", "g")
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
  return fn.trim(sanitized)
end

--- @param result table
local function git_read(result)
  return function(_, data, _)
    for _, v in ipairs(data) do
      if v and v ~= "" then
        table.insert(result, v)
      end
    end
  end
end

--- @param result table
local function git_update_status(result)
  return function(_, code, _)
    if code == 0 and result and #result > 0 then
      local parts = vim.split(result[1], "\t")
      if parts and #parts > 1 then
        local formatted = {behind = parts[1], ahead = parts[2]}
        vim.g.git_statusline_updates = formatted
      end
    end
  end
end

local function git_update_job()
  local cmd = "git rev-list --count --left-right @{upstream}...HEAD"
  local result = {}
  return fn.jobstart(
    cmd,
    {
      on_stdout = git_read(result),
      on_exit = git_update_status(result)
    }
  )
end

local function is_git_repo()
  return fn.isdirectory(fn.getcwd() .. "/" .. ".git")
end

function M.git_updates_refresh()
  git_update_job()
end

function M.git_update_toggle()
  local on = is_git_repo()
  if on then
    M.git_updates()
  end
  local status = on and 0 or 1
  fn.timer_pause(vim.g.git_statusline_updates_timer, status)
end

--- starts a timer to check for the whether
--- we are currently ahead or behind upstream
function M.git_updates()
  local pending_job
  git_update_job()
  local timer =
    vim.fn.timer_start(
    30000,
    function()
      -- clear previous job
      if pending_job then
        vim.fn.jobstop(pending_job)
      end
      pending_job = git_update_job()
    end,
    {["repeat"] = -1}
  )
  vim.g.git_statusline_updates_timer = timer
end

function M.git_status()
  -- symbol opts -  , "\uf408"
  if vim.g.coc_git_status then
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
  elseif vim.b.gitsigns_status then
    return "", vim.b.gitsigns_status
  end
end

local function mode_highlight(mode)
  local visual_regex = vim.regex([[\(v\|V\|\)]])
  local command_regex = vim.regex([[\(c\|cv\|ce\)]])
  local inc_search_bg = M.get_hl_color("Search", "bg")
  if mode == "i" then
    H.highlight("StModeText", {guifg = palette.dark_blue, gui = "bold"})
  elseif visual_regex:match_str(mode) then
    H.highlight("StModeText", {guifg = palette.magenta, gui = "bold"})
  elseif mode == "R" then
    H.highlight("StModeText", {guifg = palette.dark_red, gui = "bold"})
  elseif command_regex:match_str(mode) then
    H.highlight("StModeText", {guifg = inc_search_bg, gui = "bold"})
  else
    H.highlight("StModeText", {guifg = palette.green, gui = "bold"})
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
  opts = opts or {}
  opts.before = opts.before or " "
  opts.prefix = opts.prefix or ""
  opts.small = opts.small or false
  opts.padding = opts.padding or "prefix"
  opts.color = M.wrap(opts.color or "StItem")
  opts.prefix_color = M.wrap(opts.prefix_color or "StPrefix")
  opts.prefix_sep_color = M.wrap(opts.prefix_sep_color or "StPrefixSep")
  opts.sep_color = M.wrap(opts.sep_color or "StSep")
  opts.sep_color_left = opts.prefix and opts.prefix_sep_color or opts.sep_color
  opts.prefix_item = opts.prefix_color .. opts.prefix

  -- depending on how padding is specified extra space
  -- will be injected at specific points
  if opts.padding == "prefix" or opts.padding == "full" then
    opts.prefix_item = opts.prefix_item .. " "
  end

  if opts.padding == "full" then
    item = " " .. item
  end

  -- %* resets the highlighting at the end of the separator so it
  -- doesn't interfere with the next component
  local sep_icon_right = opts.small and "%*" or "█%*"
  local sep_icon_left =
    opts.prefix ~= "" and "" .. opts.prefix_item or opts.small and "" or "█"

  local parts = {
    opts.before,
    opts.sep_color_left,
    sep_icon_left,
    opts.color,
    item,
    opts.sep_color,
    sep_icon_right
  }

  return {
    table.concat(parts),
    #item + strwidth(sep_icon_left) + strwidth(sep_icon_right)
  }
end

--- Creates a spacer statusline component i.e. for padding
--- or to represent an empty component
--- @param size number
--- @param filler string | nil
function M.spacer(size, filler)
  filler = filler or " "
  if size and size >= 1 then
    local spacer = string.rep(filler, size)
    return {spacer, #spacer}
  else
    return {"", 0}
  end
end

--- @param item string
--- @param condition boolean
--- @param opts table
function M.sep_if(item, condition, opts)
  if not condition then
    return M.spacer()
  end
  return M.sep(item, opts)
end

--- @param component string
--- @param hl string
--- @param opts table
function M.item(component, hl, opts)
  if not component or component == "" then
    return M.spacer()
  end
  opts = opts or {}
  local before = opts.before or ""
  local after = opts.after or " "
  local prefix = opts.prefix or ""

  local prefix_color = opts.prefix_color or hl
  prefix = prefix ~= "" and M.wrap(prefix_color) .. prefix .. " " or ""

  --- handle numeric inputs etc.
  if type(component) ~= "string" then
    component = tostring(component)
  end

  local parts = {
    before,
    prefix,
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
    return M.spacer()
  end
  return M.item(item, hl, opts)
end

return M
