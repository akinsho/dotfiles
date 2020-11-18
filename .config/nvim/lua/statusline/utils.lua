local loaded, devicons = pcall(require, "nvim-web-devicons")
local exists = vim.fn.exists
local has = vim.fn.has
local expand = vim.fn.expand

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

function M.is_plain(context)
  return vim.tbl_contains(plain_filetypes, context.filetype) or
    vim.tbl_contains(plain_buftypes, context.buftype) or
    context.preview or
    vim.fn.exists("#goyo") > 0
end

-- This function allow me to specify titles for special case buffers
-- like the preview window or a quickfix window
-- CREDIT: https://vi.stackexchange.com/a/18090
local function special_buffers(context)
  local location_list = vim.fn.getloclist(0, {filewinid = 0})
  local is_loc_list = location_list.filewinid > 0
  local normal_term = context.buftype == "terminal" and context.filetype == ""

  if is_loc_list then
    return "Location List"
  end
  if context.buftype == "quickfix" then
    return "Quickfix"
  end
  if normal_term then
    return "Terminal(" .. vim.fn.fnamemodify(vim.env.SHELL, ":t") .. ")"
  end
  if context.preview then
    return "preview"
  end

  return nil
end

function M.modified(context, icon)
  icon = icon or "✎"
  if context.filetype == "help" then
    return ""
  end
  return context.modified and icon or ""
end

local function readonly(context, icon)
  icon = icon or ""
  if context.filetype == "help" or context.preview or context.readonly then
    return icon
  else
    return ""
  end
end

function M.fileformat(context)
  local format_icon = context.fileformat
  if exists("*WebDevIconsGetFileFormatSymbol") and has("gui_running") then
    format_icon = vim.fn.WebDevIconsGetFileFormatSymbol()
  end
  local icon = context.fileformat .. " " .. format_icon
  return vim.fn.winwidth(0) > 70 and icon or ""
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

local function buf_expand(bufnum, mod)
  return expand("#" .. bufnum .. mod)
end

function M.filename(context, modifier)
  local special_buf = special_buffers(context)
  if special_buf then
    return "", special_buf
  end

  local readonly_indicator = " " .. readonly(context)
  modifier = modifier or ":t"
  local fname = buf_expand(context.bufnum, modifier)

  local name = exceptions.names[context.filetype]
  if type(name) == "function" then
    return "", name(fname, context.bufnum)
  end

  if name then
    return "", name
  end

  if not fname then
    return "", "No Name"
  end

  local directory
  if context.buftype == "" and not context.preview then
    directory = buf_expand(context.bufnum, ":h") .. "/"
  end

  fname = fname .. readonly_indicator
  return (directory or ""), (fname or "")
end

local function or_none(hl)
  return (hl and hl ~= "") and hl or "NONE"
end

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

function M.get_hl_color(hl, attr)
  return vim.fn.synIDattr(vim.fn.hlID(hl), attr)
end

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

function M.filetype(context)
  local ft_exception = exceptions.filetypes[context.filetype]
  if ft_exception then
    return ft_exception, ""
  end
  local bt_exception = exceptions.buftypes[context.buftype]
  if bt_exception then
    return bt_exception, ""
  end
  local icon, hl
  if loaded then
    local extension = vim.fn.fnamemodify(context.bufname, ":e")
    icon, hl = devicons.get_icon(context.bufname, extension, {default = true})
    hl = set_ft_icon_highlight(hl, "Normal")
  end
  return icon, hl
end

function M.encoding(id)
  return vim.fn.winwidth(0) > 70 and (vim.bo[id].fenc or vim.bo[id].enc) or ""
end

function M.line_info()
  return vim.fn.winwidth(0) > 120 and "%.15(%l/%L %p%%%)" or nil
end

-- Sometimes special characters are passed into statusline components
-- this sanitizes theses strings to prevent them mangling the statusline
-- See: https://vi.stackexchange.com/questions/17704/how-to-remove-character-returned-by-system
local function sanitize_string(item)
  return vim.fn.substitute(item, "\n", "", "g")
end

local function truncate_string(item, limit, suffix)
  if not item or item == "" then
    return item
  end
  limit = limit or 50
  suffix = suffix or "…"
  return #item > limit and item:sub(0, limit) .. suffix or item
end

function M.truncate_component(item, limit)
  if not item or item == "" then
    return ""
  end
  limit = limit or 50
  return "%." .. limit .. "(" .. item .. "%)"
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
  local truncated = truncate_string(lsp_status)
  return vim.fn.winwidth(0) > 100 and vim.fn.trim(truncated) and ""
end

function M.current_fn()
  local current = vim.b.coc_current_function or ""
  local sanitized = sanitize_string(current)
  local trunctated = truncate_string(sanitized, 30)
  return vim.fn.winwidth(0) > 140 and vim.fn.trim(trunctated) or ""
end

function M.git_status()
  -- symbol opts -  , "\uf408"
  local prefix = ""
  local window_size = vim.fn.winwidth(0)
  local repo_status = vim.g.coc_git_status or ""
  local buffer_status = vim.fn.trim(vim.b.coc_git_status or "") -- remove excess whitespace

  local parts = vim.split(repo_status, " ")
  if #parts > 0 then
    prefix = parts[1]
    table.remove(parts, 1)
    repo_status = table.concat(parts, " ")
  end

  -- branch name should not exceed 30 chars if the window is under 200 columns
  if window_size < 200 then
    repo_status = M.truncate_component(repo_status, 30)
  end

  local component = repo_status .. " " .. buffer_status
  -- if there is no branch info show nothing
  if not repo_status or window_size < 100 then
    return "", ""
  end
  -- if the window is small drop the buffer changes
  if #component > 30 and window_size < 140 then
    return prefix, repo_status
  end
  return prefix, component
end

function M.hl(hl)
  return "%#" .. hl .. "#"
end

function M.sep(item, opts)
  local before = opts.before or " "
  local prefix = opts.prefix or ""
  local small = opts.small or false
  local padding = opts.padding or "prefix"
  local item_color = opts.color or "%#StItem#"
  local prefix_color = opts.prefix_color or "%#StPrefix#"
  local prefix_sep_color = opts.prefix_sep_color or "%#StPrefixSep#"
  local sep_color = opts.sep_color or "%#StSep#"
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

  return table.concat(
    {
      before,
      sep_color_left,
      sep_icon_left,
      item_color,
      item,
      sep_color,
      sep_icon_right
    }
  )
end

function M.sep_if(item, condition, opts)
  if not condition then
    return ""
  end
  return M.sep(item, opts)
end

function M.item(component, hl, opts)
  if not component or component == "" then
    return ""
  end
  opts = opts or {}
  local before = opts.before or ""
  local after = opts.after or " "
  local prefix = opts.prefix or ""
  local prefix_color = opts.prefix_color or hl
  return table.concat(
    {
      before,
      M.hl(prefix_color),
      prefix,
      " ",
      M.hl(hl),
      component,
      after,
      "%*"
    }
  )
end

function M.item_if(item, condition, hl, opts)
  if not condition then
    return ""
  end
  return M.item(item, hl, opts)
end

return M
