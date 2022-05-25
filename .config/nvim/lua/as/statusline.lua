--- =====================================================================
--- Resources:
--- =====================================================================
--- 1. https://gabri.me/blog/diy-vim-statusline
--- 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
--- 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
--- 4. Right sided truncation - https://stackoverflow.com/a/20899652

local utils = require('as.utils.statusline')
local H = require('as.highlights')

local api = vim.api
local icons = as.style.icons
local P = as.style.palette
local C = utils.constants

local M = {}

local function colors()
  --- NOTE: Unicode characters including vim devicons should NOT be highlighted
  --- as italic or bold, this is because the underlying bold font is not necessarily
  --- patched with the nerd font characters
  --- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
  --- but this is not universal across terminals so should be avoided

  local indicator_color = P.bright_blue
  local warning_fg = as.style.lsp.colors.warn

  local error_color = as.style.lsp.colors.error
  local info_color = as.style.lsp.colors.info
  local normal_fg = H.get_hl('Normal', 'fg')
  local pmenu_bg = H.get_hl('Pmenu', 'bg')
  local string_fg = H.get_hl('String', 'fg')
  local number_fg = H.get_hl('Number', 'fg')
  local inc_search_bg = H.get_hl('Search', 'bg')

  local normal_bg = H.get_hl('Normal', 'bg')
  local dim_color = H.alter_color(normal_bg, 40)
  local bg_color = H.alter_color(normal_bg, -16)

  H.all({
    StMetadata = { background = bg_color, inherit = 'Comment' },
    StMetadataPrefix = {
      background = bg_color,
      inherit = 'Comment',
      italic = false,
      bold = false,
    },
    StIndicator = { background = bg_color, foreground = indicator_color },
    StModified = { foreground = string_fg, background = bg_color },
    StGit = { foreground = P.light_red, background = bg_color },
    StGreen = { foreground = string_fg, background = bg_color },
    StBlue = { foreground = P.dark_blue, background = bg_color, bold = true },
    StNumber = { foreground = number_fg, background = bg_color },
    StCount = { foreground = 'bg', background = indicator_color, bold = true },
    StPrefix = { background = pmenu_bg, foreground = normal_fg },
    StDirectory = { background = bg_color, foreground = 'Gray', italic = true },
    StDirectoryInactive = { background = bg_color, foreground = dim_color, italic = true },
    StParentDirectory = { background = bg_color, foreground = string_fg, bold = true },
    StTitle = { background = bg_color, foreground = 'LightGray', bold = true },
    StComment = { background = bg_color, inherit = 'Comment' },
    StatusLine = { background = bg_color },
    StatusLineNC = { link = 'VertSplit' },
    StInfo = { foreground = info_color, background = bg_color, bold = true },
    StWarning = { foreground = warning_fg, background = bg_color },
    StError = { foreground = error_color, background = bg_color },
    StFilename = { background = bg_color, foreground = 'LightGray', bold = true },
    StFilenameInactive = {
      foreground = P.comment_grey,
      background = bg_color,
      bold = true,
      italic = true,
    },
    StModeNormal = { background = bg_color, foreground = P.whitesmoke, bold = true },
    StModeInsert = { background = bg_color, foreground = P.dark_blue, bold = true },
    StModeVisual = { background = bg_color, foreground = P.magenta, bold = true },
    StModeReplace = { background = bg_color, foreground = P.dark_red, bold = true },
    StModeCommand = { background = bg_color, foreground = P.bright_yellow, bold = true },
    StModeSelect = { background = bg_color, foreground = P.teal, bold = true },
  })
end

local separator = { component = C.ALIGN, length = 0, priority = 0 }
local end_marker = { component = C.END, length = 0, priority = 0 }

local component = utils.component
local component_if = utils.component_if

---A very over-engineered statusline, heavily inspired by doom-modeline
---@return string
function _G.__statusline()
  -- use the statusline global variable which is set inside of statusline
  -- functions to the window for *that* statusline
  local curwin = vim.g.statusline_winid or 0
  local curbuf = api.nvim_win_get_buf(curwin)

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
  local plain = utils.is_plain(ctx)
  local file_modified = utils.modified(ctx, icons.misc.circle)
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
    utils.spacer(1),
  }
  local add = utils.winline(statusline)
  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  local segments = utils.file(ctx, plain)
  local dir, parent, file = segments.dir, segments.parent, segments.file
  local dir_component = utils.component(dir.item, dir.hl, dir.opts)
  local parent_component = utils.component(parent.item, parent.hl, parent.opts)
  local file_component = utils.component(file.item, file.hl, file.opts)

  local readonly_hl = H.adopt_winhighlight(curwin, 'StatusLine', 'StCustomError', 'StError')
  local readonly_component = utils.component(utils.readonly(ctx), readonly_hl, { priority = 1 })
  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  ----------------------------------------------------------------------------//
  if plain or not focused then
    add(readonly_component, dir_component, parent_component, file_component)
    return utils.display(statusline, available_space)
  end
  -----------------------------------------------------------------------------//
  -- Variables
  -----------------------------------------------------------------------------//

  local mode, mode_hl = utils.mode()
  local status = vim.b.gitsigns_status_dict or {}
  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0

  -- Github notifications
  local ghn_ok, ghn = pcall(require, 'github-notifications')
  local notifications = ghn_ok and ghn.statusline_notification_count() or ''

  -- LSP Diagnostics
  local diagnostics = utils.diagnostic_info(ctx)
  local flutter = vim.g.flutter_tools_decorations or {}
  -----------------------------------------------------------------------------//
  -- Left section
  -----------------------------------------------------------------------------//
  add(
    component_if(file_modified, ctx.modified, 'StModified', { priority = 1 }),

    readonly_component,

    component(mode, mode_hl, { priority = 0 }),

    component_if(utils.search_count(), vim.v.hlsearch > 0, 'StCount', { priority = 1 }),

    dir_component,
    parent_component,
    file_component,

    component_if('Saving…', vim.g.is_saving, 'StComment', { before = ' ', priority = 1 }),

    -- Local plugin dev indicator
    component_if(available_space > 100 and 'local dev' or '', vim.env.DEVELOPING ~= nil, 'StComment', {
      prefix = icons.misc.tools,
      padding = 'none',
      before = '  ',
      prefix_color = 'StWarning',
      small = 1,
      priority = 2,
    }),
    separator,
    -----------------------------------------------------------------------------//
    -- Middle section
    -----------------------------------------------------------------------------//
    -- Neovim allows unlimited alignment sections so we can put things in the
    -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
    -----------------------------------------------------------------------------//
    -- Start of the right side layout
    separator,
    -----------------------------------------------------------------------------//
    -- Right section
    -----------------------------------------------------------------------------//
    component(flutter.app_version, 'StMetadata', { priority = 4 }),

    component(flutter.device and flutter.device.name or '', 'StMetadata', { priority = 4 }),

    component(utils.lsp_client(ctx), 'StMetadata', { priority = 4 }),

    component(utils.debugger(), 'StMetadata', { prefix = icons.misc.bug, priority = 4 }),

    component_if(diagnostics.error.count, diagnostics.error, 'StError', {
      prefix = diagnostics.error.sign,
      priority = 1,
    }),

    component_if(diagnostics.warning.count, diagnostics.warning, 'StWarning', {
      prefix = diagnostics.warning.sign,
      priority = 3,
    }),

    component_if(diagnostics.info.count, diagnostics.info, 'StInfo', {
      prefix = diagnostics.info.sign,
      priority = 4,
    }),

    component(notifications, 'StTitle', { priority = 3 }),

    -- Git Status
    component(status.head, 'StBlue', {
      prefix = icons.git.logo,
      prefix_color = 'StGit',
      priority = 1,
    }),

    component(status.changed, 'StTitle', {
      prefix = icons.git.mod,
      prefix_color = 'StWarning',
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
    component(api.nvim_win_get_cursor(0)[1], 'StTitle', {
      after = '',
      prefix = icons.misc.line,
      prefix_color = 'StMetadataPrefix',
      priority = 7,
    }),
    component(api.nvim_buf_line_count(ctx.bufnum), 'StComment', {
      before = '',
      prefix = '/',
      padding = { prefix = false, suffix = true },
      prefix_color = 'StComment',
      priority = 7,
    }),

    -- column
    component('%-3c', 'StTitle', {
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
    { end_marker }
  )
  -- removes 5 columns to add some padding
  return utils.display(statusline, available_space - 5)
end

local function setup_autocommands()
  as.augroup('CustomStatusline', {
    { event = { 'FocusGained' }, pattern = { '*' }, command = 'let g:vim_in_focus = v:true' },
    { event = { 'FocusLost' }, pattern = { '*' }, command = 'let g:vim_in_focus = v:false' },
    {
      event = { 'VimEnter', 'ColorScheme' },
      pattern = { '*' },
      command = function()
        colors()
      end,
    },
    {
      event = { 'BufReadPre' },
      once = true,
      pattern = { '*' },
      command = function()
        utils.git_updates()
      end,
    },
    {
      event = { 'BufWritePre' },
      pattern = { '*' },
      command = function()
        if not vim.g.is_saving and vim.bo.modified then
          vim.g.is_saving = true
          vim.defer_fn(function()
            vim.g.is_saving = false
          end, 1000)
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
      command = function()
        utils.git_updates_refresh()
      end,
    },
  })
end

-- attach autocommands
setup_autocommands()

-- :h qf.vim, disable qf statusline
vim.g.qf_disable_statusline = 1

-- set the statusline
vim.o.statusline = '%!v:lua.__statusline()'

return M
