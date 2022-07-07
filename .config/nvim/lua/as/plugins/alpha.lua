return function()
  local alpha = require('alpha')
  local dashboard = require('alpha.themes.dashboard')
  local fortune = require('alpha.fortune')
  local hl = require('as.highlights')

  local f = string.format
  local fn = vim.fn
  local luv = vim.loop
  local DOTFILES = vim.env.DOTFILES

  local button = function(h, ...)
    local btn = dashboard.button(...)
    local details = select(2, ...)
    local icon = details:match('[^%w%s]+') -- match non alphanumeric or space characters
    btn.opts.hl = { { h, 0, #icon + 1 } } -- add one space padding
    btn.opts.hl_shortcut = 'Title'
    return btn
  end

  hl.plugin('alpha', {
    StartLogo1 = { fg = '#1C506B' },
    StartLogo2 = { fg = '#1D5D68' },
    StartLogo3 = { fg = '#1E6965' },
    StartLogo4 = { fg = '#1F7562' },
    StartLogo5 = { fg = '#21825F' },
    StartLogo6 = { fg = '#228E5C' },
    StartLogo7 = { fg = '#239B59' },
    StartLogo8 = { fg = '#24A755' },
  })

  local header = {
    [[                                                                   ]],
    [[      ████ ██████           █████      ██                    ]],
    [[     ███████████             █████                            ]],
    [[     █████████ ███████████████████ ███   ███████████  ]],
    [[    █████████  ███    █████████████ █████ ██████████████  ]],
    [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
    [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
    [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
  }

  -- Make the header a bit more fun with some color!
  local function neovim_header()
    return as.map(
      function(chars, i)
        return {
          type = 'text',
          val = chars,
          opts = {
            hl = 'StartLogo' .. i,
            shrink_margin = false,
            position = 'center',
          },
        }
      end,
      header
    )
  end

  local installed_plugins = {
    type = 'text',
    val = f(' %d plugins installed', #as.list_installed_plugins()),
    opts = { position = 'center', hl = 'NonText' },
  }

  ---@param dir string
  ---@param files table<string, string>
  local function sort_sessions_by_mtime(dir, files)
    table.sort(files, function(a, b)
      if not a.path then return true end
      if not b.path then return false end

      local a_file, b_file = f('%s/%s', dir, a.path), f('%s/%s', dir, b.path)
      local a_stat, b_stat = luv.fs_stat(a_file), luv.fs_stat(b_file)

      if not a_stat then return true end
      if not b_stat then return false end

      local a_time, b_time = luv.fs_stat(a_file).mtime.sec, luv.fs_stat(b_file).mtime.sec
      return a_time > b_time
    end)
  end

  local function sessions()
    local session = require('auto-session')
    local files = session.get_session_files()
    if not files or vim.tbl_isempty(files) then return end
    files = vim.list_slice(files, 1, 10)

    sort_sessions_by_mtime(session.get_root_dir():sub(1, -2), files)

    local elements = as.map(function(item, key)
      local name = item.display_name or item.path
      if name:match("__") then
        local parts = vim.split(name, "__")
        name = parts[#parts]
      else
        name =  fn.fnamemodify(item.display_name, ':t')
      end
      return {
        type = 'button',
        val = as.truncate(name, 40),
        on_press = function() session.RestoreSessionFromFile(item.display_name or item.path) end,
        opts = {
          hl = 'Directory',
          position = 'center',
          align_shortcut = 'right',
          shortcut = key,
          hl_shortcut = 'Title',
          width = 50,
        },
      }
    end, files)
    return { type = 'group', val = elements }
  end

  dashboard.section.buttons.val = {
    button('Directory', 'r', ' Restore last session', '<Cmd>RestoreSession<CR>'),
    button('Todo', 'p', ' Pick a session', '<Cmd>Autosession search<CR>'),
    button('Label', 'd', ' Open dotfiles', f('<Cmd>RestoreSessionFromFile %s<CR>', DOTFILES)),
    button('Title', 'f', '  Find file', ':Telescope find_files<CR>'),
    button('String', 'e', '  New file', ':ene | startinsert <CR>'),
    button('ErrorMsg', 'q', '  Quit NVIM', ':qa<CR>'),
  }

  dashboard.section.footer.val = fortune()
  dashboard.section.footer.opts.hl = 'Type'

  alpha.setup({
    layout = {
      { type = 'padding', val = 4 },
      { type = 'group', val = neovim_header() },
      { type = 'padding', val = 1 },
      installed_plugins,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'text', val = 'Sessions', opts = { position = 'center', hl = 'NonText' } },
      sessions(),
      dashboard.section.footer,
    },
    opts = { margin = 5 },
  })

  as.augroup('AlphaSettings', {
    {
      event = 'User ',
      pattern = 'AlphaReady',
      command = function(args)
        vim.opt_local.foldenable = false
        vim.opt_local.colorcolumn = ''
        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
        as.nnoremap('q', '<Cmd>Alpha<CR>', { buffer = args.buf, nowait = true })

        vim.api.nvim_create_autocmd('BufUnload', {
          buffer = args.buf,
          callback = function()
            vim.opt.laststatus = 3
            vim.opt.showtabline = 2
          end,
        })
      end,
    },
  })
end
