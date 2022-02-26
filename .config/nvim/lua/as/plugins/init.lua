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

--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
require('packer').startup {
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

    use {
      'christoomey/vim-tmux-navigator',
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
      'nvim-lua/plenary.nvim',
      config = function()
        as.augroup('PlenaryTests', {
          {
            events = { 'BufEnter' },
            targets = { '*/personal/*/tests/*_spec.lua' },
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

    use 'b0o/schemastore.nvim'

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
            null_ls.builtins.formatting.stylua.with {
              condition = function(_utils)
                return as.executable 'stylua' and _utils.root_has_file 'stylua.toml'
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
      requires = { 'vim-test/vim-test' },
      run = ':UpdateRemotePlugins',
      config = function()
        local test_patterns = { '*_test.*', '*_spec.*' }
        as.augroup('UltestTests', {
          {
            events = { 'BufWritePost' },
            targets = test_patterns,
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
      module = 'dap',
      keys = { '<localleader>dc', '<localleader>db', '<localleader>dut ' },
      setup = conf('dap').setup,
      config = conf('dap').config,
      requires = {
        {
          'rcarriga/nvim-dap-ui',
          after = 'nvim-dap',
          config = function()
            local dapui = require 'dapui'
            dapui.setup()
            as.nnoremap('<localleader>duc', dapui.close, 'dap-ui: close')
            as.nnoremap('<localleader>dut', dapui.toggle, 'dap-ui: toggle')
            local dap = require 'dap'
            -- NOTE: this opens dap UI automatically when dap starts
            -- dap.listeners.after.event_initialized['dapui_config'] = function()
            --   dapui.open()
            -- end
            dap.listeners.before.event_terminated['dapui_config'] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
              dapui.close()
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
          excluded_filetypes = { 'packer', 'TelescopePrompt' },
          excluded_buftypes = { 'terminal', 'prompt' },
        }
      end,
    }

    use {
      utils.dev 'contributing/dressing.nvim',
      config = function()
        require('dressing').setup {
          input = {
            insert_only = false,
            winblend = 2,
          },
          select = {
            winblend = 2,
            telescope = {
              theme = require('telescope.themes').get_cursor {
                layout_config = {
                  height = function(self, _, max_lines)
                    local results = #self.finder.results
                    return (results <= max_lines and results or max_lines - 10) + 4 -- 4 is the size of the window
                  end,
                },
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
          },
        }
      end,
    }

    use {
      'edluffy/specs.nvim',
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
      'rcarriga/nvim-notify',
      cond = utils.not_headless, -- TODO: causes blocking output in headless mode
      config = function()
        local notify = require 'notify'
        ---@type table<string, fun(bufnr: number, notif: table, highlights: table)>
        local renderer = require 'notify.render'
        notify.setup {
          stages = 'fade_in_slide_out',
          timeout = 3000,
          render = function(bufnr, notif, highlights)
            if notif.title[1] == '' then
              return renderer.minimal(bufnr, notif, highlights)
            end
            return renderer.default(bufnr, notif, highlights)
          end,
        }
        vim.notify = notify
        require('telescope').load_extension 'notify'
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
      run = function()
        vim.fn['mkdp#util#install']()
      end,
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
                  notes = '~/Dropbox/neorg/main/',
                  tasks = '~/Dropbox/neorg/tasks/',
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
      config = function()
        -- https://observablehq.com/@d3/color-schemes?collection=@d3/d3-scale-chromatic
        require('as.highlights').plugin(
          'Headlines',
          { 'Headline1', { background = '#4e79a7', foreground = 'White' } },
          { 'Headline2', { background = '#e15759', foreground = 'White' } },
          { 'Headline3', { background = '#f28e2c', foreground = 'White' } }
        )
        vim.fn.sign_define {
          { name = 'Headline1', linehl = 'Headline1' },
          { name = 'Headline2', linehl = 'Headline2' },
          { name = 'Headline3', linehl = 'Headline3' },
        }
        require('headlines').setup {
          markdown = {
            headline_signs = { 'Headline1', 'Headline2', 'Headline3' },
          },
          vimwiki = {
            headline_signs = { 'Headline1', 'Headline2', 'Headline3' },
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
    use { 'tpope/vim-apathy', ft = { 'go', 'python', 'javascript', 'typescript' } }
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
    -- TODO: if a plugin which is specified as after for other plugins is converted to opt=true
    -- trying to move that plugin to the opt directory fails
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
        require('spellsitter').setup {}
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
      'rhysd/conflict-marker.vim',
      config = function()
        require('as.highlights').plugin(
          'conflictMarker',
          { 'ConflictMarkerBegin', { background = '#2f7366' } },
          { 'ConflictMarkerOurs', { background = '#2e5049' } },
          { 'ConflictMarkerTheirs', { background = '#344f69' } },
          { 'ConflictMarkerEnd', { background = '#2f628e' } },
          { 'ConflictMarkerCommonAncestorsHunk', { background = '#754a81' } }
        )
        -- disable the default highlight group
        vim.g.conflict_marker_highlight_group = ''
        -- Include text after begin and end markers
        vim.g.conflict_marker_begin = '^<<<<<<< .*$'
        vim.g.conflict_marker_end = '^>>>>>>> .*$'
      end,
    }

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
      'AndrewRadev/dsf.vim',
      config = function()
        vim.g.dsf_no_mappings = 1
        require('which-key').register {
          d = {
            name = '+dsf: function text object',
            s = {
              f = { '<Plug>DsfDelete', 'delete surrounding function' },
              nf = { '<Plug>DsfNextDelete', 'delete next surrounding function' },
            },
          },
          c = {
            name = '+dsf: function text object',
            s = {
              f = { '<Plug>DsfChange', 'change surrounding function' },
              nf = { '<Plug>DsfNextChange', 'change next surrounding function' },
            },
          },
        }
      end,
    }
    use 'chaoren/vim-wordmotion'

    use {
      'svermeulen/vim-subversive',
      config = function()
        as.nmap('S', '<plug>(SubversiveSubstitute)')
      end,
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    }

    use {
      'tommcdo/vim-exchange',
      config = function()
        require('as.highlights').plugin('exchange', { 'ExchangeRegion', { link = 'Search' } })
        vim.g.exchange_no_mappings = 1
        vim.keymap.set({ 'n', 'x' }, 'X', '<Plug>(Exchange)')
        as.nmap('Xc', '<Plug>(ExchangeClear)')
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

    use {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('todo-comments').setup {
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
          },
        }
        as.nnoremap('<leader>lt', '<Cmd>TodoTrouble<CR>', 'trouble: todos')
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
        'semver',
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
    events = { 'BufWritePost' },
    targets = { '*/as/plugins/*.lua' },
    command = function()
      as.invalidate('as.plugins', true)
      require('packer').compile()
    end,
  },
  {
    events = { 'User PackerCompileDone' },
    command = function()
      vim.notify('Packer compile complete', nil, { title = 'Packer' })
    end,
  },
})
as.nnoremap('<leader>ps', [[<Cmd>PackerSync<CR>]])
as.nnoremap('<leader>pc', [[<Cmd>PackerClean<CR>]])

-- vim:foldmethod=marker
