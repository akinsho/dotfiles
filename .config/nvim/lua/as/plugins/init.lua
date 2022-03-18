local utils = require 'as.utils.plugins'

local conf = utils.conf
local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath 'cache' .. '/packer/packer_compiled.lua'

-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()
----------------------------------------------------------------------------- }}}1
-- cfilter plugin allows filter down an existing quickfix list
vim.cmd 'packadd! cfilter'

---@see: https://github.com/lewis6991/impatient.nvim/issues/35
as.safe_require 'impatient'

local packer = require 'packer'
--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
packer.startup {
  function(use, use_rocks)
    -- FIXME: this no longer loads the local plugin since the compiled file now
    -- loads packer.nvim so the local alias(local-packer) does not work
    use_local { 'wbthomason/packer.nvim', local_path = 'contributing', opt = true }
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    use_rocks 'penlight'

    use {
      'ahmedkhalf/project.nvim',
      config = function()
        require('project_nvim').setup()
      end,
    }

    use {
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<c-p>', '<leader>fo', '<leader>ff', '<leader>fs' },
      module_pattern = 'telescope.*',
      config = conf 'telescope',
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'fzf'
          end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = 'tami5/sqlite.lua',
        },
        {
          'camgraff/telescope-tmux.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'tmux'
          end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'smart_history'
          end,
        },
        {
          'nvim-telescope/telescope-github.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension 'gh'
          end,
        },
      },
    }

    use {
      'mrjones2014/dash.nvim',
      command = 'Dash',
      module = 'dash',
      run = 'make install',
      after = 'telescope.nvim',
    }

    use 'kyazdani42/nvim-web-devicons'

    use { 'folke/which-key.nvim', config = conf 'whichkey' }

    use {
      'folke/trouble.nvim',
      keys = { '<leader>ld' },
      cmd = { 'TroubleToggle' },
      setup = function()
        require('which-key').register {
          ['<leader>l'] = {
            d = 'trouble: toggle',
            r = 'trouble: lsp references',
          },
          ['[d'] = 'trouble: next item',
          [']d'] = 'trouble: previous item',
        }
      end,
      requires = 'nvim-web-devicons',
      config = function()
        local H = require 'as.highlights'
        H.plugin(
          'trouble',
          { 'TroubleNormal', { link = 'PanelBackground' } },
          { 'TroubleText', { link = 'PanelBackground' } },
          { 'TroubleIndent', { link = 'PanelVertSplit' } },
          { 'TroubleFoldIcon', { foreground = 'yellow', bold = true } },
          { 'TroubleLocation', { foreground = H.get_hl('Comment', 'fg') } }
        )
        local trouble = require 'trouble'
        as.nnoremap('<leader>ld', '<cmd>TroubleToggle workspace_diagnostics<CR>')
        as.nnoremap('<leader>lr', '<cmd>TroubleToggle lsp_references<CR>')
        as.nnoremap(']d', function()
          trouble.previous { skip_groups = true, jump = true }
        end)
        as.nnoremap('[d', function()
          trouble.next { skip_groups = true, jump = true }
        end)
        trouble.setup { auto_close = true, auto_preview = false }
      end,
    }

    use {
      'rmagatti/auto-session',
      config = function()
        require('auto-session').setup {
          log_level = 'error',
          auto_session_root_dir = ('%s/session/auto/'):format(vim.fn.stdpath 'data'),
        }
      end,
    }

    -- NOTE: this and the plugin below it should never be active at the same time
    -- so they have inverse conditions
    use {
      'christoomey/vim-tmux-navigator',
      cond = function()
        return vim.env.TMUX ~= nil
      end,
      config = function()
        vim.g.tmux_navigator_no_mappings = 1
        as.nnoremap('<C-H>', '<cmd>TmuxNavigateLeft<cr>')
        as.nnoremap('<C-J>', '<cmd>TmuxNavigateDown<cr>')
        as.nnoremap('<C-K>', '<cmd>TmuxNavigateUp<cr>')
        as.nnoremap('<C-L>', '<cmd>TmuxNavigateRight<cr>')
        -- Disable tmux navigator when zooming the Vim pane
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_preserve_zoom = 1
        vim.g.tmux_navigator_save_on_switch = 2
      end,
    }

    use {
      'knubie/vim-kitty-navigator',
      run = 'cp ./*.py ~/.config/kitty/',
      cond = function()
        return vim.env.TMUX == nil
      end,
    }

    use {
      'nvim-lua/plenary.nvim',
      config = function()
        as.augroup('PlenaryTests', {
          {
            event = 'BufEnter',
            pattern = { '*/personal/*/tests/*_spec.lua' },
            command = function()
              require('which-key').register({
                t = {
                  name = '+plenary',
                  f = { '<Plug>PlenaryTestFile', 'test file' },
                  d = {
                    "<cmd>PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}<CR>",
                    'test directory',
                  },
                },
              }, {
                prefix = '<localleader>',
                buffer = 0,
              })
            end,
          },
        })
      end,
    }

    use { 'lukas-reineke/indent-blankline.nvim', config = conf 'indentline' }

    use { 'kyazdani42/nvim-tree.lua', config = conf 'nvim-tree', requires = 'nvim-web-devicons' }
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{1
    -----------------------------------------------------------------------------//
    use { 'neovim/nvim-lspconfig', config = conf 'lspconfig' }
    use 'lukas-reineke/lsp-format.nvim'
    use {
      'williamboman/nvim-lsp-installer',
      requires = 'nvim-lspconfig',
      config = function()
        local lsp_installer_servers = require 'nvim-lsp-installer.servers'
        for name, _ in pairs(as.lsp.servers) do
          ---@type boolean, table|string
          local ok, server = lsp_installer_servers.get_server(name)
          if ok then
            if not server:is_installed() then
              server:install()
            end
          end
        end
      end,
    }

    use {
      'narutoxy/dim.lua',
      requires = { 'nvim-treesitter/nvim-treesitter', 'neovim/nvim-lspconfig' },
      config = function()
        require('dim').setup {
          disable_lsp_decorations = true,
        }
      end,
    }

    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      -- trigger loading after lspconfig has started the other servers
      -- since there is otherwise a race condition and null-ls' setup would
      -- have to be moved into lspconfig.lua otherwise
      config = function()
        local null_ls = require 'null-ls'
        -- NOTE: this plugin will break if it's dependencies are not installed
        null_ls.setup {
          debounce = 150,
          on_attach = as.lsp.on_attach,
          sources = {
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.stylua.with {
              condition = function(_utils)
                return as.executable 'stylua'
                  and _utils.root_has_file { 'stylua.toml', '.stylua.toml' }
              end,
            },
            null_ls.builtins.formatting.prettier.with {
              filetypes = { 'html', 'json', 'yaml', 'graphql', 'markdown' },
              condition = function()
                return as.executable 'prettier'
              end,
            },
          },
        }
      end,
    }

    use {
      'ray-x/lsp_signature.nvim',
      config = function()
        require('lsp_signature').setup {
          bind = true,
          fix_pos = false,
          auto_close_after = 15, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = 'rounded' },
        }
      end,
    }

    use {
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      branch = 'dev',
      event = 'InsertEnter',
      requires = {
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        {
          'petertriho/cmp-git',
          after = 'nvim-cmp',
          config = function()
            require('cmp_git').setup {
              filetypes = { 'gitcommit', 'NeogitCommitMessage' },
            }
          end,
        },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'tzachar/cmp-tabnine', run = './install.sh', after = 'nvim-cmp' },
      },
      config = conf 'cmp',
    }

    use {
      'AckslD/nvim-neoclip.lua',
      config = function()
        require('neoclip').setup {
          enable_persistent_history = true,
          keys = {
            telescope = {
              i = { select = '<c-p>', paste = '<CR>', paste_behind = '<c-k>' },
              n = { select = 'p', paste = '<CR>', paste_behind = 'P' },
            },
          },
        }
        local function clip()
          require('telescope').extensions.neoclip.default(
            require('telescope.themes').get_dropdown()
          )
        end
        require('which-key').register {
          ['<localleader>p'] = { clip, 'neoclip: open yank history' },
        }
      end,
    }

    -- FIXME: https://github.com/L3MON4D3/LuaSnip/issues/129
    -- causes formatting bugs on save when updateevents are TextChanged{I}
    use {
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      requires = 'rafamadriz/friendly-snippets',
      config = conf 'luasnip',
    }
    -- }}}
    -----------------------------------------------------------------------------//
    -- Testing and Debugging {{{1
    -----------------------------------------------------------------------------//
    use {
      'vim-test/vim-test',
      cmd = { 'Test*' },
      keys = { '<localleader>tf', '<localleader>tn', '<localleader>ts' },
      setup = function()
        require('which-key').register({
          t = {
            name = '+vim-test',
            f = 'test: file',
            n = 'test: nearest',
            s = 'test: suite',
          },
        }, {
          prefix = '<localleader>',
        })
      end,
      config = function()
        vim.cmd [[
          function! ToggleTermStrategy(cmd) abort
            call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
          endfunction

          let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
        ]]
        vim.g['test#strategy'] = 'toggleterm'
        as.nnoremap('<localleader>tf', '<cmd>TestFile<CR>')
        as.nnoremap('<localleader>tn', '<cmd>TestNearest<CR>')
        as.nnoremap('<localleader>ts', '<cmd>TestSuite<CR>')
      end,
    }

    use {
      'rcarriga/vim-ultest',
      cmd = 'Ultest',
      wants = 'vim-test',
      event = { 'BufEnter *_test.*,*_spec.*' },
      requires = { 'vim-test' },
      run = ':UpdateRemotePlugins',
      config = function()
        local test_patterns = { '*_test.*', '*_spec.*' }
        as.augroup('UltestTests', {
          {
            event = { 'BufWritePost' },
            pattern = test_patterns,
            command = 'UltestNearest',
          },
        })
        as.nmap(']t', '<Plug>(ultest-next-fail)', {
          label = 'ultest: next failure',
          buffer = 0,
        })
        as.nmap('[t', '<Plug>(ultest-prev-fail)', {
          label = 'ultest: previous failure',
          buffer = 0,
        })
      end,
    }

    use {
      'mfussenegger/nvim-dap',
      setup = conf('dap').setup,
      config = conf('dap').config,
      requires = {
        {
          'rcarriga/nvim-dap-ui',
          after = 'nvim-dap',
          config = function()
            require('dapui').setup()
            as.nnoremap('<localleader>duc', function()
              require('dapui').close()
            end, 'dap-ui: close')
            as.nnoremap('<localleader>dut', function()
              require('dapui').toggle()
            end, 'dap-ui: toggle')

            -- NOTE: this opens dap UI automatically when dap starts
            local dap = require 'dap'
            -- dap.listeners.after.event_initialized['dapui_config'] = function()
            --   dapui.open()
            -- end
            dap.listeners.before.event_terminated['dapui_config'] = function()
              require('dapui').close()
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
              require('dapui').close()
            end
          end,
        },
        {
          'theHamsta/nvim-dap-virtual-text',
          config = function()
            require('nvim-dap-virtual-text').setup()
          end,
        },
      },
    }

    use { 'jbyuki/one-small-step-for-vimkind', requires = 'nvim-dap' }
    use 'folke/lua-dev.nvim'

    --}}}
    -----------------------------------------------------------------------------//
    -- UI
    -----------------------------------------------------------------------------//
    use {
      'petertriho/nvim-scrollbar',
      config = function()
        require('scrollbar').setup {
          handle = {
            color = require('as.highlights').get_hl('PmenuSbar', 'bg'),
          },
          -- NOTE: If telescope is not explicitly excluded this garbles input into its prompt buffer
          excluded_filetypes = {
            'packer',
            'TelescopePrompt',
            'NvimTree',
          },
          excluded_buftypes = {
            'nofile',
            'terminal',
            'prompt',
          },
        }
      end,
    }

    use {
      'stevearc/dressing.nvim',
      -- NOTE: Defer loading till telescope is loaded
      -- this implicitly loads telescope so needs to be delayed
      after = 'telescope.nvim',
      config = function()
        require('as.highlights').plugin(
          'dressing',
          { 'FloatTitle', { inherit = 'Normal', bold = true } }
        )
        require('dressing').setup {
          input = {
            insert_only = false,
            winblend = 2,
          },
          select = {
            telescope = require('telescope.themes').get_cursor {
              layout_config = {
                height = function(self, _, max_lines)
                  local results = #self.finder.results
                  return (results <= max_lines and results or max_lines - 10) + 4 -- 4 is the size of the window
                end,
              },
            },
          },
        }
      end,
    }

    --------------------------------------------------------------------------------
    -- Utilities {{{1
    --------------------------------------------------------------------------------
    use 'nanotee/luv-vimdocs'
    use 'milisims/nvim-luaref'

    use {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        -- this plugin is not safe to reload
        if vim.g.packer_compiled_loaded then
          return
        end
        require('todo-comments').setup {
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
          },
        }
        as.nnoremap('<leader>lt', '<Cmd>TodoTrouble<CR>', 'trouble: todos')
      end,
    }

    use {
      'github/copilot.vim',
      opt = true,
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.cmd [[imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")]]
        vim.g.copilot_filetypes = {
          ['*'] = false,
          gitcommit = false,
          NeogitCommitMessage = false,
          dart = true,
          lua = true,
        }
        require('as.highlights').plugin('copilot', { 'CopilotSuggestion', { link = 'Comment' } })
      end,
    }

    -- prevent select and visual mode from overwriting the clipboard
    use {
      'kevinhwang91/nvim-hclipboard',
      event = 'InsertCharPre',
      config = function()
        require('hclipboard').start()
      end,
    }

    use {
      'chentau/marks.nvim',
      config = function()
        require('as.highlights').plugin('marks', { 'MarkSignHL', { foreground = 'Red' } })
        require('marks').setup {
          bookmark_0 = {
            sign = '⚑',
            virt_text = 'bookmarks',
            builtin_marks = { '.' },
          },
        }
      end,
    }

    use {
      'edluffy/specs.nvim',
      opt = true,
      config = function()
        -- NOTE: 'DanilaMihailov/beacon.nvim' is an alternative
        local specs = require 'specs'
        specs.setup {
          popup = {
            delay_ms = 10,
            inc_ms = 10,
            blend = 10,
            width = 50,
            winhl = 'PmenuSbar',
            resizer = specs.slide_resizer,
          },
        }
      end,
    }

    use {
      'monaqa/dial.nvim',
      config = function()
        local dial = require 'dial.map'
        local augend = require 'dial.augend'
        local map = vim.keymap.set
        map('n', '<C-a>', dial.inc_normal(), { remap = false })
        map('n', '<C-x>', dial.dec_normal(), { remap = false })
        map('v', '<C-a>', dial.inc_visual(), { remap = false })
        map('v', '<C-x>', dial.dec_visual(), { remap = false })
        map('v', 'g<C-a>', dial.inc_gvisual(), { remap = false })
        map('v', 'g<C-x>', dial.dec_gvisual(), { remap = false })
        require('dial.config').augends:register_group {
          -- default augends used when no group name is specified
          default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias['%Y/%m/%d'],
            augend.constant.alias.bool,
            augend.constant.new {
              elements = { '&&', '||' },
              word = false,
              cyclic = true,
            },
          },
          dep_files = {
            augend.semver.alias.semver,
          },
        }

        as.augroup('DialMaps', {
          {
            event = 'FileType',
            pattern = { 'yaml', 'toml' },
            command = function()
              map('n', '<C-a>', require('dial.map').inc_normal 'dep_files', { remap = true })
            end,
          },
        })
      end,
    }

    use {
      'arecarn/vim-fold-cycle',
      config = function()
        vim.g.fold_cycle_default_mapping = 0
        as.nmap('<BS>', '<Plug>(fold-cycle-close)')
      end,
    }
    use {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require('nvim-autopairs').setup {
          close_triple_quotes = true,
          check_ts = false,
        }
      end,
    }
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup {
          mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', 'zt', 'zz', 'zb' },
          stop_eof = false,
          hide_cursor = true,
        }
      end,
    }
    use {
      'mg979/vim-visual-multi',
      config = function()
        vim.g.VM_highlight_matches = 'underline'
        vim.g.VM_theme = 'codedark'
        vim.g.VM_maps = {
          ['Find Under'] = '<C-e>',
          ['Find Subword Under'] = '<C-e>',
          ['Select Cursor Down'] = '\\j',
          ['Select Cursor Up'] = '\\k',
        }
      end,
    }
    use {
      'itchyny/vim-highlighturl',
      config = function()
        vim.g.highlighturl_guifg = require('as.highlights').get_hl('Keyword', 'fg')
      end,
    }

    use {
      utils.dev 'contributing/fidget.nvim',
      local_path = 'contributing',
      config = function()
        require('fidget').setup {
          text = {
            spinner = 'moon',
          },
          window = {
            blend = 0,
          },
        }
      end,
    }

    use {
      'rcarriga/nvim-notify',
      cond = utils.not_headless, -- TODO: causes blocking output in headless mode
      config = function()
        -- this plugin is not safe to reload
        if vim.g.packer_compiled_loaded then
          return
        end
        local notify = require 'notify'
        ---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
        local renderer = require 'notify.render'
        notify.setup {
          stages = 'fade_in_slide_out',
          timeout = 3000,
          render = function(bufnr, notif, highlights)
            local style = notif.title[1] == '' and 'minimal' or 'default'
            renderer[style](bufnr, notif, highlights)
          end,
        }
        vim.notify = notify
        require('telescope').load_extension 'notify'
        as.nnoremap('<leader>nd', notify.dismiss, { label = 'dismiss notifications' })
      end,
    }

    use {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      keys = '<leader>u',
      setup = function()
        require('which-key').register {
          ['<leader>u'] = 'undotree: toggle',
        }
      end,
      config = function()
        vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
        as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>')
      end,
    }

    use {
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install',
      ft = { 'markdown' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
    }

    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup({ '*' }, {
          RGB = false,
          mode = 'background',
        })
      end,
    }
    use {
      'moll/vim-bbye',
      config = function()
        as.nnoremap('<leader>qq', '<Cmd>Bwipeout<CR>')
      end,
    }
    -----------------------------------------------------------------------------//
    -- Quickfix
    -----------------------------------------------------------------------------//
    use {
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        require('as.highlights').plugin('pqf', { 'qfPosition', { link = 'Tag' } })
        require('pqf').setup {}
      end,
    }

    use {
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').plugin('bqf', { 'BqfPreviewBorder', { foreground = 'Gray' } })
      end,
    }
    --------------------------------------------------------------------------------
    -- Knowledge and task management {{{1
    --------------------------------------------------------------------------------
    use {
      'vimwiki/vimwiki',
      branch = 'dev',
      keys = { '<leader>ww', '<leader>wt', '<leader>wi' },
      event = { 'BufEnter *.wiki' },
      setup = conf('vimwiki').setup,
      config = conf('vimwiki').config,
    }

    use {
      'vhyrro/neorg',
      -- tag = '*', FIXME: add tag once neorg reaches 0.1
      requires = { 'vhyrro/neorg-telescope' },
      config = function()
        as.nnoremap('<localleader>oc', '<Cmd>Neorg gtd capture<CR>')
        as.nnoremap('<localleader>ov', '<Cmd>Neorg gtd views<CR>')
        require('neorg').setup {
          load = {
            ['core.defaults'] = {},
            -- TODO: cannot unmap <c-s> and segfaults, raise an issue
            ['core.integrations.telescope'] = {},
            ['core.keybinds'] = {
              config = {
                default_keybinds = true,
                neorg_leader = '<localleader>',
                hook = function(keybinds)
                  keybinds.map_event(
                    'norg',
                    'n',
                    '<C-x>',
                    'core.integrations.telescope.find_linkable'
                  )
                end,
              },
            },
            ['core.norg.completion'] = {
              config = {
                engine = 'nvim-cmp',
              },
            },
            ['core.norg.concealer'] = {},
            ['core.norg.dirman'] = {
              config = {
                workspaces = {
                  notes = vim.fn.expand '$SYNC_DIR/neorg/main/',
                  tasks = vim.fn.expand '$SYNC_DIR/neorg/tasks/',
                },
              },
            },
            ['core.gtd.base'] = {
              config = {
                workspace = 'tasks',
              },
            },
          },
        }
      end,
    }

    use {
      'lukas-reineke/headlines.nvim',
      setup = function()
        -- https://observablehq.com/@d3/color-schemes?collection=@d3/d3-scale-chromatic
        -- NOTE: this must be set in the setup function or it will crash nvim...
        require('as.highlights').plugin(
          'Headlines',
          { 'Headline1', { background = '#003c30', foreground = 'White' } },
          { 'Headline2', { background = '#00441b', foreground = 'White' } },
          { 'Headline3', { background = '#084081', foreground = 'White' } },
          { 'Dash', { background = '#0b60a1', bold = true } }
        )
      end,
      config = function()
        require('headlines').setup {
          markdown = {
            headline_highlights = { 'Headline1', 'Headline2', 'Headline3' },
          },
          yaml = {
            dash_pattern = '^---+$',
            dash_highlight = 'Dash',
            dash_string = '-',
          },
        }
      end,
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling & Startup {{{1
    --------------------------------------------------------------------------------
    -- TODO: this plugin will be redundant once https://github.com/neovim/neovim/pull/15436 is merged
    use 'lewis6991/impatient.nvim'
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{1
    --------------------------------------------------------------------------------
    use 'tpope/vim-eunuch'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-repeat'
    use {
      'tpope/vim-abolish',
      config = function()
        local opts = { silent = false }
        as.nnoremap('<localleader>[', ':S/<C-R><C-W>//<LEFT>', opts)
        as.nnoremap('<localleader>]', ':%S/<C-r><C-w>//c<left><left>', opts)
        as.xnoremap('<localleader>[', [["zy:%S/<C-r><C-o>"//c<left><left>]], opts)
      end,
    }
    -- sets searchable path for filetypes like go so 'gf' works
    use 'tpope/vim-apathy'
    use { 'tpope/vim-projectionist', config = conf 'vim-projectionist' }
    use {
      'tpope/vim-surround',
      config = function()
        as.xmap('s', '<Plug>VSurround')
        as.xmap('s', '<Plug>VSurround')
      end,
    }
    -- }}}
    -----------------------------------------------------------------------------//
    -- Filetype Plugins {{{1
    -----------------------------------------------------------------------------//
    use_local {
      'akinsho/flutter-tools.nvim',
      requires = { 'nvim-dap', 'plenary.nvim' },
      local_path = 'personal',
      config = function()
        require('flutter-tools').setup {
          ui = { border = 'rounded' },
          debugger = {
            enabled = true,
            run_via_dap = true,
          },
          outline = { auto_open = false },
          decorations = {
            statusline = { device = true, app_version = true },
          },
          widget_guides = { enabled = true, debug = true },
          dev_log = { enabled = false, open_cmd = 'tabedit' },
          lsp = {
            color = {
              enabled = true,
              background = true,
              virtual_text = false,
            },
            settings = {
              showTodos = true,
              renameFilesWithClasses = 'prompt',
            },
            on_attach = as.lsp and as.lsp.on_attach or nil,
          },
        }
      end,
    }

    use {
      'ray-x/go.nvim',
      ft = 'go',
      config = function()
        require('go').setup()
      end,
    }

    use 'dart-lang/dart-vim-plugin'
    use 'mtdl9/vim-log-highlighting'
    use 'fladson/vim-kitty'
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{1
    --------------------------------------------------------------------------------
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      event = 'BufReadPre',
      config = conf 'treesitter',
      local_path = 'contributing',
      wants = { 'null-ls.nvim', 'lua-dev.nvim' },
      requires = {
        { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' },
        { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
        {
          'nvim-treesitter/playground',
          keys = '<leader>E',
          cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
          setup = function()
            require('which-key').register { ['<leader>E'] = 'treesitter: highlight cursor group' }
          end,
          config = function()
            as.nnoremap('<leader>E', '<Cmd>TSHighlightCapturesUnderCursor<CR>')
          end,
        },
      },
    }

    -- Use <Tab> to escape from pairs such as ""|''|() etc.
    use {
      'abecodes/tabout.nvim',
      wants = { 'nvim-treesitter' },
      after = { 'nvim-cmp' },
      config = function()
        require('tabout').setup {
          completion = false,
          ignore_beginning = false,
        }
      end,
    }

    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup {
          enable = true,
        }
      end,
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{1
    --------------------------------------------------------------------------------
    use {
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = { '<localleader>gu', '<localleader>go' },
      setup = function()
        require('which-key').register(
          { gu = 'gitlinker: get line url', go = 'gitlinker: open repo url' },
          { prefix = '<localleader>' }
        )
      end,
      config = function()
        local linker = require 'gitlinker'
        linker.setup { mappings = '<localleader>gu' }
        as.nnoremap('<localleader>go', function()
          linker.get_repo_url { action_callback = require('gitlinker.actions').open_in_browser }
        end)
      end,
    }

    use { 'lewis6991/gitsigns.nvim', config = conf 'gitsigns' }

    use {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      requires = 'plenary.nvim',
      setup = conf('neogit').setup,
      config = conf('neogit').config,
    }

    use {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      module = 'diffview',
      keys = '<localleader>gd',
      setup = function()
        require('which-key').register { ['<localleader>gd'] = 'diffview: diff HEAD' }
      end,
      config = function()
        as.nnoremap('<localleader>gd', '<Cmd>DiffviewOpen<CR>')
        require('diffview').setup {
          enhanced_diff_hl = true,
          key_bindings = {
            file_panel = { q = '<Cmd>DiffviewClose<CR>' },
            view = { q = '<Cmd>DiffviewClose<CR>' },
          },
        }
      end,
    }

    use {
      'rlch/github-notifications.nvim',
      -- don't load this plugin if the gh cli is not installed
      cond = function()
        return as.executable 'gh'
      end,
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    }
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{1
    --------------------------------------------------------------------------------
    use {
      'AndrewRadev/splitjoin.vim',
      config = function()
        require('which-key').register { gS = 'splitjoin: split', gJ = 'splitjoin: join' }
      end,
    }

    use {
      'Matt-A-Bennett/vim-surround-funk',
      config = function()
        vim.g.surround_funk_create_mappings = 0
        local map = vim.keymap.set
        -- operator pending mode: grip surround
        map({ 'n', 'v' }, 'gs', '<Plug>(GripSurroundObject)')
        map({ 'n', 'v' }, 'gS', '<Plug>(GripSurroundObjectNoPaste)')
        map({ 'o', 'x' }, 'sF', '<Plug>(SelectWholeFUNCTION)')
        require('which-key').register {
          y = {
            name = '+ysf: yank ',
            s = {
              f = { '<Plug>(YankSurroundingFUNCTION)', 'yank surrounding function call' },
              F = {
                '<Plug>(YankSurroundingFunction)',
                'yank surrounding function call (partial)',
              },
            },
          },
          d = {
            name = '+dsf: function text object',
            s = {
              F = { '<Plug>(DeleteSurroundingFunction)', 'delete surrounding function' },
              f = { '<Plug>(DeleteSurroundingFUNCTION)', 'delete surrounding outer function' },
            },
          },
          c = {
            name = '+dsf: function text object',
            s = {
              F = { '<Plug>(ChangeSurroundingFunction)', 'change surrounding function' },
              f = { '<Plug>(ChangeSurroundingFUNCTION)', 'change outer surrounding function' },
            },
          },
        }
      end,
    }

    use {
      'protex/better-digraphs.nvim',
      keys = { { 'i', '<C-k><C-k>' } },
      config = function()
        as.inoremap('<C-k><C-k>', function()
          require('betterdigraphs').digraphs 'i'
        end)
        as.nnoremap('r<C-k><C-k>', function()
          require('betterdigraphs').digraphs 'r'
        end)
        as.vnoremap('r<C-k><C-k>', function()
          require('betterdigraphs').digraphs 'gvr'
        end)
      end,
    }

    use 'chaoren/vim-wordmotion'

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    }

    use {
      'gbprod/substitute.nvim',
      config = function()
        require('substitute').setup()
        as.nnoremap('S', function()
          require('substitute').operator()
        end)
        as.xnoremap('S', function()
          require('substitute').visual()
        end)
        as.nnoremap('X', function()
          require('substitute.exchange').operator()
        end)
        as.xnoremap('X', function()
          require('substitute.exchange').visual()
        end)
        as.nnoremap('Xc', function()
          require('substitute.exchange').cancel()
        end)
      end,
    }

    use 'wellle/targets.vim'
    use {
      'kana/vim-textobj-user',
      requires = {
        'kana/vim-operator-user',
        {
          'glts/vim-textobj-comment',
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            as.xmap('ax', '<Plug>(textobj-comment-a)')
            as.omap('ax', '<Plug>(textobj-comment-a)')
            as.xmap('ix', '<Plug>(textobj-comment-i)')
            as.omap('ix', '<Plug>(textobj-comment-i)')
          end,
        },
      },
    }
    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{1
    --------------------------------------------------------------------------------
    use {
      'phaazon/hop.nvim',
      keys = { { 'n', 's' }, 'f', 'F' },
      config = function()
        local hop = require 'hop'
        -- remove h,j,k,l from hops list of keys
        hop.setup { keys = 'etovxqpdygfbzcisuran' }
        as.nnoremap('s', function()
          hop.hint_char1 { multi_windows = true }
        end)
        -- NOTE: override F/f using hop motions
        vim.keymap.set({ 'x', 'n' }, 'F', function()
          hop.hint_char1 {
            direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            inclusive_jump = false,
          }
        end)
        vim.keymap.set({ 'x', 'n' }, 'f', function()
          hop.hint_char1 {
            direction = require('hop.hint').HintDirection.AFTER_CURSOR,
            current_line_only = true,
            inclusive_jump = false,
          }
        end)
        as.onoremap('F', function()
          hop.hint_char1 {
            direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            inclusive_jump = true,
          }
        end)
        as.onoremap('f', function()
          hop.hint_char1 {
            direction = require('hop.hint').HintDirection.AFTER_CURSOR,
            current_line_only = true,
            inclusive_jump = true,
          }
        end)
      end,
    }

    -- }}}
    --------------------------------------------------------------------------------
    -- Themes  {{{1
    --------------------------------------------------------------------------------
    use {
      'NTBBloodbath/doom-one.nvim',
      config = function()
        require('doom-one').setup {
          pumblend = {
            enable = true,
            transparency_amount = 3,
          },
        }
      end,
    }
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{1
    ---------------------------------------------------------------------------------
    use { 'rafcamlet/nvim-luapad', cmd = 'Luapad' }
    -- }}}
    ---------------------------------------------------------------------------------
    -- Personal plugins {{{1
    -----------------------------------------------------------------------------//
    use_local {
      'akinsho/pubspec-assist.nvim',
      local_path = 'personal',
      rocks = {
        {
          'lyaml',
          server = 'http://rocks.moonscript.org',
          env = { YAML_DIR = '/opt/homebrew/Cellar/libyaml/0.2.5/' },
        },
      },
      config = function()
        require('pubspec-assist').setup()
      end,
    }

    use_local {
      'akinsho/toggleterm.nvim',
      local_path = 'personal',
      config = function()
        require('toggleterm').setup {
          open_mapping = [[<c-\>]],
          shade_filetypes = { 'none' },
          direction = 'vertical',
          insert_mappings = false,
          start_in_insert = true,
          float_opts = { border = 'curved', winblend = 3 },
          size = function(term)
            if term.direction == 'horizontal' then
              return 15
            elseif term.direction == 'vertical' then
              return math.floor(vim.o.columns * 0.4)
            end
          end,
        }

        local float_handler = function(term)
          if vim.fn.mapcheck('jk', 't') ~= '' then
            vim.api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
            vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<esc>')
          end
        end

        local Terminal = require('toggleterm.terminal').Terminal

        local lazygit = Terminal:new {
          cmd = 'lazygit',
          dir = 'git_dir',
          hidden = true,
          direction = 'float',
          on_open = float_handler,
        }

        local htop = Terminal:new {
          cmd = 'htop',
          hidden = 'true',
          direction = 'float',
          on_open = float_handler,
        }

        as.command {
          'Htop',
          function()
            htop:toggle()
          end,
        }

        require('which-key').register {
          ['<leader>lg'] = {
            function()
              lazygit:toggle()
            end,
            'toggleterm: toggle lazygit',
          },
        }
      end,
    }
    use_local {
      'akinsho/bufferline.nvim',
      config = conf 'bufferline',
      local_path = 'personal',
      requires = 'nvim-web-devicons',
    }

    use_local {
      'akinsho/git-conflict.nvim',
      local_path = 'personal',
      config = function()
        require('git-conflict').setup {
          disable_diagnostics = true,
        }
      end,
    }
    --}}}
    ---------------------------------------------------------------------------------
  end,
  log = { level = 'info' },
  config = {
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = 'rounded',
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 240,
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
}

as.command {
  'PackerCompiledEdit',
  function()
    vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
  end,
}

as.command {
  'PackerCompiledDelete',
  function()
    vim.fn.delete(PACKER_COMPILED_PATH)
    packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
  end,
}

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  as.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

as.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/as/plugins/*.lua' },
    description = 'Packer setup and reload',
    command = function()
      as.invalidate('as.plugins', true)
      packer.compile()
    end,
  },
  --- Open a repository from an authorname/repository string
  --- e.g. 'akinso/example-repo'
  {
    event = 'BufEnter',
    buffer = 0,
    command = function()
      as.nnoremap('gf', function()
        local repo = fn.expand '<cfile>'
        if not repo or #vim.split(repo, '/') ~= 2 then
          return vim.cmd 'norm! gf'
        end
        local url = fmt('https://www.github.com/%s', repo)
        fn.jobstart('open ' .. url)
        vim.notify(fmt('Opening %s at %s', repo, url))
      end)
    end,
  },
  {
    event = 'User',
    pattern = 'PackerCompileDone',
    description = 'Inform me that packer has finished compiling',
    command = function()
      vim.notify('Packer compile complete', nil, { title = 'Packer' })
    end,
  },
})

as.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
as.nnoremap('<leader>pc', [[<Cmd>PackerClean<CR>]])

-- vim:foldmethod=marker
