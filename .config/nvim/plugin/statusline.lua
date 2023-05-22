if not as or not as.ui.statusline.enable then return end

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

local section, spacer, display = str.section, str.spacer, str.display
local icons, lsp, highlight, decorations = as.ui.icons, as.ui.lsp, as.highlight, as.ui.decorations
local api, fn, fs, fmt, strwidth = vim.api, vim.fn, vim.fs, string.format, vim.api.nvim_strwidth
local P, falsy = as.ui.palette, as.falsy

local sep = package.config:sub(1, 1)
local space = ' '
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

  local bg_color = highlight.tint(normal_bg, -0.25)

  -- stylua: ignore
  highlight.all({
    { [hls.metadata] = { bg = bg_color, inherit = 'Comment' } },
    { [hls.metadata_prefix] = { bg = bg_color, fg = { from = 'Comment' } } },
    { [hls.indicator] = { bg = bg_color, fg = indicator_color } },
    { [hls.modified] = { fg = string_fg, bg = bg_color } },
    { [hls.git] = { fg = P.light_gray, bg = bg_color } },
    { [hls.green] = { fg = string_fg, bg = bg_color } },
    { [hls.blue] = { fg = P.dark_blue, bg = bg_color, bold = true } },
    { [hls.number] = { fg = number_fg, bg = bg_color } },
    { [hls.count] = { fg = 'bg', bg = indicator_color, bold = true } },
    { [hls.client] = { bg = bg_color, fg = normal_fg, bold = true } },
    { [hls.env] = { bg = bg_color, fg = error_color, italic = true, bold = true } },
    { [hls.directory] = { bg = bg_color, fg = 'Gray', italic = true } },
    { [hls.directory_inactive] = { bg = bg_color, italic = true, fg = { from = 'Normal', alter = 0.4 } } },
    { [hls.parent_directory] = { bg = bg_color, fg = string_fg, bold = true } },
    { [hls.title] = { bg = bg_color, fg = 'LightGray', bold = true } },
    { [hls.comment] = { bg = bg_color, inherit = 'Comment' } },
    { [hls.statusline] = { bg = bg_color } },
    { [hls.statusline_nc] = { link = 'VertSplit' } },
    { [hls.info] = { fg = info_color, bg = bg_color, bold = true } },
    { [hls.warn] = { fg = warning_fg, bg = bg_color } },
    { [hls.error] = { fg = error_color, bg = bg_color } },
    { [hls.filename] = { bg = bg_color, fg = 'LightGray', bold = true } },
    { [hls.filename_inactive] = { inherit = 'Comment', bg = bg_color, bold = true } },
    { [hls.mode_normal] = { bg = bg_color, fg = P.light_gray, bold = true } },
    { [hls.mode_insert] = { bg = bg_color, fg = P.dark_blue, bold = true } },
    { [hls.mode_visual] = { bg = bg_color, fg = P.magenta, bold = true } },
    { [hls.mode_replace] = { bg = bg_color, fg = P.dark_red, bold = true } },
    { [hls.mode_command] = { bg = bg_color, fg = P.light_yellow, bold = true } },
    { [hls.mode_select] = { bg = bg_color, fg = P.teal, bold = true } },
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
    ['fzf'] = '',
    ['log'] = '',
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
    ['octo'] = '',
    ['minimap'] = '',
    ['undotree'] = 'פּ',
    ['NvimTree'] = 'פּ',
    ['neo-tree'] = 'פּ',
    ['neotest.*'] = 'פּ',
    ['dapui_.*'] = '',
    ['dap-repl'] = '',
    ['toggleterm'] = ' ',
  }),
  names = as.p_table({
    ['fzf'] = 'FZF',
    ['orgagenda'] = 'Org',
    ['himalaya-msg-list'] = 'Inbox',
    ['mail'] = 'Mail',
    ['minimap'] = '',
    ['dbui'] = 'Dadbod UI',
    ['tsplayground'] = 'Treesitter',
    ['NeogitStatus'] = 'Neogit Status',
    ['Neogit.*'] = 'Neogit',
    ['Trouble'] = 'Lsp Trouble',
    ['gitcommit'] = 'Git commit',
    ['help'] = 'help',
    ['undotree'] = 'UndoTree',
    ['octo'] = 'Octo',
    ['NvimTree'] = 'Nvim Tree',
    ['dap-repl'] = 'Debugger REPL',
    ['Diffview.*'] = 'Diff view',
    ['neotest.*'] = 'Testing',

    ['log'] = function(fname, _) return fmt('Log(%s)', fs.basename(fname)) end,

    ['dapui_.*'] = function(fname) return fname end,

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

local function adopt_window_highlights()
  local curr_winhl = vim.opt_local.winhighlight:get()
  if falsy(curr_winhl) or not curr_winhl.StatusLine then return end

  for _, part in pairs(stl_winhl) do
    local name = part.hl(api.nvim_get_current_win())
    local hl = highlight.get(name)
    if not falsy(hl) then return end
    highlight.set(name, {
      inherit = part.fallback,
      bg = { from = curr_winhl.StatusLine, attr = 'bg' },
    })
  end
end

local set_filetype_icon_highlights, reset_filetype_icon_highlights = (function()
  ---@type table<string, {name: string, hl: string}>
  local hl_cache = {}
  ---@param buf number
  ---@param ft string
  return function(buf, ft)
    if falsy(ft) then return end
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
  if ctx.preview then return 'preview' end
  if ctx.buftype == 'quickfix' then return 'Quickfix List' end
  if ctx.buftype == 'terminal' and falsy(ctx.filetype) then
    return ('Terminal(%s)'):format(fn.fnamemodify(vim.env.SHELL, ':t'))
  end
  if fn.getloclist(0, { filewinid = 0 }).filewinid > 0 then return 'Location List' end
  return nil
end

---Only append the path separator if the path is not empty
---@param path string
---@return string
local function with_sep(path) return (not falsy(path) and path:sub(-1) ~= sep) and path .. sep or path end
local SYNC_DIR = fn.resolve(vim.env.SYNC_DIR)

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
    [vim.env.HOME] = '~',
    [vim.g.work_dir] = '$WORK',
    [vim.g.projects_dir] = '$PROJECTS',
    [vim.env.VIMRUNTIME] = '$VIMRUNTIME',
    [SYNC_DIR] = '$SYNC',
  }
  local result, env, prev_match = directory, '', ''
  for dir, alias in pairs(paths) do
    local match, count = fs.normalize(directory):gsub(vim.pesc(with_sep(dir)), '')
    if count == 1 and #dir > #prev_match then
      result, env, prev_match = match, alias, dir
    end
  end
  return result, env
end

--- @param ctx StatuslineContext
--- @return {env: string?, dir: string?, parent: string?, fname: string}
local function filename(ctx)
  local buf, ft = ctx.bufnum, ctx.filetype
  local special_buf = special_buffers(ctx)
  if special_buf then return { fname = special_buf } end

  local path = api.nvim_buf_get_name(buf)
  if falsy(path) then return { fname = 'No Name' } end
  --- add ":." to the expansion i.e. to make the directory path relative to the current vim directory
  local parts = vim.split(path, sep)
  local fname = table.remove(parts)

  local name = identifiers.names[ft]
  if name then return { fname = vim.is_callable(name) and name(fname, buf) or name } end

  local parent = table.remove(parts)
  fname = fn.isdirectory(fname) == 1 and fname .. sep or fname
  if falsy(parent) then return { fname = fname } end

  local dir = with_sep(table.concat(parts, sep))
  local new_dir, env = dir_env(dir)
  local segment = not falsy(env) and env .. new_dir or dir
  if strwidth(segment) > math.floor(vim.o.columns / 3) then new_dir = fn.pathshorten(new_dir) end

  return { env = with_sep(env), dir = with_sep(new_dir), parent = with_sep(parent), fname = fname }
end

---Create the various segments of the current filename
---@param ctx StatuslineContext
---@param minimal boolean
---@return {file: ComponentOpts, parent: ComponentOpts, dir: ComponentOpts, env: ComponentOpts}
local function stl_file(ctx, minimal)
  -- highlight the filename components separately
  local filename_hl = ctx.winhl and stl_winhl.filename.hl(ctx.win)
    or (minimal and hls.filename_inactive or hls.filename)

  local directory_hl = ctx.winhl and stl_winhl.directory.hl(ctx.win)
    or (minimal and hls.directory_inactive or hls.directory)

  local parent_hl = ctx.winhl and stl_winhl.parent.hl(ctx.win) or (minimal and directory_hl or hls.parent_directory)

  local env_hl = ctx.winhl and stl_winhl.env.hl(ctx.win) or (minimal and directory_hl or hls.env)

  local ft_icon, icon_highlight = filetype(ctx)
  local ft_hl = icon_highlight and get_ft_icon_hl_name(icon_highlight) or hls.comment

  local file_opts = { {}, before = '', after = ' ', priority = 0 }
  local parent_opts = { {}, before = '', after = '', priority = 2 }
  local dir_opts = { {}, before = '', after = '', priority = 3 }
  local env_opts = { {}, before = '', after = '', priority = 4 }

  local p = filename(ctx)

  -- Depending on which filename segments are empty we select a section to add the file icon to
  local env_empty, dir_empty, parent_empty = falsy(p.env), falsy(p.dir), falsy(p.parent)
  local to_update = (env_empty and dir_empty and parent_empty) and file_opts
    or (env_empty and dir_empty) and parent_opts
    or env_empty and dir_opts
    or env_opts

  table.insert(to_update[1], { ft_icon .. ' ', not minimal and ft_hl or nil })
  table.insert(env_opts[1], { p.env or '', env_hl })
  table.insert(dir_opts[1], { p.dir or '', directory_hl })
  table.insert(file_opts[1], { p.fname or '', filename_hl })
  table.insert(parent_opts[1], { p.parent or '', parent_hl })
  return { env = env_opts, file = file_opts, dir = dir_opts, parent = parent_opts }
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
  vim.cmd('redrawstatus')
end

---Return a sorted list of lsp client names and their priorities
---@param ctx StatuslineContext
---@return table[]
local function stl_lsp_clients(ctx)
  local clients = vim.lsp.get_active_clients({ bufnr = ctx.bufnum })
  if not state.lsp_clients_visible then return { { name = fmt('%d attached', #clients), priority = 7 } } end
  if falsy(clients) then return { { name = 'No LSP clients available', priority = 7 } } end
  table.sort(clients, function(a, b)
    if a.name == 'null-ls' then return false end
    if b.name == 'null-ls' then return true end
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
  if fail ~= 0 then vim.schedule(function() vim.notify('Failed to start git update job: ' .. fail) end) end
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
--  Utility functions
----------------------------------------------------------------------------------------------------

--- @param ctx StatuslineContext
local function is_plain(ctx)
  local decor = decorations.get({ ft = ctx.filetype, bt = ctx.buftype, setting = 'statusline' })
  local is_plain_ft, is_plain_bt = decor.ft == 'minimal', decor.bt == 'minimal'
  return is_plain_ft or is_plain_bt or ctx.preview
end

--- @param ctx StatuslineContext
--- @param icon string | nil
local function is_modified(ctx, icon) return ctx.filetype == 'help' and '' or ctx.modified and (icon or '✎') or '' end

--- @param ctx StatuslineContext
--- @param icon string | nil
local function is_readonly(ctx, icon) return ctx.readonly and ' ' .. (icon or '') or '' end

----------------------------------------------------------------------------------------------------
--  RENDER
----------------------------------------------------------------------------------------------------

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function as.ui.statusline.render()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)

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
  local l1 = section:new({
    { { icons.misc.block, hls.indicator } },
    cond = not plain,
    before = '',
    after = '',
    priority = 0,
  }, spacer(1))
  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  local path = stl_file(ctx, plain)
  local readonly_hl = ctx.winhl and stl_winhl.readonly.hl(ctx.win) or stl_winhl.readonly.fallback
  local readonly_component = { { { is_readonly(ctx), readonly_hl } }, priority = 1 }
  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if plain or not focused then
    local l2 = section:new(readonly_component, path.env, path.dir, path.parent, path.file)
    return display({ l1 + l2 }, available_space)
  end
  -----------------------------------------------------------------------------//
  -- Variables
  -----------------------------------------------------------------------------//

  local mode, mode_hl = stl_mode()
  local lnum, col = unpack(api.nvim_win_get_cursor(curwin))
  col = col + 1 -- this should be 1-indexed, but isn't by default
  local line_count = api.nvim_buf_line_count(ctx.bufnum)

  --- @type {head: string?, added: integer?, changed: integer?, removed: integer?}
  local status = vim.b[curbuf].gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -----------------------------------------------------------------------------//
  local hydra_active, hydra = stl_hydra()
  -----------------------------------------------------------------------------//
  local ok, noice = pcall(require, 'noice')
  local noice_mode = ok and noice.api.status.mode.get() or ''
  local has_noice_mode = ok and noice.api.status.mode.has() or false
  -----------------------------------------------------------------------------//
  local lazy_ok, lazy = pcall(require, 'lazy.status')
  local pending_updates = lazy_ok and lazy.updates() or nil
  local has_pending_updates = lazy_ok and lazy.has_updates() or false
  -----------------------------------------------------------------------------//
  -- LSP
  -----------------------------------------------------------------------------//
  local flutter = vim.g.flutter_tools_decorations or {}
  local diagnostics = diagnostic_info(ctx)
  local lsp_clients = as.map(function(client)
    return {
      {
        { client.name, hls.client },
        { space },
        { '', hls.metadata_prefix },
      },
      priority = client.priority,
    }
  end, stl_lsp_clients(ctx))
  table.insert(lsp_clients[1][1], 1, { ' LSP(s): ', hls.metadata })
  lsp_clients[1].id = LSP_COMPONENT_ID -- the unique id of the component
  lsp_clients[1].click = 'v:lua.as.ui.statusline.lsp_client_click'
  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  local l2 = section:new(
    { { { file_modified, hls.modified } }, cond = ctx.modified, priority = 1 },
    readonly_component,
    { { { mode, mode_hl } }, priority = 0 },
    { { { search_count(), hls.count } }, cond = vim.v.hlsearch > 0, priority = 1 },
    path.env,
    path.dir,
    path.parent,
    path.file,
    {
      { { diagnostics.warn.icon, hls.warn }, { space }, { diagnostics.warn.count, hls.warn } },
      cond = diagnostics.warn.count,
      priority = 3,
    },
    {
      { { diagnostics.error.icon, hls.error }, { space }, { diagnostics.error.count, hls.error } },
      cond = diagnostics.error.count,
      priority = 1,
    },
    {
      { { diagnostics.info.icon, hls.info }, { space }, { diagnostics.info.count, hls.info } },
      cond = diagnostics.info.count,
      priority = 4,
    },
    {
      { { icons.misc.shaded_lock, hls.metadata } },
      cond = vim.b[ctx.bufnum].formatting_disabled == true or vim.g.formatting_disabled == true,
      priority = 5,
    }
  )
  -----------------------------------------------------------------------------//
  -- Middle section
  -----------------------------------------------------------------------------//
  -- Neovim allows unlimited alignment sections so we can put things in the
  -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
  -----------------------------------------------------------------------------//
  local m1 = section:new({
    { { noice_mode, hls.title } },
    cond = has_noice_mode,
    before = ' ',
    priority = 1,
  }, {
    { { '🐙 ' .. hydra.name:upper(), hydra.color } },
    cond = hydra_active,
    priority = 5,
  })
  -----------------------------------------------------------------------------//
  -- Right section
  -----------------------------------------------------------------------------//
  local r1 = section:new(
    {
      { { 'updates:', hls.comment }, { space }, { pending_updates, hls.title } },
      priority = 3,
      cond = has_pending_updates,
    },
    { { { flutter.app_version, hls.metadata } }, priority = 4 },
    { { { flutter.device and flutter.device.name or '', hls.metadata } }, priority = 4 },
    -----------------------------------------------------------------------------//
    -- LSP Clients
    -----------------------------------------------------------------------------//
    unpack(lsp_clients)
  )
  local r2 = section:new(
    {
      { { icons.misc.bug }, { space }, { debugger(), hls.metadata } },
      priority = 4,
      cond = debugger(),
    },
    -----------------------------------------------------------------------------//
    --  Git status
    -----------------------------------------------------------------------------//
    {
      { { icons.git.branch, hls.git }, { space }, { status.head, hls.blue } },
      priority = 1,
      cond = not falsy(status.head),
    },
    {
      { { icons.git.mod, hls.warn }, { space }, { status.changed, hls.title } },
      priority = 3,
      cond = not falsy(status.changed),
    },
    {
      { { icons.git.remove, hls.error }, { space }, { status.removed, hls.title } },
      priority = 3,
      cond = not falsy(status.removed),
    },
    {
      { { icons.git.add, hls.green }, { space }, { status.added, hls.title } },
      priority = 3,
      cond = not falsy(status.added),
    },
    {
      { { icons.misc.up, hls.green }, { space }, { ahead, hls.title } },
      cond = ahead,
      before = '',
      priority = 5,
    },
    {
      { { icons.misc.down, hls.number }, { space }, { behind, hls.title } },
      after = ' ',
      cond = behind,
      priority = 5,
    },
    -- Current line number/total line number
    {
      {
        { icons.misc.line, hls.metadata_prefix },
        { space },
        { fmt('%+' .. strwidth(tostring(line_count)) .. 's', lnum), hls.title },
        { '/', hls.comment },
        { line_count, hls.comment },
      },
      priority = 7,
    },
    {
      { { 'Col:', hls.metadata_prefix }, { space }, { fmt('%+2s', col), hls.title } },
      priority = 7,
    },
    -- (Unexpected) Indentation
    {
      {
        { ctx.expandtab and icons.misc.indent or icons.misc.tab },
        { space },
        { ctx.shiftwidth, hls.title },
      },
      cond = ctx.shiftwidth > 2 or not ctx.expandtab,
      priority = 6,
    }
  )
  -- removes 5 columns to add some padding
  return display({ l1 + l2, m1, r1 + r2 }, available_space - 5)
end

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%{%v:lua.as.ui.statusline.render()%}'

as.augroup('CustomStatusline', {
  event = 'FocusGained',
  command = function() vim.g.vim_in_focus = true end,
}, {
  event = 'FocusLost',
  command = function() vim.g.vim_in_focus = false end,
}, {
  event = 'ColorScheme',
  command = function()
    colors()
    reset_filetype_icon_highlights()
  end,
}, {
  event = 'FileType',
  command = function(args) set_filetype_icon_highlights(args.buf, args.match) end,
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
    if vim.o.columns < 200 and #clients > MAX_LSP_SERVER_COUNT then state.lsp_clients_visible = false end
  end,
}, {
  event = 'User',
  pattern = { 'NeogitPushComplete', 'NeogitCommitComplete', 'NeogitStatusRefresh' },
  command = update_git_status,
})
