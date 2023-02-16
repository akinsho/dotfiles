if not as then return end

----------------------------------------------------------------------------------------------------
-- RESOURCES:
----------------------------------------------------------------------------------------------------
--- 1. https://gabri.me/blog/diy-vim-statusline
--- 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
--- 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
--- 4. Right sided truncation - https://stackoverflow.com/a/20899652

local str = require('as.format_string')

local api, fn, fmt = vim.api, vim.fn, string.format
local icons, win_hl = as.ui.icons, as.highlight.win_hl
local P = as.ui.palette
local C = str.constants

local hydra_colors = {
  red = 'HydraRedSt',
  blue = 'HydraBlueSt',
  amaranth = 'HydraAmaranthSt',
  teal = 'HydraTealSt',
  pink = 'HydraPinkSt',
}

local function colors()
  --- NOTE: Unicode characters including vim devicons should NOT be highlighted
  --- as italic or bold, this is because the underlying bold font is not necessarily
  --- patched with the nerd font characters
  --- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
  --- but this is not universal across terminals so should be avoided

  local indicator_color = P.bright_blue
  local warning_fg = as.ui.lsp.colors.warn

  local error_color = as.ui.lsp.colors.error
  local info_color = as.ui.lsp.colors.info
  local normal_fg = as.highlight.get('Normal', 'fg')
  local string_fg = as.highlight.get('String', 'fg')
  local number_fg = as.highlight.get('Number', 'fg')
  local normal_bg = as.highlight.get('Normal', 'bg')

  local bg_color = as.highlight.alter_color(normal_bg, -16)

  -- stylua: ignore
  as.highlight.all({
    { StMetadata = { background = bg_color, inherit = 'Comment' } },
    { StMetadataPrefix = { background = bg_color, foreground = { from = 'Comment' } } },
    { StIndicator = { background = bg_color, foreground = indicator_color } },
    { StModified = { foreground = string_fg, background = bg_color } },
    { StGit = { foreground = P.light_gray, background = bg_color } },
    { StGreen = { foreground = string_fg, background = bg_color } },
    { StBlue = { foreground = P.dark_blue, background = bg_color, bold = true } },
    { StNumber = { foreground = number_fg, background = bg_color } },
    { StCount = { foreground = 'bg', background = indicator_color, bold = true } },
    { StClient = { background = bg_color, foreground = normal_fg, bold = true } },
    { StDirectory = { background = bg_color, foreground = 'Gray', italic = true } },
    { StDirectoryInactive = { background = bg_color, italic = true, foreground = { from = 'Normal', alter = 40 } } },
    { StParentDirectory = { background = bg_color, foreground = string_fg, bold = true } },
    { StTitle = { background = bg_color, foreground = 'LightGray', bold = true } },
    { StComment = { background = bg_color, inherit = 'Comment' } },
    { StatusLine = { background = bg_color } },
    { StatusLineNC = { link = 'VertSplit' } },
    { StInfo = { foreground = info_color, background = bg_color, bold = true } },
    { StWarn = { foreground = warning_fg, background = bg_color } },
    { StError = { foreground = error_color, background = bg_color } },
    { StFilename = { background = bg_color, foreground = 'LightGray', bold = true } },
    { StFilenameInactive = { inherit = 'Comment', background = bg_color, bold = true } },
    { StModeNormal = { background = bg_color, foreground = P.light_gray, bold = true } },
    { StModeInsert = { background = bg_color, foreground = P.dark_blue, bold = true } },
    { StModeVisual = { background = bg_color, foreground = P.magenta, bold = true } },
    { StModeReplace = { background = bg_color, foreground = P.dark_red, bold = true } },
    { StModeCommand = { background = bg_color, foreground = P.light_yellow, bold = true } },
    { StModeSelect = { background = bg_color, foreground = P.teal, bold = true } },
    -- FOR HYDRA
    { [hydra_colors.red] = { inherit = 'HydraRed', reverse = true } },
    { [hydra_colors.blue] = { inherit = 'HydraBlue', reverse = true } },
    { [hydra_colors.amaranth] = { inherit = 'HydraAmaranth', reverse = true } },
    { [hydra_colors.teal] = { inherit = 'HydraTeal', reverse = true } },
    { [hydra_colors.pink] = { inherit = 'HydraPink', reverse = true } },
  })
end

local identifiers = {
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
    ['DiffviewFiles'] = 'Diff view',
    ['neo-tree'] = function(fname, _)
      local parts = vim.split(fname, ' ')
      return fmt('Neo Tree(%s)', parts[2])
    end,
    ['toggleterm'] = function(_, buf)
      local shell = fn.fnamemodify(vim.env.SHELL, ':t')
      return fmt('Terminal(%s)[%s]', shell, api.nvim_buf_get_var(buf, 'toggle_number'))
    end,
  },
}

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
  local ft_exception = identifiers.filetypes[ctx.filetype]
  if ft_exception then return ft_exception, opts.default end
  local bt_exception = identifiers.buftypes[ctx.buftype]
  if bt_exception then return bt_exception, opts.default end
  local icon, hl
  local extension = fn.fnamemodify(ctx.bufname, ':e')
  local icons_loaded, devicons = as.require('nvim-web-devicons')
  if icons_loaded then
    icon, hl = devicons.get_icon(ctx.bufname, extension, { default = true })
    hl = highlight_ft_icon(hl, opts.icon_bg)
  end
  return icon, hl
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
  if normal_term then return 'Terminal(' .. fn.fnamemodify(vim.env.SHELL, ':t') .. ')' end
  if ctx.preview then return 'preview' end

  return nil
end

--- @param ctx table
--- @param modifier string
local function filename(ctx, modifier)
  local function buf_expand(bufnum, mod) return fn.expand('#' .. bufnum .. mod) end
  modifier = modifier or ':t'
  local special_buf = special_buffers(ctx)
  if special_buf then return '', '', special_buf end

  local fname = buf_expand(ctx.bufnum, modifier)

  local name = identifiers.names[ctx.filetype]
  if type(name) == 'function' then return '', '', name(fname, ctx.bufnum) end
  if name then return '', '', name end
  if not fname or as.empty(fname) then return '', '', 'No Name' end

  local path = (ctx.buftype == '' and not ctx.preview) and buf_expand(ctx.bufnum, ':~:.:h') or nil
  local is_root = path and #path == 1 -- "~" or "."
  local dir = path and not is_root and fn.fnamemodify(path, ':h') .. '/' or ''
  if api.nvim_strwidth(dir) > math.floor(vim.o.columns / 3) then dir = fn.pathshorten(dir) end
  local parent = path and (is_root and path or fn.fnamemodify(path, ':t')) or ''
  parent = parent ~= '' and parent .. '/' or ''

  return dir, parent, fname
end

---Create the various segments of the current filename
---@param ctx table
---@param minimal boolean
---@return table
local function stl_file(ctx, minimal)
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

local function diagnostic_info(context)
  local diagnostics = vim.diagnostic.get(context.bufnum)
  local severities = vim.diagnostic.severity
  local lsp = as.ui.icons.lsp
  local result = {
    error = { count = 0, icon = lsp.error },
    warn = { count = 0, icon = lsp.warn },
    info = { count = 0, icon = lsp.info },
    hint = { count = 0, icon = lsp.hint },
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
    color = hydra_colors[hydra.get_color()],
  }
  return hydra.is_active(), data
end

-----------------------------------------------------------------------------//
-- Last search count
-----------------------------------------------------------------------------//

local function search_count()
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
  elseif visual_regex and visual_regex:match_str(mode) then
    return 'StModeVisual'
  elseif select_regex and select_regex:match_str(mode) then
    return 'StModeSelect'
  elseif replace_regex and replace_regex:match_str(mode) then
    return 'StModeReplace'
  elseif command_regex and command_regex:match_str(mode) then
    return 'StModeCommand'
  else
    return 'StModeNormal'
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

---Return a sorted list of lsp client names and their priorities
---@param ctx table
---@return table[]
local function stl_lsp_clients(ctx)
  local clients = vim.lsp.get_active_clients({ bufnr = ctx.bufnum })
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
  return fn.isdirectory(fmt('%s/.git', fn.getcwd(win_id))) == 1
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

--- @param ctx table
local function is_plain(ctx)
  local ft = as.ui.settings.filetypes[ctx.filetype]
  local bt = as.ui.settings.buftypes[ctx.buftype]
  local is_plain_ft = ft and ft.statusline == 'minimal'
  local is_plain_buftype = bt and bt.statusline == 'minimal'
  return is_plain_ft or is_plain_buftype or ctx.preview
end

--- @param ctx table
--- @param icon string | nil
local function is_modified(ctx, icon)
  return ctx.filetype == 'help' and '' or ctx.modified and (icon or '✎') or ''
end

--- @param ctx table
--- @param icon string | nil
local function is_readonly(ctx, icon) return ctx.readonly and ' ' .. (icon or '') or '' end

local separator = function() return { component = C.ALIGN, length = 0, priority = 0 } end
local end_marker = function() return { component = C.END, length = 0, priority = 0 } end

----------------------------------------------------------------------------------------------------
--  RENDER
----------------------------------------------------------------------------------------------------

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function as.ui.statusline()
  local curwin = api.nvim_get_current_win()
  local curbuf = api.nvim_win_get_buf(curwin)

  local component = str.component
  local component_if = str.component_if

  local available_space = vim.o.columns

  local ctx = {
    bufnum = curbuf,
    winid = curwin,
    bufname = api.nvim_buf_get_name(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab,
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
    component_if(icons.misc.block, not plain, 'StIndicator', {
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
  local dir, parent, file = segments.dir, segments.parent, segments.file
  local dir_component = component(dir.item, dir.hl, dir.opts)
  local parent_component = component(parent.item, parent.hl, parent.opts)

  if not plain and is_git_repo(ctx.winid) then
    file.opts.suffix = icons.git.repo
    file.opts.suffix_color = 'StMetadata'
  end
  local file_component = component(file.item, file.hl, file.opts)

  local readonly_hl = as.highlight.win_hl.adopt(curwin, 'StatusLine', 'StCustomError', 'StError')
  local readonly_component = component(is_readonly(ctx), readonly_hl, { priority = 1 })
  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if plain or not focused then
    add(readonly_component, dir_component, parent_component, file_component)
    return str.display(statusline, available_space)
  end
  -----------------------------------------------------------------------------//
  -- Variables
  -----------------------------------------------------------------------------//

  local mode, mode_hl = stl_mode()
  local lnum, col = unpack(api.nvim_win_get_cursor(curwin))
  local line_count = api.nvim_buf_line_count(ctx.bufnum)

  -- Git state
  local status = vim.b.gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -- LSP Diagnostics
  local diagnostics = diagnostic_info(ctx)
  local flutter = vim.g.flutter_tools_decorations or {}

  -- HYDRA
  local hydra_active, hydra = stl_hydra()
  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  add(
    component_if(file_modified, ctx.modified, 'StModified', { priority = 1 }),

    readonly_component,

    component(mode, mode_hl, { priority = 0 }),

    component_if(search_count(), vim.v.hlsearch > 0, 'StCount', { priority = 1 }),

    dir_component,
    parent_component,
    file_component,

    component_if('Saving…', vim.g.is_saving, 'StComment', { before = ' ', priority = 1 }),

    -- Local plugin dev indicator
    component_if(available_space > 100 and 'local dev' or '', vim.env.DEVELOPING ~= nil, 'StComment', {
      prefix = icons.misc.tools,
      padding = 'none',
      before = '  ',
      prefix_color = 'StWarn',
      small = 1,
      priority = 2,
    }),
    separator(),
    -----------------------------------------------------------------------------//
    -- Middle section
    -----------------------------------------------------------------------------//
    -- Neovim allows unlimited alignment sections so we can put things in the
    -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
    -----------------------------------------------------------------------------//
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
    component(flutter.app_version, 'StMetadata', { priority = 4 }),

    component(flutter.device and flutter.device.name or '', 'StMetadata', { priority = 4 })
  )

  -----------------------------------------------------------------------------//
  -- LSP Clients
  -----------------------------------------------------------------------------//
  local lsp_clients = as.map(function(client, index)
    return component(client.name, 'StClient', {
      prefix = index == 1 and ' LSP(s):' or nil,
      prefix_color = index == 1 and 'StMetadata' or nil,
      suffix = '', -- │
      suffix_color = 'StMetadataPrefix',
      priority = client.priority,
    })
  end, stl_lsp_clients(ctx))
  add(unpack(lsp_clients))
  -----------------------------------------------------------------------------//

  add(
    component(debugger(), 'StMetadata', { prefix = icons.misc.bug, priority = 4 }),

    component_if(diagnostics.error.count, diagnostics.error, 'StError', {
      prefix = diagnostics.error.icon,
      prefix_color = 'StError',
      priority = 1,
    }),

    component_if(diagnostics.warn.count, diagnostics.warn, 'StWarn', {
      prefix = diagnostics.warn.icon,
      prefix_color = 'StWarn',
      priority = 3,
    }),

    component_if(diagnostics.info.count, diagnostics.info, 'StInfo', {
      prefix = diagnostics.info.icon,
      prefix_color = 'StInfo',
      priority = 4,
    }),

    -- Git Status
    component(status.head, 'StBlue', {
      prefix = icons.git.branch,
      prefix_color = 'StGit',
      priority = 1,
    }),

    component(status.changed, 'StTitle', {
      prefix = icons.git.mod,
      prefix_color = 'StWarn',
      priority = 3,
    }),

    component(status.removed, 'StTitle', {
      prefix = icons.git.remove,
      prefix_color = 'StError',
      priority = 3,
    }),

    component(status.added, 'StTitle', {
      prefix = icons.git.add,
      prefix_color = 'StGreen',
      priority = 3,
    }),

    component(ahead, 'StTitle', {
      prefix = icons.misc.up,
      prefix_color = 'StGreen',
      before = '',
      priority = 5,
    }),

    component(behind, 'StTitle', {
      prefix = icons.misc.down,
      prefix_color = 'StNumber',
      after = ' ',
      priority = 5,
    }),

    -- Current line number/total line number
    component(lnum, 'StTitle', {
      after = '',
      prefix = icons.misc.line,
      prefix_color = 'StMetadataPrefix',
      priority = 7,
    }),

    component(line_count, 'StComment', {
      before = '',
      prefix = '/',
      padding = { prefix = false, suffix = true },
      prefix_color = 'StComment',
      priority = 7,
    }),

    -- column
    component(col, 'StTitle', {
      prefix = 'Col:',
      prefix_color = 'StMetadataPrefix',
      priority = 7,
    }),
    -- (Unexpected) Indentation
    component_if(ctx.shiftwidth, ctx.shiftwidth > 2 or not ctx.expandtab, 'StTitle', {
      prefix = ctx.expandtab and icons.misc.indent or icons.misc.tab,
      prefix_color = 'StatusLine',
      priority = 6,
    }),
    end_marker()
  )
  -- removes 5 columns to add some padding
  return str.display(statusline, available_space - 5)
end

as.augroup('CustomStatusline', {
  {
    event = { 'FocusGained' },
    pattern = { '*' },
    command = function() vim.g.vim_in_focus = true end,
  },
  {
    event = { 'FocusLost' },
    pattern = { '*' },
    command = function() vim.g.vim_in_focus = false end,
  },
  {
    event = { 'ColorScheme' },
    pattern = { '*' },
    command = colors,
  },
  {
    event = { 'BufReadPre' },
    once = true,
    pattern = { '*' },
    command = git_updates,
  },
  {
    event = { 'BufWritePre' },
    pattern = { '*' },
    command = function()
      if not vim.g.is_saving and vim.bo.modified then
        vim.g.is_saving = true
        vim.defer_fn(function() vim.g.is_saving = false end, 1000)
      end
    end,
  },
  {
    event = 'User',
    pattern = {
      'NeogitPushComplete',
      'NeogitCommitComplete',
      'NeogitStatusRefresh',
    },
    command = update_git_status,
  },
})

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%{%v:lua.as.ui.statusline()%}'
