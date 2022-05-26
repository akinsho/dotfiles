local fn = vim.fn
local api = vim.api
local fmt = string.format
local contains = vim.tbl_contains
local map = vim.keymap.set

----------------------------------------------------------------------------------------------------
-- HLSEARCH
----------------------------------------------------------------------------------------------------
--[[
In order to get hlsearch working the way I like i.e. on when using /,?,N,n,*,#, etc. and off when
When I'm not using them, I need to set the following:
The mappings below are essentially faked user input this is because in order to automatically turn off
the search highlight just changing the value of 'hlsearch' inside a function does not work
read `:h nohlsearch`. So to have this work I check that the current mouse position is not a search
result, if it is we leave highlighting on, otherwise I turn it off on cursor moved by faking my input
using the expr mappings below.

This is based on the implementation discussed here:
https://github.com/neovim/neovim/issues/5581
--]]

map({ 'n', 'v', 'o', 'i', 'c' }, '<Plug>(StopHL)', 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
  if vim.v.hlsearch == 0 or api.nvim_get_mode().mode ~= 'n' then
    return
  end
  api.nvim_feedkeys(as.replace_termcodes('<Plug>(StopHL)'), 'm', false)
end

local function hl_search()
  local col = api.nvim_win_get_cursor(0)[2]
  local curr_line = api.nvim_get_current_line()
  local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg('/'), 0)
  if not ok then
    return vim.notify(match, 'error', { title = 'HL SEARCH' })
  end
  local _, p_start, p_end = unpack(match)
  -- if the cursor is in a search result, leave highlighting on
  if col < p_start or col > p_end then
    stop_hl()
  end
end

as.augroup('VimrcIncSearchHighlight', {
  {
    event = { 'CursorMoved' },
    command = function()
      hl_search()
    end,
  },
  {
    event = { 'InsertEnter' },
    command = function()
      stop_hl()
    end,
  },
  {
    event = { 'OptionSet' },
    pattern = { 'hlsearch' },
    command = function()
      vim.schedule(function()
        vim.cmd('redrawstatus')
      end)
    end,
  },
})

local smart_close_filetypes = {
  'help',
  'git-status',
  'git-log',
  'gitcommit',
  'dbui',
  'fugitive',
  'fugitiveblame',
  'LuaTree',
  'log',
  'tsplayground',
  'qf',
  'startuptime',
  'lspinfo',
}

local smart_close_buftypes = {} -- Don't include no file buffers as diff buffers are nofile

local function smart_close()
  if fn.winnr('$') ~= 1 then
    api.nvim_win_close(0, true)
  end
end

as.augroup('SmartClose', {
  {
    -- Auto open grep quickfix window
    event = { 'QuickFixCmdPost' },
    pattern = { '*grep*' },
    command = 'cwindow',
  },
  {
    -- Close certain filetypes by pressing q.
    event = { 'FileType' },
    pattern = '*',
    command = function()
      local is_unmapped = fn.hasmapto('q', 'n') == 0

      local is_eligible = is_unmapped
        or vim.wo.previewwindow
        or contains(smart_close_buftypes, vim.bo.buftype)
        or contains(smart_close_filetypes, vim.bo.filetype)

      if is_eligible then
        as.nnoremap('q', smart_close, { buffer = 0, nowait = true })
      end
    end,
  },
  {
    -- Close quick fix window if the file containing it was closed
    event = { 'BufEnter' },
    pattern = '*',
    command = function()
      if fn.winnr('$') == 1 and vim.bo.buftype == 'quickfix' then
        api.nvim_buf_delete(0, { force = true })
      end
    end,
  },
  {
    -- automatically close corresponding loclist when quitting a window
    event = { 'QuitPre' },
    pattern = '*',
    nested = true,
    command = function()
      if vim.bo.filetype ~= 'qf' then
        vim.cmd('silent! lclose')
      end
    end,
  },
})

as.augroup('ExternalCommands', {
  {
    -- Open images in an image viewer (probably Preview)
    event = { 'BufEnter' },
    pattern = { '*.png', '*.jpg', '*.gif' },
    command = function()
      vim.cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. ' ' .. fn.expand('%')))
    end,
  },
})

as.augroup('CheckOutsideTime', {
  {
    -- automatically check for changed files outside vim
    event = { 'WinEnter', 'BufWinEnter', 'BufWinLeave', 'BufRead', 'BufEnter', 'FocusGained' },
    pattern = '*',
    command = 'silent! checktime',
  },
})

-- See :h skeleton
as.augroup('Templates', {
  {
    event = { 'BufNewFile' },
    pattern = { '*.sh' },
    command = '0r $DOTFILES/.config/nvim/templates/skeleton.sh',
  },
  {
    event = { 'BufNewFile' },
    pattern = { '*.lua' },
    command = '0r $DOTFILES/.config/nvim/templates/skeleton.lua',
  },
})

--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
  --- Track the timer object and stop any previous timers before setting
  --- a new one so that each change waits for 10secs and that 10secs is
  --- deferred each time
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if fn.mode() == 'n' then
        vim.cmd([[echon '']])
      end
    end, 10000)
  end
end

as.augroup('ClearCommandMessages', {
  {
    event = { 'CmdlineLeave', 'CmdlineChanged' },
    pattern = { ':' },
    command = clear_commandline(),
  },
})

if vim.env.TMUX ~= nil then
  as.augroup('External', {
    {
      event = { 'BufEnter' },
      pattern = '*',
      command = function()
        vim.o.titlestring = require('as.external').title_string()
      end,
    },
    {
      event = { 'VimLeavePre' },
      pattern = '*',
      command = function()
        require('as.external').tmux.set_statusline(true)
      end,
    },
    {
      event = { 'ColorScheme', 'FocusGained' },
      pattern = '*',
      command = function()
        -- NOTE: there is a race condition here as the colors
        -- for kitty to re-use need to be set AFTER the rest of the colorscheme
        -- overrides
        vim.defer_fn(function()
          require('as.external').tmux.set_statusline()
        end, 1)
      end,
    },
  })
end

as.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = { 'TextYankPost' },
    pattern = '*',
    command = function()
      vim.highlight.on_yank({
        timeout = 500,
        on_visual = false,
        higroup = 'Visual',
      })
    end,
  },
})

local column_exclude = { 'gitcommit' }
local column_clear = {
  'startify',
  'vimwiki',
  'vim-plug',
  'help',
  'fugitive',
  'mail',
  'org',
  'orgagenda',
  'NeogitStatus',
  'norg',
}

--- Set or unset the color column depending on the filetype of the buffer and its eligibility
---@param leaving boolean indicates if the function was called on window leave
local function check_color_column(leaving)
  if contains(column_exclude, vim.bo.filetype) then
    return
  end

  local not_eligible = not vim.bo.modifiable
    or vim.wo.previewwindow
    or vim.bo.buftype ~= ''
    or not vim.bo.buflisted

  local small_window = api.nvim_win_get_width(0) <= vim.bo.textwidth + 1
  local is_last_win = #api.nvim_list_wins() == 1

  if
    contains(column_clear, vim.bo.filetype)
    or not_eligible
    or (leaving and not is_last_win)
    or small_window
  then
    vim.wo.colorcolumn = ''
    return
  end
  if vim.wo.colorcolumn == '' then
    vim.wo.colorcolumn = '+1'
  end
end

as.augroup('CustomColorColumn', {
  {
    -- Update the cursor column to match current window size
    event = { 'WinEnter', 'BufEnter', 'VimResized', 'FileType' },
    pattern = '*',
    command = function()
      check_color_column()
    end,
  },
  {
    event = { 'WinLeave' },
    pattern = { '*' },
    command = function()
      check_color_column(true)
    end,
  },
})
as.augroup('UpdateVim', {
  {
    -- TODO: not clear what effect this has in the post vimscript world
    -- it correctly sources $MYVIMRC but all the other files that it
    -- requires will need to be resourced or reloaded themselves
    event = 'BufWritePost',
    pattern = { '$DOTFILES/**/nvim/plugin/*.{lua,vim}', fn.expand('$MYVIMRC') },
    nested = true,
    command = function(args)
      local path = api.nvim_buf_get_name(args.buf)
      vim.cmd('source ' .. path)
      local ok, msg = pcall(vim.cmd, 'source $MYVIMRC | redraw | silent doautocmd ColorScheme')
      msg = ok and fmt('sourced %s and %s', path, fn.fnamemodify(vim.env.MYVIMRC, ':t')) or msg
      vim.notify(msg)
    end,
  },
  {
    event = { 'FocusLost' },
    pattern = { '*' },
    command = 'silent! wall',
  },
  -- Make windows equal size when vim resizes
  {
    event = { 'VimResized' },
    pattern = { '*' },
    command = 'wincmd =',
  },
})

as.augroup('WindowBehaviours', {
  {
    -- map q to close command window on quit
    event = { 'CmdwinEnter' },
    pattern = { '*' },
    command = 'nnoremap <silent><buffer><nowait> q <C-W>c',
  },
  -- Automatically jump into the quickfix window on open
  {
    event = { 'QuickFixCmdPost' },
    pattern = { '[^l]*' },
    nested = true,
    command = 'cwindow',
  },
  {
    event = { 'QuickFixCmdPost' },
    pattern = { 'l*' },
    nested = true,
    command = 'lwindow',
  },
  {
    event = { 'WinEnter' },
    command = function(args)
      if vim.wo.diff then
        vim.diagnostic.disable(args.buf)
      end
    end,
  },
  {
    event = { 'WinLeave' },
    command = function(args)
      if vim.wo.diff then
        vim.diagnostic.enable(args.buf)
      end
    end,
  },
})

local function should_show_cursorline()
  return vim.bo.buftype ~= 'terminal'
    and not vim.wo.previewwindow
    and vim.wo.winhighlight == ''
    and vim.bo.filetype ~= ''
end

as.augroup('Cursorline', {
  {
    event = { 'BufEnter' },
    pattern = { '*' },
    command = function()
      vim.wo.cursorline = should_show_cursorline()
    end,
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      vim.wo.cursorline = false
    end,
  },
})

local save_excluded = {
  'neo-tree',
  'neo-tree-popup',
  'lua.luapad',
  'gitcommit',
  'NeogitCommitMessage',
}
local function can_save()
  return as.empty(fn.win_gettype())
    and as.empty(vim.bo.buftype)
    and not as.empty(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

as.augroup('Utilities', {
  {
    -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
    event = { 'BufReadCmd' },
    pattern = { 'file:///*' },
    nested = true,
    command = function(args)
      vim.cmd(fmt('bd!|edit %s', vim.uri_to_fname(args.file)))
    end,
  },
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid.
    event = { 'BufReadPost' },
    command = function()
      if vim.bo.ft ~= 'gitcommit' and vim.fn.win_gettype() ~= 'popup' then
        local last_place_mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_nr = last_place_mark[1]
        local last_line = vim.api.nvim_buf_line_count(0)

        if line_nr > 0 and line_nr <= last_line then
          vim.api.nvim_win_set_cursor(0, last_place_mark)
        end
      end
    end,
  },
  {
    event = { 'FileType' },
    pattern = { 'gitcommit', 'gitrebase' },
    command = 'set bufhidden=delete',
  },
  { -- TODO: should this be done in ftplugin files
    event = { 'FileType' },
    pattern = { 'lua', 'vim', 'dart', 'python', 'javascript', 'typescript', 'rust' },
    command = 'setlocal spell',
  },
  {
    event = { 'BufWritePre', 'FileWritePre' },
    pattern = { '*' },
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      if can_save() then
        vim.cmd('silent! update')
      end
    end,
  },
  {
    event = { 'BufWritePost' },
    pattern = { '*' },
    nested = true,
    command = function()
      if as.empty(vim.bo.filetype) or fn.exists('b:ftdetect') == 1 then
        vim.cmd([[
            unlet! b:ftdetect
            filetype detect
            echom 'Filetype set to ' . &ft
          ]])
      end
    end,
  },
})

as.augroup('TerminalAutocommands', {
  {
    event = { 'TermClose' },
    pattern = '*',
    command = function()
      --- automatically close a terminal if the job was successful
      if not vim.v.event.status == 0 then
        vim.cmd('bdelete! ' .. fn.expand('<abuf>'))
      end
    end,
  },
})
