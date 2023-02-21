local api, opt, f = vim.api, vim.opt_local, string.format
local highlight = as.highlight

return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')
    local fortune = require('alpha.fortune')

    local button = function(h, ...)
      local btn = dashboard.button(...)
      local details = select(2, ...)
      local icon = details:match('[^%w%s]+') -- match non alphanumeric or space characters
      btn.opts.hl = { { h, 0, #icon + 1 } } -- add one space padding
      btn.opts.hl_shortcut = 'Title'
      return btn
    end

    highlight.plugin('alpha', {
      { StartLogo1 = { fg = '#1C506B' } },
      { StartLogo2 = { fg = '#1D5D68' } },
      { StartLogo3 = { fg = '#1E6965' } },
      { StartLogo4 = { fg = '#1F7562' } },
      { StartLogo5 = { fg = '#21825F' } },
      { StartLogo6 = { fg = '#228E5C' } },
      { StartLogo7 = { fg = '#239B59' } },
      { StartLogo8 = { fg = '#24A755' } },
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

    local function neovim_header()
      return as.map(
        function(chars, i)
          return {
            type = 'text',
            val = chars,
            opts = { hl = 'StartLogo' .. i, shrink_margin = false, position = 'center' },
          }
        end,
        header
      )
    end

    local installed_plugins = {
      type = 'text',
      val = f(' %d plugins installed', as.installed_plugins()),
      opts = { position = 'center', hl = 'NonText' },
    }

    local v = vim.version() or {}
    local version = {
      type = 'text',
      val = f(' v%d.%d.%d %s', v.major, v.minor, v.patch, v.prerelease and '(nightly)' or ''),
      opts = { position = 'center', hl = 'NonText' },
    }

    local separator = {
      type = 'text',
      val = string.rep('─', vim.o.columns - 2),
      opts = { position = 'center', hl = 'NonText' },
    }

    dashboard.section.buttons.val = {
      button('Directory', 'r', ' Restore last session', '<Cmd>SessionLoad<CR>'),
      button('Type', 'p', ' Pick a session', '<Cmd>ListSessions<CR>'),
      button('Title', 'f', '  Find file', ':Telescope find_files<CR>'),
      button('String', 'e', '  New file', ':ene | startinsert <CR>'),
      button('ErrorMsg', 'q', '  Quit NVIM', ':qa<CR>'),
    }

    dashboard.section.footer.val = fortune()
    dashboard.section.footer.opts.hl = 'TSEmphasis'

    alpha.setup({
      layout = {
        { type = 'padding', val = 4 },
        { type = 'group', val = neovim_header() },
        { type = 'padding', val = 1 },
        installed_plugins,
        version,
        { type = 'padding', val = 1 },
        separator,
        { type = 'padding', val = 1 },
        dashboard.section.buttons,
        separator,
        dashboard.section.footer,
      },
      opts = { margin = 5 },
    })

    as.augroup('AlphaSettings', {
      {
        event = 'User ',
        pattern = 'AlphaReady',
        command = function(args)
          opt.foldenable = false
          opt.laststatus, opt.showtabline = 0, 0
          map('n', 'q', '<Cmd>Alpha<CR>', { buffer = args.buf, nowait = true })

          api.nvim_create_autocmd('BufUnload', {
            buffer = args.buf,
            callback = function()
              opt.laststatus, opt.showtabline = 3, 2
              vim.cmd('SessionStart')
            end,
          })
        end,
      },
    })
  end,
}
