local api, opt, fs, f, rep = vim.api, vim.opt_local, vim.fs, string.format, string.rep
local icons, highlight = as.ui.icons, as.highlight
local strwidth = api.nvim_strwidth

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

    ------------------------------------------------------------------------------------------------
    --  Components
    ------------------------------------------------------------------------------------------------

    local separator = {
      type = 'text',
      val = string.rep('─', vim.o.columns - 2),
      opts = { position = 'center', hl = 'NonText' },
    }

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

    local SESSION_WIDTH = 50

    ---Each session file that can be loaded
    ---@param item {dir_path: string, name: string, file_path: string, branch: string}
    ---@param index integer
    ---@return table
    local function session_button(item, index)
      local icon = icons.misc.note
      local tail = fs.basename(item.name)
      local proj, branch = unpack(vim.split(tail, '@@'))
      local name =
        f('  %s %s %s', icon, proj, branch and f('(%s %s)', icons.git.branch, branch) or '')
      local indent = rep(' ', SESSION_WIDTH - strwidth(name))
      return {
        type = 'button',
        val = name .. indent,
        on_press = function() vim.cmd(f('SessionLoadFromFile %s', item.file_path)) end,
        keymap = { 'n', tostring(index), f('<Cmd>SessionLoadFromFile %s<CR>', item.file_path) },
        opts = {
          width = SESSION_WIDTH,
          position = 'center',
          -- shortcut = f('[%d]', index),
          -- align_shortcut = 'right',
          -- hl_shortcut = 'Title',
          -- hl = '@text',
        },
      }
    end

    local function get_sessions(count)
      local ok, persisted = pcall(require, 'persisted')
      if not ok or not persisted then return {} end
      local items = as.fold(function(accum, item, index)
        if not accum[item.dir_path] then
          local name = icons.git.repo .. ' ' .. item.dir_path
          local indent = rep(' ', SESSION_WIDTH - strwidth(name))
          accum[item.dir_path] = {
            type = 'group',
            val = {
              {
                type = 'text',
                val = name .. indent,
                opts = { width = SESSION_WIDTH, position = 'center', hl = 'Directory' },
              },
            },
          }
        end
        table.insert(accum[item.dir_path].val, session_button(item, index))
        return accum
      end, vim.list_slice(persisted.list(), 1, count))
      return { type = 'group', val = items }
    end

    local sessions = function(count)
      return {
        type = 'group',
        val = {
          {
            type = 'text',
            val = 'Sessions',
            opts = {
              hl = 'SpecialComment',
              position = 'center',
              width = SESSION_WIDTH,
            },
          },
          { type = 'group', val = function() return { get_sessions(count) } end },
          { type = 'padding', val = 1 },
        },
      }
    end

    dashboard.section.buttons.val = {
      button('Type', 'p', ' Pick a session', '<Cmd>ListSessions<CR>'),
      button('Title', 'f', '  Find file', ':Telescope find_files<CR>'),
      button('ErrorMsg', 'q', '  Quit NVIM', ':qa<CR>'),
    }

    dashboard.section.footer.val = fortune()
    dashboard.section.footer.opts.hl = 'TSEmphasis'

    ------------------------------------------------------------------------------------------------
    --  Setup
    ------------------------------------------------------------------------------------------------
    alpha.setup({
      layout = {
        { type = 'padding', val = 2 },
        { type = 'group', val = neovim_header() },
        { type = 'padding', val = 1 },
        installed_plugins,
        version,
        { type = 'padding', val = 1 },
        separator,
        sessions(5),
        separator,
        { type = 'padding', val = 1 },
        dashboard.section.buttons,
        separator,
        dashboard.section.footer,
      },
      opts = { margin = 10 },
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
