local fn = vim.fn
local api = vim.api
local expand = fn.expand
local strwidth = api.nvim_strwidth
local fnamemodify = fn.fnamemodify
local luv = vim.loop
local fmt = string.format
local empty = as.empty
local win_hl = as.highlight.win_hl

local M = {}

local constants = {
  HL_END = '%*',
  ALIGN = '%=',
  END = '%<',
  CLICK_END = '%X',
}

M.constants = constants

local function get_toggleterm_name(_, buf)
  local shell = fnamemodify(vim.env.SHELL, ':t')
  return fmt('Terminal(%s)[%s]', shell, api.nvim_buf_get_var(buf, 'toggle_number'))
end

-- Capture the type of the neo tree buffer opened
local function get_neotree_name(fname, _)
  local parts = vim.split(fname, ' ')
  return fmt('Neo Tree(%s)', parts[2])
end

local plain = {
  filetypes = {
    'help',
    'minimap',
    'Trouble',
    'tsplayground',
    'NvimTree',
    'undotree',
    'neoterm',
    'startify',
    'markdown',
    'norg',
    'neo-tree',
    'NeogitStatus',
    'dap-repl',
    'dapui',
  },
  buftypes = {
    'terminal',
    'quickfix',
    'nofile',
    'nowrite',
    'acwrite',
  },
}

local exceptions = {
  buftypes = {
    terminal = ' ',
    quickfix = '',
  },
  filetypes = {
    ['org'] = '',
    ['orgagenda'] = '',
    ['himalaya-msg-list'] = '',
    ['mail'] = '',
    ['dbui'] = '',
    ['DiffviewFiles'] = 'פּ',
    ['tsplayground'] = '侮',
    ['Trouble'] = '',
    ['NeogitStatus'] = '', -- '',
    ['norg'] = 'ﴬ',
    ['help'] = '',
    ['undotree'] = 'פּ',
    ['NvimTree'] = 'פּ',
    ['neo-tree'] = 'פּ',
    ['toggleterm'] = ' ',
    ['minimap'] = '',
    ['octo'] = '',
    ['dap-repl'] = '',
  },
  names = {
    ['orgagenda'] = 'Org',
    ['himalaya-msg-list'] = 'Inbox',
    ['mail'] = 'Mail',
    ['minimap'] = '',
    ['dbui'] = 'Dadbod UI',
    ['tsplayground'] = 'Treesitter',
    ['NeogitStatus'] = 'Neogit Status',
    ['Trouble'] = 'Lsp Trouble',
    ['gitcommit'] = 'Git commit',
    ['help'] = 'help',
    ['undotree'] = 'UndoTree',
    ['octo'] = 'Octo',
    ['NvimTree'] = 'Nvim Tree',
    ['dap-repl'] = 'Debugger REPL',
    ['neo-tree'] = get_neotree_name,
    ['toggleterm'] = get_toggleterm_name,
    ['DiffviewFiles'] = 'Diff View',
  },
}

--- @param hl string
local function wrap(hl)
  assert(hl, 'A highlight name must be specified')
  return '%#' .. hl .. '#'
end

local function sum_lengths(list)
  return as.fold(function(acc, item) return acc + (item.length or 0) end, list, 0)
end

local function is_lowest(item, lowest)
  -- if there hasn't been a lowest selected so far
  -- then the item is the lowest
  if not lowest or not lowest.length then return true end
  -- if the item doesn't have a priority or a length
  -- it is likely a special character so should never
  -- be the lowest
  if not item.priority or not item.length then return false end
  -- if the item has the same priority as the lowest then if the item
  -- has a greater length it should become the lowest
  if item.priority == lowest.priority then return item.length > lowest.length end

  return item.priority > lowest.priority
end

--- Take the lowest priority items out of the statusline if we don't have
--- space for them.
--- TODO: currently this doesn't account for if an item that has a lower priority
--- could be fit in instead
--- @param statusline table
--- @param space number
--- @param length number
local function prioritize(statusline, space, length)
  length = length or sum_lengths(statusline)
  if length <= space then return statusline end
  local lowest
  local index_to_remove
  for idx, c in ipairs(statusline) do
    if is_lowest(c, lowest) then
      lowest = c
      index_to_remove = idx
    end
  end
  table.remove(statusline, index_to_remove)
  return prioritize(statusline, space, length - lowest.length)
end

local function matches(str, list)
  return #vim.tbl_filter(function(item) return item == str or string.match(str, item) end, list) > 0
end

--- @param ctx table
function M.is_plain(ctx)
  return matches(ctx.filetype, plain.filetypes)
    or matches(ctx.buftype, plain.buftypes)
    or ctx.preview
end

--- This function allow me to specify titles for special case buffers
--- like the preview window or a quickfix window
--- CREDIT: https://vi.stackexchange.com/a/18090
--- @param ctx table
local function special_buffers(ctx)
  local location_list = fn.getloclist(0, { filewinid = 0 })
  local is_loc_list = location_list.filewinid > 0
  local normal_term = ctx.buftype == 'terminal' and ctx.filetype == ''

  if is_loc_list then return 'Location List' end
  if ctx.buftype == 'quickfix' then return 'Quickfix List' end
  if normal_term then return 'Terminal(' .. fnamemodify(vim.env.SHELL, ':t') .. ')' end
  if ctx.preview then return 'preview' end

  return nil
end

function M.is_repo(ctx) return fn.isdirectory(fmt('%s/.git', fn.getcwd(ctx.winid))) == 1 end

--- @param ctx table
--- @param icon string | nil
function M.modified(ctx, icon)
  return ctx.filetype == 'help' and '' or ctx.modified and (icon or '✎') or ''
end

--- @param ctx table
--- @param icon string | nil
function M.readonly(ctx, icon) return ctx.readonly and ' ' .. (icon or '') or '' end

--- @param bufnum number
--- @param mod string
local function buf_expand(bufnum, mod) return expand('#' .. bufnum .. mod) end

--- @param ctx table
--- @param modifier string
local function filename(ctx, modifier)
  modifier = modifier or ':t'
  local special_buf = special_buffers(ctx)
  if special_buf then return '', '', special_buf end

  local fname = buf_expand(ctx.bufnum, modifier)

  local name = exceptions.names[ctx.filetype]
  if type(name) == 'function' then return '', '', name(fname, ctx.bufnum) end

  if name then return '', '', name end

  if not fname or as.empty(fname) then return '', '', 'No Name' end

  local path = (ctx.buftype == '' and not ctx.preview) and buf_expand(ctx.bufnum, ':~:.:h') or nil
  local is_root = path and #path == 1 -- "~" or "."
  local dir = path and not is_root and fn.fnamemodify(path, ':h') .. '/' or ''
  if strwidth(dir) > math.floor(vim.o.columns / 3) then dir = fn.pathshorten(dir) end
  local parent = path and (is_root and path or fnamemodify(path, ':t')) or ''
  parent = parent ~= '' and parent .. '/' or ''

  return dir, parent, fname
end

--- @param hl string
--- @param bg_hl string
local function highlight_ft_icon(hl, bg_hl)
  if not hl or not bg_hl then return end
  local name = hl .. 'Statusline'
  -- TODO: find a mechanism to cache this so it isn't repeated constantly
  local fg_color = as.highlight.get(hl, 'fg')
  local bg_color = as.highlight.get(bg_hl, 'bg')
  if bg_color and fg_color then
    as.augroup(name, {
      {
        event = 'ColorScheme',
        command = function()
          api.nvim_set_hl(0, name, { foreground = fg_color, background = bg_color })
        end,
      },
    })
    api.nvim_set_hl(0, name, { foreground = fg_color, background = bg_color })
  end
  return name
end

--- @param ctx table
--- @param opts table
--- @return string, string?
local function filetype(ctx, opts)
  local ft_exception = exceptions.filetypes[ctx.filetype]
  if ft_exception then return ft_exception, opts.default end
  local bt_exception = exceptions.buftypes[ctx.buftype]
  if bt_exception then return bt_exception, opts.default end
  local icon, hl
  local extension = fnamemodify(ctx.bufname, ':e')
  local icons_loaded, devicons = as.require('nvim-web-devicons')
  if icons_loaded then
    icon, hl = devicons.get_icon(ctx.bufname, extension, { default = true })
    hl = highlight_ft_icon(hl, opts.icon_bg)
  end
  return icon, hl
end

---Create the various segments of the current filename
---@param ctx table
---@param minimal boolean
---@return table
function M.file(ctx, minimal)
  local win = ctx.winid
  -- highlight the filename components separately
  local filename_hl = minimal and 'StFilenameInactive' or 'StFilename'
  local directory_hl = minimal and 'StDirectoryInactive' or 'StDirectory'
  local parent_hl = minimal and directory_hl or 'StParentDirectory'

  if win_hl.exists(win, 'Normal', 'StatusLine') then
    directory_hl = win_hl.adopt(win, 'StatusLine', 'StCustomDirectory', 'StTitle')
    filename_hl = win_hl.adopt(win, 'StatusLine', 'StCustomFilename', 'StTitle')
    parent_hl = win_hl.adopt(win, 'StatusLine', 'StCustomParentDir', 'StTitle')
  end

  local ft_icon, icon_highlight = filetype(ctx, { icon_bg = 'StatusLine', default = 'StComment' })

  local file_opts = { before = '', after = '', priority = 0 }
  local parent_opts = { before = '', after = '', priority = 2 }
  local dir_opts = { before = '', after = '', priority = 3 }

  local directory, parent, file = filename(ctx)

  -- Depending on which filename segments are empty we select a section to add the file icon to
  local dir_empty, parent_empty = as.empty(directory), as.empty(parent)
  local to_update = dir_empty and parent_empty and file_opts
    or dir_empty and parent_opts
    or dir_opts

  to_update.prefix = ft_icon
  to_update.prefix_color = not minimal and icon_highlight or nil
  return {
    file = { item = file, hl = filename_hl, opts = file_opts },
    dir = { item = directory, hl = directory_hl, opts = dir_opts },
    parent = { item = parent, hl = parent_hl, opts = parent_opts },
  }
end

function M.diagnostic_info(context)
  local diagnostics = vim.diagnostic.get(context.bufnum)
  local severities = vim.diagnostic.severity
  local lsp = as.style.icons.lsp
  local result = {
    error = { count = 0, icon = lsp.error },
    warn = { count = 0, icon = lsp.warn },
    info = { count = 0, icon = lsp.info },
    hint = { count = 0, icon = lsp.hint },
  }
  if vim.tbl_isempty(diagnostics) then return result end
  result = as.fold(function(accum, item)
    local severity = severities[item.severity]:lower()
    accum[severity].count = accum[severity].count + 1
    return accum
  end, diagnostics, result)
  return result
end

function M.debugger() return not package.loaded['dap'] and '' or require('dap').status() end

---@return boolean, {name: string, hint: string, color: string}
function M.hydra()
  local ok, hydra = pcall(require, 'hydra.statusline')
  if not ok then return false, { name = '', color = '' } end
  local colors = {
    red = 'HydraRedSt',
    blue = 'HydraBlueSt',
    amaranth = 'HydraAmaranthSt',
    teal = 'HydraTealSt',
    pink = 'HydraPinkSt',
  }
  local data = {
    name = hydra.get_name() or 'UNKNOWN',
    hint = hydra.get_hint(),
    color = colors[hydra.get_color()],
  }
  return hydra.is_active(), data
end

-----------------------------------------------------------------------------//
-- Last search count
-----------------------------------------------------------------------------//
function M.search_count()
  local result = fn.searchcount({ recompute = 0 })
  if vim.tbl_isempty(result) then return '' end
  if result.incomplete == 1 then -- timed out
    return ' ?/?? '
  elseif result.incomplete == 2 then -- max count exceeded
    if result.total > result.maxcount and result.current > result.maxcount then
      return fmt(' >%d/>%d ', result.current, result.total)
    elseif result.total > result.maxcount then
      return fmt(' %d/>%d ', result.current, result.total)
    end
  end
  return fmt(' %d/%d ', result.current, result.total)
end

---@type number
local search_count_timer
--- Timer to update the search count as the file is travelled
function M.update_search_count(timer)
  search_count_timer = timer
  timer:start(0, 200, function()
    vim.schedule(function()
      if timer == search_count_timer then
        fn.searchcount({ recompute = 1, maxcount = 0, timeout = 100 })
        vim.cmd.redrawstatus()
      end
    end)
  end)
end
----------------------------------------------------------------------------------------------------
-- MODE
----------------------------------------------------------------------------------------------------

local function mode_highlight(mode)
  local visual_regex = vim.regex([[\(s\|S\|\)]])
  local select_regex = vim.regex([[\(v\|V\|\)]])
  local command_regex = vim.regex([[\(c\|cv\|ce\)]])
  local replace_regex = vim.regex([[\(Rc\|R\|Rv\|Rx\)]])
  if mode == 'i' then
    return 'StModeInsert'
  elseif visual_regex:match_str(mode) then
    return 'StModeVisual'
  elseif select_regex:match_str(mode) then
    return 'StModeSelect'
  elseif replace_regex:match_str(mode) then
    return 'StModeReplace'
  elseif command_regex:match_str(mode) then
    return 'StModeCommand'
  else
    return 'StModeNormal'
  end
end

-- FIXME: operator pending mode doesn't show up
function M.mode()
  local current_mode = api.nvim_get_mode().mode
  local hl = mode_highlight(current_mode)

  local mode_map = {
    ['n'] = 'NORMAL',
    ['no'] = 'N·OPERATOR PENDING',
    ['nov'] = 'N·OPERATOR BLOCK',
    ['noV'] = 'N·OPERATOR LINE',
    ['niI'] = 'N·INSERT',
    ['niR'] = 'N·REPLACE',
    ['niV'] = 'N·VISUAL',
    ['v'] = 'VISUAL',
    ['V'] = 'V·LINE',
    [''] = 'V·BLOCK',
    ['s'] = 'SELECT',
    ['S'] = 'S·LINE',
    [''] = 'S·BLOCK',
    ['i'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rv'] = 'V·REPLACE',
    ['Rx'] = 'C·REPLACE',
    ['Rc'] = 'C·REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'VIM EX',
    ['ce'] = 'EX',
    ['r'] = 'PROMPT',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
    ['nt'] = 'TERMINAL',
    ['null'] = 'NONE',
  }
  return (mode_map[current_mode] or 'UNKNOWN'), hl
end

---Return a sorted list of lsp client names and their priorities
---@param ctx table
---@return table[]
function M.lsp_clients(ctx)
  local clients = vim.lsp.get_active_clients({ bufnr = ctx.bufnum })
  if empty(clients) then return { { name = 'No LSP clients available', priority = 7 } } end
  table.sort(clients, function(a, b)
    if a.name == 'null-ls' then
      return false
    elseif b.name == 'null-ls' then
      return true
    end
    return a.name < b.name
  end)

  return vim.tbl_map(function(client)
    if client.name:match('null') then
      local sources = require('null-ls.sources').get_available(vim.bo[ctx.bufnum].filetype)
      local source_names = vim.tbl_map(function(s) return s.name end, sources)
      return { name = table.concat(source_names, ', '), priority = 7 }
    end
    return { name = client.name, priority = 4 }
  end, clients)
end
-----------------------------------------------------------------------------//
-- Git/Github helper functions
-----------------------------------------------------------------------------//

---@param interval number
---@param task function
local function run_task_on_interval(interval, task)
  local pending_job
  local timer = luv.new_timer()
  local function callback()
    if pending_job then fn.jobstop(pending_job) end
    pending_job = task()
  end
  local fail = timer:start(0, interval, vim.schedule_wrap(callback))
  if fail ~= 0 then
    vim.schedule(function() vim.notify('Failed to start git update job: ' .. fail) end)
  end
end

---check if in a git repository
---@return boolean
local function is_git_repo() return fn.isdirectory(fn.getcwd() .. '/' .. '.git') > 0 end

--- @param result string[]
local function collect_data(result)
  return function(_, data, _)
    for _, item in ipairs(data) do
      if item and item ~= '' then table.insert(result, item) end
    end
  end
end

-- Use git and the native job API to first get the head of the repo
-- check the state of the repo head against the origin copy we have
-- the result format is in the format: `1       0`
-- the first value commits ahead by and the second is commits behind by
local function git_update_job()
  if not is_git_repo() then return end
  local result = {}
  fn.jobstart('git rev-list --count --left-right @{upstream}...HEAD', {
    stdout_buffered = true,
    on_stdout = collect_data(result),
    on_exit = function(_, code, _)
      if code > 0 and not result or not result[1] then return end
      local parts = vim.split(result[1], '\t')
      if parts and #parts > 1 then
        local formatted = { behind = parts[1], ahead = parts[2] }
        vim.g.git_statusline_updates = formatted
      end
    end,
  })
end

function M.git_updates_refresh() git_update_job() end

--- starts a timer to check for the whether
--- we are currently ahead or behind upstream
function M.git_updates() run_task_on_interval(10000, git_update_job) end

----------------------------------------------------------------------------------------------------
-- COMPONENTS
----------------------------------------------------------------------------------------------------

---@param func_name string
---@param id string
---@return string
local function get_click_start(func_name, id) return '%' .. id .. '@' .. func_name .. '@' end

--- Creates a spacer statusline component i.e. for padding
--- or to represent an empty component
--- @param size integer?
--- @param opts table<string, any>?
function M.spacer(size, opts)
  opts = opts or {}
  local filler = opts.filler or ' '
  local priority = opts.priority or 0
  if size and size >= 1 then
    local spacer = string.rep(filler, size)
    return { component = spacer, length = strwidth(spacer), priority = priority }
  end
  return { component = '', length = 0, priority = priority }
end

--- @class ComponentOpts
--- @field priority number
--- @field click string
--- @field suffix string
--- @field suffix_color string
--- @field prefix string?
--- @field prefix_color string?
--- @field before string
--- @field after string
--- @field id number
--- @field max_size integer

--- @param item string | number
--- @param hl string
--- @param opts ComponentOpts
function M.component(item, hl, opts)
  -- do not allow empty values to be shown note 0 is considered empty
  -- since if there is nothing of something I don't need to see it
  if empty(item) then return M.spacer() end
  assert(opts and opts.priority, fmt("each item's priority is required: %s is missing one", item))
  opts.padding = opts.padding or { suffix = true, prefix = true }
  local padding = ' '
  local before, after = opts.before or '', opts.after or padding
  local prefix = opts.prefix and opts.prefix .. (opts.padding.prefix and padding or '') or ''
  local suffix = opts.suffix and (opts.padding.suffix and padding or '') .. opts.suffix or ''
  local prefix_color, suffix_color = opts.prefix_color or hl, opts.suffix_color or hl
  local prefix_hl = not empty(prefix_color) and wrap(prefix_color) or ''
  local suffix_hl = not empty(suffix_color) and wrap(suffix_color) or ''
  local prefix_item = not empty(prefix) and prefix_hl .. prefix or ''
  local suffix_item = not empty(suffix) and suffix_hl .. suffix or ''

  local click_start = opts.click and get_click_start(opts.click, tostring(opts.id)) or ''
  local click_end = opts.click and constants.CLICK_END or ''

  --- handle numeric inputs etc.
  if type(item) ~= 'string' then item = tostring(item) end

  if opts.max_size and item and #item >= opts.max_size then
    item = item:sub(1, opts.max_size - 1) .. '…'
  end

  return {
    component = table.concat({
      click_start,
      before,
      prefix_item,
      constants.HL_END,
      hl and wrap(hl) or '',
      item,
      constants.HL_END,
      suffix_item,
      constants.HL_END,
      after,
      click_end,
    }),
    length = strwidth(item .. before .. after .. suffix .. prefix),
    priority = opts.priority,
  }
end

--- @param item string | number
--- @param condition table | string | number | boolean
--- @param hl string
--- @param opts ComponentOpts
function M.component_if(item, condition, hl, opts)
  if not condition then return M.spacer() end
  return M.component(item, hl, opts)
end

--- @class RawComponentOpts
--- @field priority number
--- @field win_id number
--- @field type "statusline" | "tabline" | "winbar"

---Render a component that already has statusline format items and highlights in place
---@param item string
---@param opts RawComponentOpts
---@return table
function M.component_raw(item, opts)
  local priority = opts.priority or 0
  local win_id = opts.win_id or 0
  local container_type = opts.type or 'statusline'
  local ok, data = pcall(api.nvim_eval_statusline, item, {
    use_winbar = container_type == 'winbar',
    use_tabline = container_type == 'tabline',
    winid = win_id,
  })
  if not ok then return { component = '', length = 0, priority = priority } end
  return { component = item, length = data.width, priority = priority }
end

----------------------------------------------------------------------------------------------------
-- RENDER
----------------------------------------------------------------------------------------------------

--- @param statusline table
--- @param available_space number
function M.display(statusline, available_space)
  local str = ''
  local items = prioritize(statusline, available_space)
  for _, item in ipairs(items) do
    if type(item.component) == 'string' and #item.component > 0 then str = str .. item.component end
  end
  return str
end

---Aggregate pieces of the statusline
---@param tbl table
---@return function
function M.winline(tbl)
  return function(...)
    for i = 1, select('#', ...) do
      tbl[#tbl + 1] = select(i, ...)
    end
  end
end

return M
