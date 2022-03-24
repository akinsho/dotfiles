local H = require 'as.highlights'

local fn = vim.fn
local api = vim.api
local expand = fn.expand
local strwidth = fn.strwidth
local fnamemodify = fn.fnamemodify
local fmt = string.format

local M = {}

local function get_toggleterm_name(_, buf)
  local shell = fnamemodify(vim.env.SHELL, ':t')
  return fmt('Terminal(%s)[%s]', shell, api.nvim_buf_get_var(buf, 'toggle_number'))
end

local plain = {
  filetypes = {
    'help',
    'ctrlsf',
    'minimap',
    'Trouble',
    'tsplayground',
    'coc-explorer',
    'NvimTree',
    'undotree',
    'neoterm',
    'vista',
    'fugitive',
    'startify',
    'vimwiki',
    'markdown',
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
    org = '',
    orgagenda = '',
    ['himalaya-msg-list'] = '',
    mail = '',
    dbui = '',
    vista = 'פּ',
    tsplayground = '侮',
    fugitive = '',
    fugitiveblame = '',
    gitcommit = '',
    startify = '',
    defx = '⌨',
    ctrlsf = '🔍',
    Trouble = '',
    NeogitStatus = '',
    ['vim-plug'] = '⚉',
    vimwiki = 'ﴬ',
    help = '',
    undotree = 'פּ',
    ['coc-explorer'] = '',
    NvimTree = 'פּ',
    toggleterm = ' ',
    calendar = '',
    minimap = '',
    octo = '',
    ['dap-repl'] = '',
  },
  names = {
    orgagenda = 'Org',
    ['himalaya-msg-list'] = 'Inbox',
    mail = 'Mail',
    minimap = '',
    dbui = 'Dadbod UI',
    tsplayground = 'Treesitter',
    vista = 'Vista',
    fugitive = 'Fugitive',
    fugitiveblame = 'Git blame',
    NeogitStatus = 'Neogit Status',
    Trouble = 'Lsp Trouble',
    gitcommit = 'Git commit',
    startify = 'Startify',
    defx = 'Defx',
    ctrlsf = 'CtrlSF',
    ['vim-plug'] = 'vim plug',
    vimwiki = 'vim wiki',
    help = 'help',
    undotree = 'UndoTree',
    octo = 'Octo',
    ['coc-explorer'] = 'Coc Explorer',
    NvimTree = 'Nvim Tree',
    toggleterm = get_toggleterm_name,
    ['dap-repl'] = 'Debugger REPL',
  },
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

local function matches(str, list)
  return #vim.tbl_filter(function(item)
    return item == str or string.match(str, item)
  end, list) > 0
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

  if is_loc_list then
    return 'Location List'
  end
  if ctx.buftype == 'quickfix' then
    return 'Quickfix'
  end
  if normal_term then
    return 'Terminal(' .. fnamemodify(vim.env.SHELL, ':t') .. ')'
  end
  if ctx.preview then
    return 'preview'
  end

  return nil
end

--- @param ctx table
--- @param icon string | nil
function M.modified(ctx, icon)
  icon = icon or '✎'
  if ctx.filetype == 'help' then
    return ''
  end
  return ctx.modified and icon or ''
end

--- @param ctx table
--- @param icon string | nil
function M.readonly(ctx, icon)
  icon = icon or ''
  if ctx.readonly then
    return ' ' .. icon
  else
    return ''
  end
end

--- @param bufnum number
--- @param mod string
local function buf_expand(bufnum, mod)
  return expand('#' .. bufnum .. mod)
end

--- @param ctx table
--- @param modifier string
local function filename(ctx, modifier)
  modifier = modifier or ':t'
  local special_buf = special_buffers(ctx)
  if special_buf then
    return '', '', special_buf
  end

  local fname = buf_expand(ctx.bufnum, modifier)

  local name = exceptions.names[ctx.filetype]
  if type(name) == 'function' then
    return '', '', name(fname, ctx.bufnum)
  end

  if name then
    return '', '', name
  end

  if not fname then
    return '', '', 'No Name'
  end

  local path = (ctx.buftype == '' and not ctx.preview) and buf_expand(ctx.bufnum, ':~:.:h') or nil
  local is_root = path and #path == 1 -- "~" or "."
  local dir = path and not is_root and fn.pathshorten(fnamemodify(path, ':h')) .. '/' or ''
  local parent = path and (is_root and path or fnamemodify(path, ':t')) or ''
  parent = parent ~= '' and parent .. '/' or ''

  return dir, parent, fname
end

---@param name string
---@param fg string
---@param bg string
local function create_hl(name, fg, bg)
  if fg and bg then
    api.nvim_set_hl(0, name, { foreground = fg, background = bg })
  end
end

--- @param hl string
--- @param bg_hl string
local function highlight_ft_icon(hl, bg_hl)
  if not hl or not bg_hl then
    return
  end
  local name = hl .. 'Statusline'
  -- TODO: find a mechanism to cache this so it isn't repeated constantly
  local fg_color = H.get_hl(hl, 'fg')
  local bg_color = H.get_hl(bg_hl, 'bg')
  if bg_color and fg_color then
    as.augroup(name, {
      {
        event = 'ColorScheme',
        command = function()
          create_hl(name, fg_color, bg_color)
        end,
      },
    })
    create_hl(name, fg_color, bg_color)
  end
  return name
end

--- @param ctx table
--- @param opts table
--- @return string, string?
local function filetype(ctx, opts)
  local ft_exception = exceptions.filetypes[ctx.filetype]
  if ft_exception then
    return ft_exception, opts.default
  end
  local bt_exception = exceptions.buftypes[ctx.buftype]
  if bt_exception then
    return bt_exception, opts.default
  end
  local icon, hl
  local extension = fnamemodify(ctx.bufname, ':e')
  local icons_loaded, devicons = as.safe_require 'nvim-web-devicons'
  if icons_loaded then
    icon, hl = devicons.get_icon(ctx.bufname, extension, { default = true })
    hl = highlight_ft_icon(hl, opts.icon_bg)
  end
  return icon, hl
end

--- This function gets and decorates the current and total line count
--- it derives this using the line() function rather than the %l/%L statusline
--- format strings because these cannot be
-- @param opts table
function M.line_info(opts)
  local sep = opts.sep or '/'
  local prefix = opts.prefix or 'L'
  local prefix_color = opts.prefix_color
  local current_hl = opts.current_hl
  local total_hl = opts.total_hl
  local sep_hl = opts.total_hl

  local current = fn.line '.'
  local last = fn.line '$'

  local length = strwidth(prefix .. current .. sep .. last)
  return {
    table.concat {
      ' ',
      M.wrap(prefix_color),
      prefix,
      ' ',
      M.wrap(current_hl),
      current,
      M.wrap(sep_hl),
      sep,
      M.wrap(total_hl),
      last,
      ' ',
    },
    length,
  }
end

local function empty_opts()
  return { before = '', after = '' }
end

---Create the various segments of the current filename
---@param ctx table
---@param minimal boolean
---@return table
function M.file(ctx, minimal)
  local curwin = ctx.winid
  -- highlight the filename components separately
  local filename_hl = minimal and 'StFilenameInactive' or 'StFilename'
  local directory_hl = minimal and 'StDirectoryInactive' or 'StDirectory'
  local parent_hl = minimal and directory_hl or 'StParentDirectory'

  if H.has_win_highlight(curwin, 'Normal', 'StatusLine') then
    directory_hl = H.adopt_winhighlight(curwin, 'StatusLine', 'StCustomDirectory', 'StTitle')
    filename_hl = H.adopt_winhighlight(curwin, 'StatusLine', 'StCustomFilename', 'StTitle')
    parent_hl = H.adopt_winhighlight(curwin, 'StatusLine', 'StCustomParentDir', 'StTitle')
  end

  local ft_icon, icon_highlight = filetype(ctx, { icon_bg = 'StatusLine', default = 'StComment' })

  local file_opts, parent_opts, dir_opts = empty_opts(), empty_opts(), empty_opts()
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

---Shim to handle getting diagnostics in nvim 0.5 and nightly
---@param buf number
---@param severity string
---@return number
local function get_count(buf, severity)
  local s = vim.diagnostic.severity[severity:upper()]
  return #vim.diagnostic.get(buf, { severity = s })
end

function M.diagnostic_info(context)
  local buf = context.bufnum
  if vim.tbl_isempty(vim.lsp.buf_get_clients(buf)) then
    return { error = {}, warning = {}, info = {} }
  end
  local icons = as.style.icons.lsp
  return {
    error = { count = get_count(buf, 'Error'), sign = icons.error },
    warning = { count = get_count(buf, 'Warning'), sign = icons.warn },
    info = { count = get_count(buf, 'Information'), sign = icons.info },
  }
end

function M.lsp_client()
  for _, client in ipairs(vim.lsp.buf_get_clients(0)) do
    if
      client.config
      and client.config.filetypes
      and vim.tbl_contains(client.config.filetypes, vim.bo.filetype)
    then
      return client.name
    end
  end
end

---The currently focused function
---@return string?
function M.current_function()
  local gps = require 'nvim-gps'
  if gps.is_available() then
    return gps.get_location()
  end
end

function M.debugger()
  if not package.loaded['dap'] then
    return ''
  end
  return require('dap').status()
end

local function printf(format, current, total)
  if current == 0 and total == 0 then
    return ''
  end
  return fn.printf(format, current, total)
end

-----------------------------------------------------------------------------//
-- Last search count
-----------------------------------------------------------------------------//
function M.search_count()
  local result = fn.searchcount { recompute = 0 }
  if vim.tbl_isempty(result) then
    return ''
  end
  ---NOTE: the search term can be included in the output
  --- using [%s] but this value seems flaky
  -- local search_reg = fn.getreg("@/")
  if result.incomplete == 1 then -- timed out
    return printf ' ?/?? '
  elseif result.incomplete == 2 then -- max count exceeded
    if result.total > result.maxcount and result.current > result.maxcount then
      return printf(' >%d/>%d ', result.current, result.total)
    elseif result.total > result.maxcount then
      return printf(' %d/>%d ', result.current, result.total)
    end
  end
  return printf(' %d/%d ', result.current, result.total)
end

---@type number
local search_count_timer
--- Timer to update the search count as the file is travelled
---@return function
function M.update_search_count()
  if search_count_timer then
    fn.timer_stop(search_count_timer)
  end
  search_count_timer = fn.timer_start(200, function(timer)
    if timer == search_count_timer then
      fn.searchcount { recompute = 1, maxcount = 0, timeout = 100 }
      vim.cmd 'redrawstatus'
    end
  end)
end
-----------------------------------------------------------------------------//

local function mode_highlight(mode)
  local visual_regex = vim.regex [[\(v\|V\|\)]]
  local command_regex = vim.regex [[\(c\|cv\|ce\)]]
  local replace_regex = vim.regex [[\(Rc\|R\|Rv\|Rx\)]]
  if mode == 'i' then
    return 'StModeInsert'
  elseif visual_regex:match_str(mode) then
    return 'StModeVisual'
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
    ['v'] = 'VISUAL',
    ['V'] = 'V·LINE',
    [''] = 'V·BLOCK',
    ['s'] = 'SELECT',
    ['S'] = 'S·LINE',
    ['^S'] = 'S·BLOCK',
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
  }
  return (mode_map[current_mode] or 'UNKNOWN'), hl
end

--- @param hl string
function M.wrap(hl)
  assert(hl, 'A highlight name must be specified')
  return '%#' .. hl .. '#'
end

--- Creates a spacer statusline component i.e. for padding
--- or to represent an empty component
--- @param size number
--- @param filler string | nil
function M.spacer(size, filler)
  filler = filler or ' '
  if size and size >= 1 then
    local spacer = string.rep(filler, size)
    return { spacer, #spacer }
  else
    return { '', 0 }
  end
end

--- @param component string
--- @param hl string
--- @param opts table
function M.item(component, hl, opts)
  -- do not allow empty values to be shown note 0 is considered empty
  -- since if there is nothing of something I don't need to see it
  if not component or component == '' or component == 0 then
    return M.spacer()
  end
  opts = opts or {}
  local before = opts.before or ''
  local after = opts.after or ' '
  local prefix = opts.prefix or ''
  local prefix_size = strwidth(prefix)

  local prefix_color = opts.prefix_color or hl
  prefix = prefix ~= '' and M.wrap(prefix_color) .. prefix .. ' ' or ''

  --- handle numeric inputs etc.
  if type(component) ~= 'string' then
    component = tostring(component)
  end

  if opts.max_size and component and #component >= opts.max_size then
    component = component:sub(1, opts.max_size - 1) .. '…'
  end

  local parts = { before, prefix, M.wrap(hl), component, '%*', after }
  return { table.concat(parts), #component + #before + #after + prefix_size }
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

-----------------------------------------------------------------------------//
-- Git/Github helper functions
-----------------------------------------------------------------------------//

---A thin wrapper around nvim's job api
---@param interval number
---@param task function
---@param on_complete function?
local function job(interval, task, on_complete)
  vim.defer_fn(task, 2000)
  local pending_job
  local timer = fn.timer_start(interval, function()
    -- clear previous job
    if pending_job then
      fn.jobstop(pending_job)
    end
    pending_job = task()
  end, {
    ['repeat'] = -1,
  })
  if on_complete then
    on_complete(timer)
  end
end

---check if in a git repository
---@return boolean
local function is_git_repo()
  return fn.isdirectory(fn.getcwd() .. '/' .. '.git') > 0
end

--- @param result string[]
local function collect_data(result)
  return function(_, data, _)
    for _, item in ipairs(data) do
      if item and item ~= '' then
        table.insert(result, item)
      end
    end
  end
end

-- Use git and the native job API to first get the head of the repo
-- check the state of the repo head against the origin copy we have
-- the result format is in the format: `1       0`
-- the first value commits ahead by and the second is commits behind by
local function git_update_job()
  local result = {}
  fn.jobstart('git rev-list --count --left-right @{upstream}...HEAD', {
    stdout_buffered = true,
    on_stdout = collect_data(result),
    on_exit = function(_, code, _)
      if code > 0 and not result or not result[1] then
        return
      end
      local parts = vim.split(result[1], '\t')
      if parts and #parts > 1 then
        local formatted = { behind = parts[1], ahead = parts[2] }
        vim.g.git_statusline_updates = formatted
      end
    end,
  })
end

function M.git_updates_refresh()
  git_update_job()
end

function M.git_update_toggle()
  local on = is_git_repo()
  if on then
    M.git_updates()
  end
  if vim.g.git_statusline_updates_timer then
    local status = on and 0 or 1
    fn.timer_pause(vim.g.git_statusline_updates_timer, status)
  end
end

--- starts a timer to check for the whether
--- we are currently ahead or behind upstream
function M.git_updates()
  job(30000, git_update_job, function(timer)
    vim.g.git_statusline_updates_timer = timer
  end)
end

return M
