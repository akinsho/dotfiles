if not as then return end

as.ui.statusline = {}

local state = { lsp_clients_visible = true }
----------------------------------------------------------------------------------------------------
--  Types
----------------------------------------------------------------------------------------------------

---@class StatuslineContext
---@field bufnum number
---@field win number
---@field bufname string
---@field preview boolean
---@field readonly boolean
---@field filetype string
---@field buftype string
---@field modified boolean
---@field fileformat string
---@field shiftwidth number
---@field expandtab boolean
---@field winhl boolean
----------------------------------------------------------------------------------------------------

local str = require('as.strings')

local icons, lsp, highlight, decorations = as.ui.icons, as.ui.lsp, as.highlight, as.ui.decorations
local api, fn, fs, fmt = vim.api, vim.fn, vim.fs, string.format
local P = as.ui.palette
local C = str.constants

local sep = package.config:sub(1, 1)

----------------------------------------------------------------------------------------------------
--  Colors
----------------------------------------------------------------------------------------------------

local hls = {
  statusline = 'StatusLine',
  statusline_nc = 'StatusLineNC',
  metadata = 'StMetadata',
  metadata_prefix = 'StMetadataPrefix',
  indicator = 'StIndicator',
  modified = 'StModified',
  git = 'StGit',
  green = 'StGreen',
  blue = 'StBlue',
  number = 'StNumber',
  count = 'StCount',
  client = 'StClient',
  env = 'StEnv',
  directory = 'StDirectory',
  directory_inactive = 'StDirectoryInactive',
  parent_directory = 'StParentDirectory',
  title = 'StTitle',
  comment = 'StComment',
  info = 'StInfo',
  warn = 'StWarn',
  error = 'StError',
  filename = 'StFilename',
  filename_inactive = 'StFilenameInactive',
  mode_normal = 'StModeNormal',
  mode_insert = 'StModeInsert',
  mode_visual = 'StModeVisual',
  mode_replace = 'StModeReplace',
  mode_command = 'StModeCommand',
  mode_select = 'StModeSelect',
  hydra_red = 'HydraRedSt',
  hydra_blue = 'HydraBlueSt',
  hydra_amaranth = 'HydraAmaranthSt',
  hydra_teal = 'HydraTealSt',
  hydra_pink = 'HydraPinkSt',
}

---@param hl string
---@return fun(id: number): string
local function with_win_id(hl)
  return function(id) return hl .. id end
end

local stl_winhl = {
  filename = { hl = with_win_id('StCustomFilename'), fallback = hls.title },
  directory = { hl = with_win_id('StCustomDirectory'), fallback = hls.title },
  parent = { hl = with_win_id('StCustomParentDirectory'), fallback = hls.title },
  readonly = { hl = with_win_id('StCustomError'), fallback = hls.error },
  env = { hl = with_win_id('StCustomEnv'), fallback = hls.env },
}

local function colors()
  --- NOTE: Unicode characters including vim devicons should NOT be highlighted
  --- as italic or bold, this is because the underlying bold font is not necessarily
  --- patched with the nerd font characters
  --- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
  --- but this is not universal across terminals so should be avoided

  local indicator_color = P.bright_blue
  local warning_fg = lsp.colors.warn

  local error_color = lsp.colors.error
  local info_color = lsp.colors.info
  local normal_fg = highlight.get('Normal', 'fg')
  local string_fg = highlight.get('String', 'fg')
  local number_fg = highlight.get('Number', 'fg')
  local normal_bg = highlight.get('Normal', 'bg')

  local bg_color = highlight.alter_color(normal_bg, -16)

  -- stylua: ignore
  highlight.all({
    { [hls.metadata] = { background = bg_color, inherit = 'Comment' } },
    { [hls.metadata_prefix] = { background = bg_color, foreground = { from = 'Comment' } } },
    { [hls.indicator] = { background = bg_color, foreground = indicator_color } },
    { [hls.modified] = { foreground = string_fg, background = bg_color } },
    { [hls.git] = { foreground = P.light_gray, background = bg_color } },
    { [hls.green] = { foreground = string_fg, background = bg_color } },
    { [hls.blue] = { foreground = P.dark_blue, background = bg_color, bold = true } },
    { [hls.number] = { foreground = number_fg, background = bg_color } },
    { [hls.count] = { foreground = 'bg', background = indicator_color, bold = true } },
    { [hls.client] = { background = bg_color, foreground = normal_fg, bold = true } },
    { [hls.env] = { background = bg_color, foreground = error_color, italic = true, bold = true } },
    { [hls.directory] = { background = bg_color, foreground = 'Gray', italic = true } },
    { [hls.directory_inactive] = { background = bg_color, italic = true, foreground = { from = 'Normal', alter = 40 } } },
    { [hls.parent_directory] = { background = bg_color, foreground = string_fg, bold = true } },
    { [hls.title] = { background = bg_color, foreground = 'LightGray', bold = true } },
    { [hls.comment] = { background = bg_color, inherit = 'Comment' } },
    { [hls.statusline] = { background = bg_color } },
    { [hls.statusline_nc] = { link = 'VertSplit' } },
    { [hls.info] = { foreground = info_color, background = bg_color, bold = true } },
    { [hls.warn] = { foreground = warning_fg, background = bg_color } },
    { [hls.error] = { foreground = error_color, background = bg_color } },
    { [hls.filename] = { background = bg_color, foreground = 'LightGray', bold = true } },
    { [hls.filename_inactive] = { inherit = 'Comment', background = bg_color, bold = true } },
    { [hls.mode_normal] = { background = bg_color, foreground = P.light_gray, bold = true } },
    { [hls.mode_insert] = { background = bg_color, foreground = P.dark_blue, bold = true } },
    { [hls.mode_visual] = { background = bg_color, foreground = P.magenta, bold = true } },
    { [hls.mode_replace] = { background = bg_color, foreground = P.dark_red, bold = true } },
    { [hls.mode_command] = { background = bg_color, foreground = P.light_yellow, bold = true } },
    { [hls.mode_select] = { background = bg_color, foreground = P.teal, bold = true } },
    { [hls.hydra_red] = { inherit = 'HydraRed', reverse = true } },
    { [hls.hydra_blue] = { inherit = 'HydraBlue', reverse = true } },
    { [hls.hydra_amaranth] = { inherit = 'HydraAmaranth', reverse = true } },
    { [hls.hydra_teal] = { inherit = 'HydraTeal', reverse = true } },
    { [hls.hydra_pink] = { inherit = 'HydraPink', reverse = true } },
  })
end

local identifiers = {
  buftypes = {
    terminal = ' ',
    quickfix = '',
  },
  filetypes = as.p_table({
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
  }),
  names = as.p_table({
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
    ['Diffview.*'] = 'Diff view',

    ['neo-tree'] = function(fname, _)
      local parts = vim.split(fname, ' ')
      return fmt('Neo Tree(%s)', parts[2])
    end,

    ['toggleterm'] = function(_, buf)
      local shell = fn.fnamemodify(vim.env.SHELL, ':t')
      return fmt('Terminal(%s)[%s]', shell, api.nvim_buf_get_var(buf, 'toggle_number'))
    end,
  }),
}

local function get_ft_icon_hl_name(hl) return hl .. hls.statusline end

--- @param buf number
--- @param opts { default: boolean }
--- @return string, string?
local function get_buffer_icon(buf, opts)
  local path = api.nvim_buf_get_name(buf)
  if fn.isdirectory(path) == 1 then return '', nil end
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then return '', nil end
  local name, ext = fn.fnamemodify(path, ':t'), fn.fnamemodify(path, ':e')
  return devicons.get_icon(name, ext, opts)
end

--- @param ctx StatuslineContext
--- @return string, string?
local function filetype(ctx)
  local ft, bt = identifiers.filetypes[ctx.filetype], identifiers.buftypes[ctx.buftype]
  if ft then return ft end
  if bt then return bt end
  return get_buffer_icon(ctx.bufnum, { default = true })
end

--- This function allow me to specify titles for special case buffers
--- like the preview window or a quickfix window
--- CREDIT: https://vi.stackexchange.com/a/18090
--- @param ctx StatuslineContext
local function special_buffers(ctx)
  local location_list = fn.getloclist(0, { filewinid = 0 })
  local is_loc_list = location_list.filewinid > 0
  local normal_term = ctx.buftype == 'terminal' and ctx.filetype == ''

  if is_loc_list then return 'Location List' end
  if ctx.buftype == 'quickfix' then return 'Quickfix List' end
  if normal_term then return 'Terminal(' .. fn.fnamemodify(vim.env.SHELL, ':t') .. ')' end
  if ctx.preview then return 'preview' end

  return nil
end

---Only append the path separator if the path is not empty
---@param path string
---@return string
local function path_sep(path) return not as.empty(path) and path .. sep or path end

--- Replace the directory path with an identifier if it matches a commonly visited
--- directory of mine such as my projects directory or my work directory
--- since almost all my project directories are nested underneath one of these paths
--- this should match often and reduce the unnecessary boilerplate in my path as
--- I know where these directories are generally
---@param directory string
---@return string directory
---@return string custom_dir
local function dir_env(directory)
  if not directory then return '', '' end
  local paths = {
    [vim.g.dotfiles] = '$DOTFILES',
    [vim.g.work_dir] = '$WORK',
    [vim.g.projects_dir] = '$PROJECTS',
  }
  local result, env, prev_match = directory, '', ''
  for dir, alias in pairs(paths) do
    -- NOTE: using vim.fn.expand causes the commandline to get stuck completing
    local match, count = fs.normalize(directory):gsub(vim.pesc(path_sep(dir)), '')
    if count == 1 and #dir > #prev_match then
      result, env, prev_match = match, path_sep(alias), dir
    end
  end
  return result, env
end

--- @param ctx StatuslineContext
--- @return {env: string, dir: string, parent: string, fname: string}
local function filename(ctx)
  local buf, ft = ctx.bufnum, ctx.filetype
  local special_buf = special_buffers(ctx)
  if special_buf then return { fname = special_buf } end

  local path = api.nvim_buf_get_name(buf)
  if as.empty(path) then return { fname = 'No Name' } end
  --- add ":." to the expansion i.e. to make the directory path relative to the current vim directory
  local parts = vim.split(fn.fnamemodify(path, ':~'), sep)
  local fname = table.remove(parts)

  local name = identifiers.names[ft]
  if name then return { fname = vim.is_callable(name) and name(fname, buf) or name } end

  local parent = table.remove(parts)
  fname = fn.isdirectory(fname) == 1 and fname .. sep or fname
  if as.empty(parent) then return { fname = fname } end

  local dir = path_sep(table.concat(parts, sep))
  local new_dir, env = dir_env(dir)
  local segment = not as.empty(env) and env .. new_dir or dir
  if api.nvim_strwidth(segment) > math.floor(vim.o.columns / 3) then dir = fn.pathshorten(dir) end

  return { env = env, dir = new_dir, parent = path_sep(parent), fname = fname }
end

---@alias FilenamePart {item: string, hl: string, opts: ComponentOpts}
---Create the various segments of the current filename
---@param ctx StatuslineContext
---@param minimal boolean
---@return {file: FilenamePart, parent: FilenamePart, dir: FilenamePart, env: FilenamePart}
local function stl_file(ctx, minimal)
  -- highlight the filename components separately
  local filename_hl = ctx.winhl and stl_winhl.filename.hl(ctx.win)
    or (minimal and hls.filename_inactive or hls.filename)

  local directory_hl = ctx.winhl and stl_winhl.directory.hl(ctx.win)
    or (minimal and hls.directory_inactive or hls.directory)

  local parent_hl = ctx.winhl and stl_winhl.parent.hl(ctx.win)
    or (minimal and directory_hl or hls.parent_directory)

  local env_hl = ctx.winhl and stl_winhl.env.hl(ctx.win) or (minimal and directory_hl or hls.env)

  local ft_icon, icon_highlight = filetype(ctx)
  local ft_hl = icon_highlight and get_ft_icon_hl_name(icon_highlight) or hls.comment

  local file_opts = { before = '', after = ' ', priority = 0 }
  local parent_opts = { before = '', after = '', priority = 2 }
  local dir_opts = { before = '', after = '', priority = 3 }
  local env_opts = { before = '', after = '', priority = 4 }

  local p = filename(ctx)

  -- Depending on which filename segments are empty we select a section to add the file icon to
  local env_empty, dir_empty, parent_empty = as.empty(p.env), as.empty(p.dir), as.empty(p.parent)
  local to_update = (env_empty and dir_empty and parent_empty) and file_opts
    or (env_empty and dir_empty) and parent_opts
    or env_empty and dir_opts
    or env_opts

  to_update.prefix, to_update.prefix_color = ft_icon, not minimal and ft_hl or nil
  return {
    env = { item = p.env, hl = env_hl, opts = env_opts },
    file = { item = p.fname, hl = filename_hl, opts = file_opts },
    dir = { item = p.dir, hl = directory_hl, opts = dir_opts },
    parent = { item = p.parent, hl = parent_hl, opts = parent_opts },
  }
end

local function diagnostic_info(context)
  local diagnostics = vim.diagnostic.get(context.bufnum)
  local severities = vim.diagnostic.severity
  local lsp_icons = as.ui.icons.lsp
  local result = {
    error = { count = 0, icon = lsp_icons.error },
    warn = { count = 0, icon = lsp_icons.warn },
    info = { count = 0, icon = lsp_icons.info },
    hint = { count = 0, icon = lsp_icons.hint },
  }
  if vim.tbl_isempty(diagnostics) then return result end
  return as.fold(function(accum, item)
    local severity = severities[item.severity]:lower()
    accum[severity].count = accum[severity].count + 1
    return accum
  end, diagnostics, result)
end

local function debugger() return not package.loaded.dap and '' or require('dap').status() end

---@return boolean, {name: string, hint: string, color: string}
local function stl_hydra()
  local ok, hydra = pcall(require, 'hydra.statusline')
  if not ok then return false, { name = '', color = '' } end
  local data = {
    name = hydra.get_name() or 'UNKNOWN',
    hint = hydra.get_hint(),
    color = hls[fmt('hydra_%s', hydra.get_color())],
  }
  return hydra.is_active(), data
end

-----------------------------------------------------------------------------//
-- Last search count
-----------------------------------------------------------------------------//

local function search_count()
  local ok, result = pcall(fn.searchcount, { recompute = 0 })
  if not ok then return '' end
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

----------------------------------------------------------------------------------------------------
-- MODE
----------------------------------------------------------------------------------------------------

local function mode_highlight(mode)
  local visual_regex = vim.regex([[\(s\|S\|\)]])
  local select_regex = vim.regex([[\(v\|V\|\)]])
  local command_regex = vim.regex([[\(c\|cv\|ce\)]])
  local replace_regex = vim.regex([[\(Rc\|R\|Rv\|Rx\)]])
  if mode == 'i' then
    return hls.mode_insert
  elseif visual_regex and visual_regex:match_str(mode) then
    return hls.mode_visual
  elseif select_regex and select_regex:match_str(mode) then
    return hls.mode_select
  elseif replace_regex and replace_regex:match_str(mode) then
    return hls.mode_replace
  elseif command_regex and command_regex:match_str(mode) then
    return hls.mode_command
  else
    return hls.mode_normal
  end
end

-- FIXME: operator pending mode doesn't show up
local function stl_mode()
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

----------------------------------------------------------------------------------------------------
--  LSP Clients
----------------------------------------------------------------------------------------------------
local LSP_COMPONENT_ID = 2000
local MAX_LSP_SERVER_COUNT = 3

function as.ui.statusline.lsp_client_click()
  state.lsp_clients_visible = not state.lsp_clients_visible
end

---Return a sorted list of lsp client names and their priorities
---@param ctx StatuslineContext
---@return table[]
local function stl_lsp_clients(ctx)
  local clients = vim.lsp.get_active_clients({ bufnr = ctx.bufnum })
  if not state.lsp_clients_visible then
    return { { name = fmt('%d attached', #clients), priority = 7 } }
  end
  if as.empty(clients) then return { { name = 'No LSP clients available', priority = 7 } } end
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
      return { name = '␀ ' .. table.concat(source_names, ', '), priority = 7 }
    end
    return { name = client.name, priority = 4 }
  end, clients)
end

----------------------------------------------------------------------------------------------------
--  Git components
----------------------------------------------------------------------------------------------------

---@param interval number
---@param task function
local function run_task_on_interval(interval, task)
  local pending_job
  local timer = vim.loop.new_timer()
  if not timer then return end
  local function callback()
    if pending_job then fn.jobstop(pending_job) end
    pending_job = task()
  end
  local fail = timer:start(0, interval, vim.schedule_wrap(callback))
  if fail ~= 0 then
    vim.schedule(function() vim.notify('Failed to start git update job: ' .. fail) end)
  end
end

--- Check if in a git repository
--- NOTE: This check is incredibly naive and depends on the fact that I use a rooter
--- function to and am always at the root of a repository
---@return boolean
local function is_git_repo(win_id)
  win_id = win_id or api.nvim_get_current_win()
  return vim.loop.fs_stat(fmt('%s/.git', fn.getcwd(win_id)))
end

-- Use git and the native job API to first get the head of the repo
-- check the state of the repo head against the origin copy we have
-- the result format is in the format: `1       0`
-- the first value commits ahead by and the second is commits behind by
local function update_git_status()
  if not is_git_repo() then return end
  local result = {}
  fn.jobstart('git rev-list --count --left-right @{upstream}...HEAD', {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      for _, item in ipairs(data) do
        if item and item ~= '' then table.insert(result, item) end
      end
    end,
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

--- starts a timer to check for the whether
--- we are currently ahead or behind upstream
local function git_updates() run_task_on_interval(10000, update_git_status) end

----------------------------------------------------------------------------------------------------
--  PLUGINS
----------------------------------------------------------------------------------------------------
--  Grapple
----------------------------------------------------------------------------------------------------
---@return boolean
---@return {icon: string?, name: string?}
local function grapple_stl()
  local ok, grapple = pcall(require, 'grapple')
  if not ok then return false, {} end
  local exists = grapple.exists()
  if not exists then return false, {} end
  return grapple.exists(), { name = fmt('[%s]', grapple.key()), icon = '' }
end

----------------------------------------------------------------------------------------------------
--  Utility functions
----------------------------------------------------------------------------------------------------

--- @param ctx StatuslineContext
local function is_plain(ctx)
  local is_plain_ft = decorations.get(ctx.filetype, 'statusline', 'ft') == 'minimal'
  local is_plain_bt = decorations.get(ctx.buftype, 'statusline', 'bt') == 'minimal'
  return is_plain_ft or is_plain_bt or ctx.preview
end

--- @param ctx StatuslineContext
--- @param icon string | nil
local function is_modified(ctx, icon)
  return ctx.filetype == 'help' and '' or ctx.modified and (icon or '✎') or ''
end

--- @param ctx StatuslineContext
--- @param icon string | nil
local function is_readonly(ctx, icon) return ctx.readonly and ' ' .. (icon or '') or '' end

local separator = function() return { component = C.ALIGN, length = 0, priority = 0 } end
local end_marker = function() return { component = C.END, length = 0, priority = 0 } end

----------------------------------------------------------------------------------------------------
--  RENDER
----------------------------------------------------------------------------------------------------

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function as.ui.statusline.render()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)

  local component = str.component
  local component_if = str.component_if

  local available_space = vim.o.columns

  ---@type StatuslineContext
  local ctx = {
    bufnum = curbuf,
    win = curwin,
    bufname = api.nvim_buf_get_name(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab,
    winhl = vim.wo[curwin].winhl:match(hls.statusline) ~= nil,
  }
  ----------------------------------------------------------------------------//
  -- Modifiers
  ----------------------------------------------------------------------------//
  local plain = is_plain(ctx)
  local file_modified = is_modified(ctx, icons.misc.circle)
  local focused = vim.g.vim_in_focus or true
  ----------------------------------------------------------------------------//
  -- Setup
  ----------------------------------------------------------------------------//
  local statusline = {
    component_if(icons.misc.block, not plain, hls.indicator, {
      before = '',
      after = '',
      priority = 0,
    }),
    str.spacer(1),
  }
  local add = str.winline(statusline)
  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  local segments = stl_file(ctx, plain)
  local env, dir, parent, file = segments.env, segments.dir, segments.parent, segments.file
  local env_component = component(env.item, env.hl, env.opts)
  local dir_component = component(dir.item, dir.hl, dir.opts)
  local parent_component = component(parent.item, parent.hl, parent.opts)
  local file_component = component(file.item, file.hl, file.opts)

  local readonly_hl = ctx.winhl and stl_winhl.readonly.hl(ctx.win) or stl_winhl.readonly.fallback
  local readonly_component = component(is_readonly(ctx), readonly_hl, { priority = 1 })
  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if plain or not focused then
    add(readonly_component, env_component, dir_component, parent_component, file_component)
    return str.display(statusline, available_space)
  end
  -----------------------------------------------------------------------------//
  -- Variables
  -----------------------------------------------------------------------------//

  local mode, mode_hl = stl_mode()
  local lnum, col = unpack(api.nvim_win_get_cursor(curwin))
  local line_count = api.nvim_buf_line_count(ctx.bufnum)

  -- Git state
  local status = vim.b[curbuf].gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -----------------------------------------------------------------------------//
  local hydra_active, hydra = stl_hydra()
  -----------------------------------------------------------------------------//
  local ok, noice = pcall(require, 'noice')
  local noice_mode = ok and noice.api.status.mode.get() or nil
  local has_noice_mode = ok and noice.api.status.mode.has() or nil
  -----------------------------------------------------------------------------//
  local lazy_ok, lazy = pcall(require, 'lazy.status')
  local pending_updates = lazy_ok and lazy.updates() or nil
  local has_pending_updates = lazy_ok and lazy.has_updates() or nil
  -----------------------------------------------------------------------------//
  local grapple_ok, grapple = grapple_stl()
  -----------------------------------------------------------------------------//
  -- LSP
  -----------------------------------------------------------------------------//
  local flutter = vim.g.flutter_tools_decorations or {}
  local diagnostics = diagnostic_info(ctx)
  local lsp_clients = as.map(function(client, index)
    return component(client.name, hls.client, {
      id = LSP_COMPONENT_ID, -- the unique id of the component
      prefix = index == 1 and ' LSP(s):' or nil,
      prefix_color = index == 1 and hls.metadata or nil,
      suffix = '', -- │
      suffix_color = hls.metadata_prefix,
      click = 'v:lua.as.ui.statusline.lsp_client_click',
      priority = client.priority,
    })
  end, stl_lsp_clients(ctx))
  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  add(
    component_if(file_modified, ctx.modified, hls.modified, { priority = 1 }),

    readonly_component,

    component(mode, mode_hl, { priority = 0 }),

    component_if(search_count(), vim.v.hlsearch > 0, hls.count, { priority = 1 }),

    env_component,
    dir_component,
    parent_component,
    file_component,

    component_if(diagnostics.error.count, diagnostics.error, hls.error, {
      prefix = diagnostics.error.icon,
      prefix_color = hls.error,
      priority = 1,
    }),

    component_if(diagnostics.warn.count, diagnostics.warn, hls.warn, {
      prefix = diagnostics.warn.icon,
      prefix_color = hls.warn,
      priority = 3,
    }),

    component_if(diagnostics.info.count, diagnostics.info, hls.info, {
      prefix = diagnostics.info.icon,
      prefix_color = hls.info,
      priority = 4,
    }),

    component_if(grapple.name, grapple_ok, hls.comment, {
      prefix = grapple.icon,
      prefix_color = hls.directory,
      priority = 4,
    }),

    component_if('Saving…', vim.g.is_saving, hls.comment, { before = ' ', priority = 1 }),

    separator(),
    -----------------------------------------------------------------------------//
    -- Middle section
    -----------------------------------------------------------------------------//
    -- Neovim allows unlimited alignment sections so we can put things in the
    -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
    -----------------------------------------------------------------------------//
    component_if(noice_mode, has_noice_mode, hls.title, { before = ' ', priority = 1 }),
    component_if(hydra.name:upper(), hydra_active, hydra.color, {
      prefix = string.rep(' ', 5) .. '🐙',
      suffix = string.rep(' ', 5),
      priority = 5,
    }),

    -- Start of the right side layout
    separator(),
    -----------------------------------------------------------------------------//
    -- Right section
    -----------------------------------------------------------------------------//
    component_if(pending_updates, has_pending_updates, hls.title, {
      prefix = 'updates:',
      prefix_color = hls.comment,
      after = ' ',
      priority = 3,
    }),
    component(flutter.app_version, hls.metadata, { priority = 4 }),
    component(flutter.device and flutter.device.name or '', hls.metadata, { priority = 4 })
  )
  -----------------------------------------------------------------------------//
  -- LSP Clients
  -----------------------------------------------------------------------------//
  add(unpack(lsp_clients))
  -----------------------------------------------------------------------------//
  add(
    component(debugger(), hls.metadata, { prefix = icons.misc.bug, priority = 4 }),

    -- Git Status
    component(status.head, hls.blue, {
      prefix = icons.git.branch,
      prefix_color = hls.git,
      priority = 1,
    }),

    component(status.changed, hls.title, {
      prefix = icons.git.mod,
      prefix_color = hls.warn,
      priority = 3,
    }),

    component(status.removed, hls.title, {
      prefix = icons.git.remove,
      prefix_color = hls.error,
      priority = 3,
    }),

    component(status.added, hls.title, {
      prefix = icons.git.add,
      prefix_color = hls.green,
      priority = 3,
    }),

    component(ahead, hls.title, {
      prefix = icons.misc.up,
      prefix_color = hls.green,
      before = '',
      priority = 5,
    }),

    component(behind, hls.title, {
      prefix = icons.misc.down,
      prefix_color = hls.number,
      after = ' ',
      priority = 5,
    }),

    -- Current line number/total line number
    component(lnum, hls.title, {
      after = '',
      prefix = icons.misc.line,
      prefix_color = hls.metadata_prefix,
      priority = 7,
    }),

    component(line_count, hls.comment, {
      before = '',
      prefix = '/',
      padding = { prefix = false, suffix = true },
      prefix_color = hls.comment,
      priority = 7,
    }),

    -- column
    component(col, hls.title, {
      prefix = 'Col:',
      prefix_color = hls.metadata_prefix,
      priority = 7,
    }),
    -- (Unexpected) Indentation
    component_if(ctx.shiftwidth, ctx.shiftwidth > 2 or not ctx.expandtab, hls.title, {
      prefix = ctx.expandtab and icons.misc.indent or icons.misc.tab,
      prefix_color = hls.statusline,
      priority = 6,
    }),
    end_marker()
  )
  -- removes 5 columns to add some padding
  return str.display(statusline, available_space - 5)
end

local function adopt_window_highlights()
  local curr_winhl = vim.opt_local.winhighlight:get()
  if as.empty(curr_winhl) or not curr_winhl.StatusLine then return end

  for _, part in pairs(stl_winhl) do
    local name = part.hl(api.nvim_get_current_win())
    local hl = highlight.get(name)
    if not as.empty(hl) then return end
    highlight.set(
      name,
      { inherit = part.fallback, background = { from = curr_winhl.StatusLine, attr = 'bg' } }
    )
  end
end

local set_stl_ft_icon_hls, reset_stl_ft_icon_hls = (function()
  ---@type table<string, {name: string, hl: string}>
  local hl_cache = {}
  ---@param buf number
  ---@param ft string
  return function(buf, ft)
    if as.empty(ft) then return end
    local _, hl = get_buffer_icon(buf)
    if not hl then return end
    local fg, bg = highlight.get(hl, 'fg'), highlight.get(hls.statusline, 'bg')
    if not bg and not fg then return end
    local name = get_ft_icon_hl_name(hl)
    hl_cache[ft] = { name = name, hl = fg }
    highlight.set(name, { fg = fg, bg = bg })
  end, function()
    for _, data in pairs(hl_cache) do
      highlight.set(data.name, { fg = data.hl, bg = highlight.get(hls.statusline, 'bg') })
    end
  end
end)()

as.augroup('CustomStatusline', {
  event = 'FocusGained',
  command = function() vim.g.vim_in_focus = true end,
}, {
  event = 'FocusLost',
  command = function() vim.g.vim_in_focus = false end,
}, {
  event = 'ColorScheme',
  command = colors,
}, {
  event = 'ColorScheme',
  command = reset_stl_ft_icon_hls,
}, {
  event = 'FileType',
  command = function(args) set_stl_ft_icon_hls(args.buf, args.match) end,
}, {
  event = 'WinEnter',
  command = adopt_window_highlights,
}, {
  event = 'BufReadPre',
  once = true,
  command = git_updates,
}, {
  event = 'LspAttach',
  command = function(args)
    local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
    if #clients > MAX_LSP_SERVER_COUNT then state.lsp_clients_visible = false end
  end,
}, {
  event = 'BufWritePre',
  pattern = { '*' },
  command = function()
    if not vim.g.is_saving and vim.bo.modified then
      vim.g.is_saving = true
      vim.defer_fn(function() vim.g.is_saving = false end, 1000)
    end
  end,
}, {
  event = 'User',
  pattern = { 'NeogitPushComplete', 'NeogitCommitComplete', 'NeogitStatusRefresh' },
  command = update_git_status,
})

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%{%v:lua.as.ui.statusline.render()%}'
