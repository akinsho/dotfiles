local fn = vim.fn
local api = vim.api
local fmt = string.format
local contains = vim.tbl_contains

vim.api.nvim_exec(
  [[
   augroup vimrc -- Ensure all autocommands are cleared
   autocmd!
   augroup END
  ]],
  ''
)

as.augroup('VimrcIncSearchHighlight', {
  {
    -- automatically clear search highlight once leaving the commandline
    events = { 'CmdlineEnter' },
    targets = { '[/\\?]' },
    command = ':set hlsearch  | redrawstatus',
  },
  {
    events = { 'CmdlineLeave' },
    targets = { '[/\\?]' },
    command = ':set nohlsearch | redrawstatus',
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
}

local function smart_close()
  if fn.winnr '$' ~= 1 then
    api.nvim_win_close(0, true)
  end
end

as.augroup('SmartClose', {
  {
    -- Auto open grep quickfix window
    events = { 'QuickFixCmdPost' },
    targets = { '*grep*' },
    command = 'cwindow',
  },
  {
    -- Close certain filetypes by pressing q.
    events = { 'FileType' },
    targets = { '*' },
    command = function()
      local is_readonly = (vim.bo.readonly or not vim.bo.modifiable) and fn.hasmapto('q', 'n') == 0

      local is_eligible = vim.bo.buftype ~= ''
        or is_readonly
        or vim.wo.previewwindow
        or contains(smart_close_filetypes, vim.bo.filetype)

      if is_eligible then
        as.nnoremap('q', smart_close, { buffer = 0, nowait = true })
      end
    end,
  },
  {
    -- Close quick fix window if the file containing it was closed
    events = { 'BufEnter' },
    targets = { '*' },
    command = function()
      if fn.winnr '$' == 1 and vim.bo.buftype == 'quickfix' then
        api.nvim_buf_delete(0, { force = true })
      end
    end,
  },
  {
    -- automatically close corresponding loclist when quitting a window
    events = { 'QuitPre' },
    targets = { '*' },
    modifiers = { 'nested' },
    command = function()
      if vim.bo.filetype ~= 'qf' then
        vim.cmd 'silent! lclose'
      end
    end,
  },
})

as.augroup('ExternalCommands', {
  {
    -- Open images in an image viewer (probably Preview)
    events = { 'BufEnter' },
    targets = { '*.png,*.jpg,*.gif' },
    command = function()
      vim.cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. ' ' .. fn.expand '%'))
    end,
  },
})

as.augroup('CheckOutsideTime', {
  {
    -- automatically check for changed files outside vim
    events = { 'WinEnter', 'BufWinEnter', 'BufWinLeave', 'BufRead', 'BufEnter', 'FocusGained' },
    targets = { '*' },
    command = 'silent! checktime',
  },
})

-- See :h skeleton
as.augroup('Templates', {
  {
    events = { 'BufNewFile' },
    targets = { '*.sh' },
    command = '0r $DOTFILES/.config/nvim/templates/skeleton.sh',
  },
  {
    events = { 'BufNewFile' },
    targets = { '*.lua' },
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
        vim.cmd [[echon '']]
      end
    end, 10000)
  end
end

as.augroup('ClearCommandMessages', {
  {
    events = { 'CmdlineLeave', 'CmdlineChanged' },
    targets = { ':' },
    command = clear_commandline(),
  },
})

if vim.env.TMUX ~= nil then
  as.augroup('External', {
    {
      events = { 'BufEnter' },
      targets = { '*' },
      command = function()
        vim.o.titlestring = require('as.external').title_string()
      end,
    },
    {
      events = { 'VimLeavePre' },
      targets = { '*' },
      command = function()
        require('as.external').tmux.set_statusline(true)
      end,
    },
    {
      events = { 'ColorScheme', 'FocusGained' },
      targets = { '*' },
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
    events = { 'TextYankPost' },
    targets = { '*' },
    command = function()
      vim.highlight.on_yank {
        timeout = 500,
        on_visual = false,
        higroup = 'Visual',
      }
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
    events = { 'WinEnter', 'BufEnter', 'VimResized', 'FileType' },
    targets = { '*' },
    command = function()
      check_color_column()
    end,
  },
  {
    events = { 'WinLeave' },
    targets = { '*' },
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
    events = 'BufWritePost',
    targets = { '$DOTFILES/**/nvim/plugin/*.{lua,vim}', '$MYVIMRC' },
    modifiers = { '++nested' },
    command = function()
      local ok, msg = pcall(vim.cmd, 'source $MYVIMRC | redraw | silent doautocmd ColorScheme')
      msg = ok and 'sourced ' .. vim.fn.fnamemodify(vim.env.MYVIMRC, ':t') or msg
      vim.notify(msg)
    end,
  },
  {
    events = { 'FocusLost' },
    targets = { '*' },
    command = 'silent! wall',
  },
  -- Make windows equal size when vim resizes
  {
    events = { 'VimResized' },
    targets = { '*' },
    command = 'wincmd =',
  },
})

as.augroup('WindowBehaviours', {
  {
    -- map q to close command window on quit
    events = { 'CmdwinEnter' },
    targets = { '*' },
    command = 'nnoremap <silent><buffer><nowait> q <C-W>c',
  },
  -- Automatically jump into the quickfix window on open
  {
    events = { 'QuickFixCmdPost' },
    targets = { '[^l]*' },
    modifiers = { 'nested' },
    command = 'cwindow',
  },
  {
    events = { 'QuickFixCmdPost' },
    targets = { 'l*' },
    modifiers = { 'nested' },
    command = 'lwindow',
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
    events = { 'BufEnter' },
    targets = { '*' },
    command = function()
      if should_show_cursorline() then
        vim.wo.cursorline = true
      end
    end,
  },
  {
    events = { 'BufLeave' },
    targets = { '*' },
    command = function()
      vim.wo.cursorline = false
    end,
  },
})

local save_excluded = { 'lua.luapad', 'gitcommit', 'NeogitCommitMessage' }
local function can_save()
  return as.empty(vim.bo.buftype)
    and not as.empty(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

as.augroup('Utilities', {
  {
    -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
    events = { 'BufReadCmd' },
    targets = { 'file:///*' },
    command = function()
      vim.cmd(fmt('bd!|edit %s', vim.uri_from_fname '<afile>'))
    end,
  },
  -- BUG: this causes the cursor to jump to the top on VimEnter
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid, or when
    -- inside an event handler (happens when dropping a file on gvim).
    events = { 'BufWinEnter' },
    targets = { '*' },
    command = function()
      local pos = fn.line [['"]]
      if
        vim.bo.ft ~= 'gitcommit'
        and vim.fn.win_gettype() ~= 'popup'
        and pos > 0
        and pos <= fn.line '$'
      then
        vim.cmd 'keepjumps normal g`"'
      end
    end,
  },
  {
    events = { 'FileType' },
    targets = { 'gitcommit', 'gitrebase' },
    command = 'set bufhidden=delete',
  },
  {
    events = { 'BufWritePre', 'FileWritePre' },
    targets = { '*' },
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
  },
  {
    events = { 'BufLeave' },
    targets = { '*' },
    command = function()
      if can_save() then
        vim.cmd 'silent! update'
      end
    end,
  },
  {
    events = { 'BufWritePost' },
    targets = { '*' },
    modifiers = { 'nested' },
    command = function()
      if as.empty(vim.bo.filetype) or fn.exists 'b:ftdetect' == 1 then
        vim.cmd [[
            unlet! b:ftdetect
            filetype detect
            echom 'Filetype set to ' . &ft
          ]]
      end
    end,
  },
  {
    events = { 'Syntax' },
    targets = { '*' },
    command = "if 5000 < line('$') | syntax sync minlines=200 | endif",
  },
})

as.augroup('TerminalAutocommands', {
  {
    events = { 'TermClose' },
    targets = { '*' },
    command = function()
      --- automatically close a terminal if the job was successful
      if not vim.v.event.status == 0 then
        vim.cmd('bdelete! ' .. fn.expand '<abuf>')
      end
    end,
  },
})
