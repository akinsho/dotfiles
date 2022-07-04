return function()
  local alpha = require('alpha')
  local dashboard = require('alpha.themes.dashboard')
  local fortune = require('alpha.fortune')
  local hl = require('as.highlights')

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
  local function colorize_header()
    local lines = {}
    for i, chars in pairs(header) do
      local line = {
        type = 'text',
        val = chars,
        opts = {
          hl = 'StartLogo' .. i,
          shrink_margin = false,
          position = 'center',
        },
      }
      table.insert(lines, line)
    end
    return lines
  end

  local installed_plugins = {
    type = 'text',
    val = '  ' .. #as.list_installed_plugins() .. ' plugins in total',
    opts = { position = 'center', hl = 'String' },
  }

  dashboard.section.buttons.val = {
    dashboard.button('e', '  New file', ':ene | startinsert <CR>'),
    dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
    dashboard.button('g', '  Find word', ':Telescope live_grep<CR>'),
    dashboard.button('Q', '  Quit NVIM', ':qa<CR>'),
  }

  dashboard.section.footer.val = fortune()

  alpha.setup({
    layout = {
      { type = 'padding', val = 4 },
      { type = 'group', val = colorize_header() },
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      installed_plugins,
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
