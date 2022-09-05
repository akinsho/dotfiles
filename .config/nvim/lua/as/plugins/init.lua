---@diagnostic disable: redefined-local
local utils = require('as.utils.plugins')

local with_local, conf = utils.with_local, utils.conf
local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fmt('%s/packer/packer_compiled.lua', fn.stdpath('cache'))
-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()
----------------------------------------------------------------------------- }}}1
-- cfilter plugin allows filtering down an existing quickfix list
vim.cmd.packadd({ 'cfilter', bang = true })

as.require('impatient')

local packer = require('packer')
--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
packer.startup({
  function(use)
    -- FIXME: this no longer loads the local plugin since the compiled file now
    -- loads packer.nvim so the local alias(local-packer) does not work
    use_local({ 'wbthomason/packer.nvim', local_path = 'contributing', opt = true })
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    -- TODO: this fixes a bug in neovim core that prevents "CursorHold" from working
    -- hopefully one day when this issue is fixed this can be removed
    -- @see: https://github.com/neovim/neovim/issues/12587
    use('antoinemadec/FixCursorHold.nvim')

    -- THE LIBRARY
    use('nvim-lua/plenary.nvim')

    use({
      'ahmedkhalf/project.nvim',
      config = function()
        require('project_nvim').setup({
          detection_methods = { 'pattern', 'lsp' },
          ignore_lsp = { 'null-ls' },
          patterns = { '.git' },
        })
      end,
    })

    use({
      'github/copilot.vim',
      after = 'nvim-cmp',
      setup = function() vim.g.copilot_no_tab_map = true end,
      config = function()
        as.imap('<Plug>(as-copilot-accept)', "copilot#Accept('<Tab>')", { expr = true })
        as.inoremap('<M-]>', '<Plug>(copilot-next)')
        as.inoremap('<M-[>', '<Plug>(copilot-previous)')
        as.inoremap('<C-\\>', '<Cmd>vertical Copilot panel<CR>')
        vim.g.copilot_filetypes = {
          ['*'] = true,
          gitcommit = false,
          NeogitCommitMessage = false,
          DressingInput = false,
          TelescopePrompt = false,
          ['neo-tree-popup'] = false,
          ['dap-repl'] = false,
        }
        require('as.highlights').plugin('copilot', { { CopilotSuggestion = { link = 'Comment' } } })
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      branch = 'master', -- '0.1.x',
      module_pattern = 'telescope.*',
      config = conf('telescope').config,
      event = 'CursorHold',
      requires = {
        {
          'natecraddock/telescope-zf-native.nvim',
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('zf-native') end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          requires = { { 'kkharji/sqlite.lua', module = 'sqlite' } },
          after = 'telescope.nvim',
          config = function() require('telescope').load_extension('smart_history') end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = { { 'kkharji/sqlite.lua', module = 'sqlite' } },
          config = function() require('telescope').load_extension('frecency') end,
        },
      },
    })

    use({
      'benfowler/telescope-luasnip.nvim',
      after = 'telescope.nvim',
      config = function() require('telescope').load_extension('luasnip') end,
    })

    use({
      'wincent/command-t',
      run = 'cd lua/wincent/commandt/lib && make',
      cmd = { 'CommandT', 'CommandTRipgrep' },
      setup = function() vim.g.CommandTPreferredImplementation = 'lua' end,
      config = function() require('wincent.commandt').setup() end,
    })

    use('kyazdani42/nvim-web-devicons')

    use_local({
      'folke/which-key.nvim',
      local_path = 'contributing',
      local_enabled = false,
      config = conf('whichkey'),
    })

    use({
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
    })

    use({ 'anuvyklack/hydra.nvim', config = conf('hydra') })

    use({
      'rmagatti/auto-session',
      config = function()
        local fn = vim.fn
        local fmt = string.format
        local data = fn.stdpath('data')
        require('auto-session').setup({
          log_level = 'error',
          auto_session_root_dir = fmt('%s/session/auto/', data),
          -- Do not enable auto restoration in my projects directory, I'd like to choose projects myself
          auto_restore_enabled = not vim.startswith(fn.getcwd(), vim.env.PROJECTS_DIR),
          auto_session_suppress_dirs = {
            vim.env.HOME,
            vim.env.PROJECTS_DIR,
            fmt('%s/Desktop', vim.env.HOME),
            fmt('%s/site/pack/packer/opt/*', data),
            fmt('%s/site/pack/packer/start/*', data),
          },
          auto_session_use_git_branch = true, -- This cause inconsistent results
        })
      end,
    })

    use({
      'knubie/vim-kitty-navigator',
      run = 'cp ./*.py ~/.config/kitty/',
      cond = function() return not vim.env.TMUX end,
    })

    use({ 'goolord/alpha-nvim', config = conf('alpha') })

    use({ 'lukas-reineke/indent-blankline.nvim', config = conf('indentline') })

    use({
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = conf('neo-tree'),
      keys = { '<C-N>' },
      cmd = { 'NeoTree' },
      requires = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'kyazdani42/nvim-web-devicons',
        { 'mrbjarksen/neo-tree-diagnostics.nvim', module = 'neo-tree.sources.diagnostics' },
        { 's1n7ax/nvim-window-picker', tag = 'v1.*', config = conf('window-picker') },
      },
    })
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{1
    -----------------------------------------------------------------------------//
    use({
      'williamboman/mason.nvim',
      event = 'BufRead',
      requires = { 'nvim-lspconfig', 'williamboman/mason-lspconfig.nvim' },
      config = function()
        local get_config = require('as.servers')
        require('mason').setup({ ui = { border = as.style.current.border } })
        require('mason-lspconfig').setup({ automatic_installation = true })
        require('mason-lspconfig').setup_handlers({
          function(name)
            local config = get_config(name)
            if config then require('lspconfig')[name].setup(config) end
          end,
        })
      end,
    })

    use({
      'neovim/nvim-lspconfig',
      module_pattern = 'lspconfig.*',
      config = function()
        require('as.highlights').plugin('lspconfig', {
          { LspInfoBorder = { link = 'FloatBorder' } },
        })
        require('lspconfig.ui.windows').default_options.border = as.style.current.border
        require('lspconfig').ccls.setup(require('as.servers')('ccls'))
      end,
    })

    use({
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup({ hl_group = 'Visual' })
        as.nnoremap('<leader>ri', function() return ':IncRename ' .. vim.fn.expand('<cword>') end, {
          expr = true,
          silent = false,
          desc = 'lsp: incremental rename',
        })
      end,
    })

    use({
      'andrewferrier/textobj-diagnostic.nvim',
      config = function() require('textobj-diagnostic').setup() end,
    })

    use({
      'zbirenbaum/neodim',
      config = function()
        require('neodim').setup({
          blend_color = require('as.highlights').get('Normal', 'bg'),
          alpha = 0.45,
          hide = {
            underline = false,
          },
        })
      end,
    })

    use({
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup({
          align = {
            bottom = false,
            right = true,
          },
          fmt = {
            stack_upwards = false,
          },
        })
        as.augroup('CloseFidget', {
          {
            event = 'VimLeavePre',
            command = 'silent! FidgetClose',
          },
        })
      end,
    })

    use({
      'kosayoda/nvim-lightbulb',
      config = function()
        require('as.highlights').plugin('Lightbulb', {
          { LightBulbFloatWin = { foreground = { from = 'Type' } } },
          { LightBulbVirtualText = { foreground = { from = 'Type' } } },
        })
        local icon = as.style.icons.misc.lightbulb
        require('nvim-lightbulb').setup({
          ignore = { 'null-ls' },
          autocmd = { enabled = true },
          sign = { enabled = false },
          virtual_text = { enabled = true, text = icon, hl_mode = 'blend' },
          float = { text = icon, enabled = false, win_opts = { border = 'none' } }, -- 
        })
      end,
    })

    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = conf('null-ls'),
    })

    use({
      'lvimuser/lsp-inlayhints.nvim',
      config = function()
        require('lsp-inlayhints').setup({
          inlay_hints = {
            highlight = 'Comment',
            labels_separator = ' ⏐ ',
            parameter_hints = {
              prefix = '',
            },
            type_hints = {
              prefix = '=> ',
              remove_colon_start = true,
            },
          },
        })
      end,
    })

    use({
      'ray-x/lsp_signature.nvim',
      config = function()
        require('lsp_signature').setup({
          bind = true,
          fix_pos = false,
          auto_close_after = 15, -- close after 15 seconds
          hint_enable = false,
          handler_opts = { border = as.style.current.border },
          toggle_key = '<C-K>',
          select_signature_key = '<M-N>',
        })
      end,
    })

    use({
      'hrsh7th/nvim-cmp',
      module = 'cmp',
      event = 'InsertEnter',
      config = conf('cmp'),
      wants = { 'LuaSnip', 'cmp-path' },
      requires = {
        { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
        { 'f3fora/cmp-spell', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
        { 'rcarriga/cmp-dap', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'dmitmel/cmp-cmdline-history', after = 'nvim-cmp' },
        { 'lukas-reineke/cmp-rg', tag = '*', after = 'nvim-cmp' },
        {
          'petertriho/cmp-git',
          after = 'nvim-cmp',
          config = function()
            require('cmp_git').setup({ filetypes = { 'gitcommit', 'NeogitCommitMessage' } })
          end,
        },
      },
    })

    -- Use <Tab> to escape from pairs such as ""|''|() etc.
    use({
      'abecodes/tabout.nvim',
      wants = { 'nvim-treesitter' },
      after = { 'nvim-cmp' },
      config = function() require('tabout').setup({ ignore_beginning = false, completion = false }) end,
    })

    -- }}}
    -----------------------------------------------------------------------------//
    -- Testing and Debugging {{{1
    -----------------------------------------------------------------------------//
    use({
      'nvim-neotest/neotest',
      setup = conf('neotest').setup,
      config = conf('neotest').config,
      module = 'neotest',
      requires = {
        { 'rcarriga/neotest-plenary', module = 'neotest-plenary' },
        { 'sidlatau/neotest-dart', module = 'neotest-dart' },
        with_local({
          'neotest/neotest-go',
          module = 'neotest-go',
          local_path = 'personal',
        }),
      },
    })

    use({
      'mfussenegger/nvim-dap',
      module = 'dap',
      tag = '*',
      setup = conf('dap').setup,
      config = conf('dap').config,
      requires = {
        {
          'rcarriga/nvim-dap-ui',
          after = 'nvim-dap',
          config = conf('dapui'),
        },
        {
          'theHamsta/nvim-dap-virtual-text',
          after = 'nvim-dap',
          config = function() require('nvim-dap-virtual-text').setup({ all_frames = true }) end,
        },
      },
    })

    --}}}
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//
    use({
      'lewis6991/satellite.nvim',
      opt = true,
      config = function()
        require('satellite').setup({
          handlers = {
            gitsigns = {
              enable = true,
            },
            marks = {
              enable = false,
            },
          },
          excluded_filetypes = {
            'packer',
            'neo-tree',
            'norg',
            'neo-tree-popup',
            'dapui_scopes',
            'dapui_stacks',
          },
        })
      end,
    })

    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup({ 'lua', 'vim', 'kitty', 'conf' }, {
          RGB = false,
          mode = 'background',
        })
      end,
    })

    use({
      'levouh/tint.nvim',
      event = 'BufRead',
      config = function()
        require('tint').setup({
          amt = -35,
          ignore = { 'WinSeparator', 'Status.*', 'Comment', 'Beacon.*', 'Panel.*' },
          ignorefunc = function(win_id)
            if vim.fn.win_gettype(win_id) ~= '' then return true end
            local buf = vim.api.nvim_win_get_buf(win_id)
            local b = vim.bo[buf]
            local ignore_bt = { 'terminal', 'prompt', 'nofile' }
            local ignore_ft =
              { 'neo-tree', 'packer', 'diff', 'toggleterm', 'Neogit.*', 'Telescope.*' }
            return as.any(b.bt, ignore_bt) or as.any(b.ft, ignore_ft)
          end,
        })
      end,
    })

    use({
      'B4mbus/todo-comments.nvim',
      config = function()
        require('todo-comments').setup()
        as.command('TodoDots', ('TodoQuickFix cwd=%s keywords=TODO,FIXME'):format(vim.g.vim_dir))
      end,
    })

    use({
      'lukas-reineke/virt-column.nvim',
      config = function()
        require('as.highlights').plugin('virt_column', {
          { VirtColumn = { bg = 'None', fg = { from = 'Comment', alter = 10 } } },
        })
        require('virt-column').setup({ char = '▕' })
      end,
    })

    -- NOTE: Defer loading till telescope is loaded this as it implicitly loads telescope so needs to be delayed
    use({ 'stevearc/dressing.nvim', after = 'telescope.nvim', config = conf('dressing') })

    use({
      'SmiteshP/nvim-navic',
      requires = 'neovim/nvim-lspconfig',
      config = function()
        vim.g.navic_silence = true
        local highlights = require('as.highlights')
        local s = as.style
        local misc = s.icons.misc

        require('as.highlights').plugin('navic', {
          { NavicText = { bold = true } },
          { NavicSeparator = { link = 'Directory' } },
        })
        local icons = as.map(function(icon, key)
          highlights.set(('NavicIcons%s'):format(key), { link = s.lsp.highlights[key] })
          return icon .. ' '
        end, s.current.lsp_icons)

        require('nvim-navic').setup({
          icons = icons,
          highlight = true,
          depth_limit_indicator = misc.ellipsis,
          separator = (' %s '):format(misc.arrow_right),
        })
      end,
    })

    use({
      'kevinhwang91/nvim-ufo',
      requires = 'kevinhwang91/promise-async',
      config = conf('ufo'),
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{1
    --------------------------------------------------------------------------------
    use('ii14/emmylua-nvim')

    use({
      'kylechui/nvim-surround',
      tag = '*',
      config = function()
        require('nvim-surround').setup({
          move_cursor = false,
          keymaps = { visual = 's' },
        })
      end,
    })

    -- FIXME: https://github.com/L3MON4D3/LuaSnip/issues/129
    -- causes formatting bugs on save when update events are TextChanged{I}
    use({
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      branch = 'parse_from_ast',
      requires = 'rafamadriz/friendly-snippets',
      config = conf('luasnip'),
      rocks = { 'jsregexp' },
    })

    use({
      'andrewferrier/debugprint.nvim',
      config = function()
        local dp = require('debugprint')
        dp.setup({ create_keymaps = false })

        as.nnoremap(
          '<leader>dp',
          function() return dp.debugprint({ variable = true }) end,
          { desc = 'debugprint: cursor', expr = true }
        )
        as.nnoremap(
          '<leader>do',
          function() return dp.debugprint({ motion = true }) end,
          { desc = 'debugprint: operator', expr = true }
        )
        as.nnoremap('<leader>dC', '<Cmd>DeleteDebugPrints<CR>', 'debugprint: clear all')
      end,
    })

    use({
      'AckslD/nvim-neoclip.lua',
      requires = { { 'kkharji/sqlite.lua', module = 'sqlite' } },
      config = function()
        require('neoclip').setup({
          enable_persistent_history = true,
          keys = {
            telescope = {
              i = { select = '<c-p>', paste = '<CR>', paste_behind = '<c-k>' },
              n = { select = 'p', paste = '<CR>', paste_behind = 'P' },
            },
          },
        })
        as.nnoremap(
          '<localleader>p',
          function() require('telescope').extensions.neoclip.default(as.telescope.dropdown()) end,
          'neoclip: open yank history'
        )
      end,
    })

    use({
      'klen/nvim-config-local',
      config = function()
        require('config-local').setup({
          config_files = { '.localrc.lua', '.vimrc', '.vimrc.lua' },
        })
      end,
    })

    -- prevent select and visual mode from overwriting the clipboard
    use({
      'kevinhwang91/nvim-hclipboard',
      event = 'InsertCharPre',
      config = function() require('hclipboard').start() end,
    })

    use({ 'chentoast/marks.nvim', config = conf('marks') })

    use({ 'monaqa/dial.nvim', config = conf('dial') })

    use({
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup()
        as.nnoremap('<BS>', function() require('fold-cycle').open() end)
      end,
    })

    -- Diff arbitrary blocks of text with each other
    use({ 'AndrewRadev/linediff.vim', cmd = 'Linediff' })

    use({
      'rainbowhxch/beacon.nvim',
      config = function()
        local beacon = require('beacon')
        beacon.setup({
          minimal_jump = 20,
          ignore_buffers = { 'terminal', 'nofile', 'neorg://Quick Actions' },
          ignore_filetypes = {
            'qf',
            'neo-tree',
            'NeogitCommitMessage',
            'NeogitPopup',
            'NeogitStatus',
            'packer',
            'trouble',
          },
        })
        as.augroup('BeaconCmds', {
          {
            event = 'BufReadPre',
            pattern = '*.norg',
            command = function() beacon.beacon_off() end,
          },
        })
      end,
    })

    use({
      'mfussenegger/nvim-treehopper',
      config = function()
        as.augroup('TreehopperMaps', {
          {
            event = 'FileType',
            command = function(args)
              -- FIXME: this issue should be handled inside the plugin rather than manually
              local langs = require('nvim-treesitter.parsers').available_parsers()
              if vim.tbl_contains(langs, vim.bo[args.buf].filetype) then
                as.omap('u', ":<C-U>lua require('tsht').nodes()<CR>", { buffer = args.buf })
                as.vnoremap('u', ":lua require('tsht').nodes()<CR>", { buffer = args.buf })
              end
            end,
          },
        })
      end,
    })

    use({
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      requires = 'nvim-cmp',
      config = function()
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
        require('nvim-autopairs').setup({
          close_triple_quotes = true,
          check_ts = true,
          ts_config = {
            lua = { 'string' },
            dart = { 'string' },
            javascript = { 'template_string' },
          },
          fast_wrap = { map = '<c-e>' },
        })
      end,
    })

    use({
      'karb94/neoscroll.nvim', -- NOTE: alternative: 'declancm/cinnamon.nvim'
      config = function() require('neoscroll').setup({ hide_cursor = true }) end,
    })

    use({
      'itchyny/vim-highlighturl',
      config = function() vim.g.highlighturl_guifg = require('as.highlights').get('URL', 'fg') end,
    })

    use({
      'danymat/neogen',
      requires = 'nvim-treesitter/nvim-treesitter',
      module = 'neogen',
      setup = function() as.nnoremap('<localleader>nc', require('neogen').generate, 'comment: generate') end,
      config = function() require('neogen').setup({ snippet_engine = 'luasnip' }) end,
    })

    use({
      'mizlan/iswap.nvim',
      cmd = { 'ISwap', 'ISwapWith' },
      config = function() require('iswap').setup() end,
      setup = function()
        as.nnoremap('<leader>iw', '<Cmd>ISwapWith<CR>', 'ISwap: swap with')
        as.nnoremap('<leader>ia', '<Cmd>ISwap<CR>', 'ISwap: swap any')
      end,
    })

    use({ 'rcarriga/nvim-notify', tag = '*', config = conf('notify') })

    use({
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      setup = function() as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>', 'undotree: toggle') end,
      config = function()
        vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
      end,
    })

    use({
      'johmsalas/text-case.nvim',
      config = function()
        require('textcase').setup()
        as.nnoremap('<localleader>[', ':Subs/<C-R><C-W>//<LEFT>', { silent = false })
        as.nnoremap('<localleader>]', ':%Subs/<C-r><C-w>//c<left><left>', { silent = false })
        as.xnoremap('<localleader>[', [["zy:%Subs/<C-r><C-o>"//c<left><left>]], { silent = false })
      end,
    })

    use({
      'moll/vim-bbye',
      config = function() as.nnoremap('<leader>qq', '<Cmd>Bwipeout<CR>', 'bbye: quit') end,
    })

    use({
      'nacro90/numb.nvim',
      event = 'CmdlineEnter',
      config = function() require('numb').setup() end,
    })
    -----------------------------------------------------------------------------//
    -- Quickfix
    -----------------------------------------------------------------------------//
    use({
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        require('as.highlights').plugin('pqf', {
          theme = {
            ['doom-one'] = { { qfPosition = { link = 'Todo' } } },
            ['horizon'] = { { qfPosition = { link = 'String' } } },
          },
        })
        require('pqf').setup()
      end,
    })

    use({
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').plugin('bqf', { { BqfPreviewBorder = { link = 'WinSeparator' } } })
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- Knowledge and task management {{{1
    --------------------------------------------------------------------------------
    use({
      'vhyrro/neorg',
      requires = { 'vhyrro/neorg-telescope' },
      config = conf('neorg'),
    })

    use({ 'nvim-orgmode/orgmode', config = conf('orgmode') })

    use({
      'lukas-reineke/headlines.nvim',
      ft = { 'org', 'norg', 'markdown', 'yaml' },
      setup = conf('headlines').setup,
      config = conf('headlines').config,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling & Startup {{{1
    --------------------------------------------------------------------------------
    -- TODO: this plugin will be redundant once https://github.com/neovim/neovim/pull/15436 is merged
    use('lewis6991/impatient.nvim')
    use({
      'dstein64/vim-startuptime',
      tag = '*',
      cmd = 'StartupTime',
      config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{1
    --------------------------------------------------------------------------------
    use({
      'kristijanhusak/vim-dadbod-ui',
      requires = 'tpope/vim-dadbod',
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
      setup = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        as.nnoremap('<leader>db', '<cmd>DBUIToggle<CR>', 'dadbod: toggle')
      end,
    })

    use('tpope/vim-eunuch')
    use('tpope/vim-sleuth')
    use('tpope/vim-repeat')
    -- sets searchable path for filetypes like go so 'gf' works
    use('tpope/vim-apathy')
    use({ 'tpope/vim-projectionist', config = conf('vim-projectionist') })
    -- }}}
    -----------------------------------------------------------------------------//
    -- Filetype Plugins {{{1
    -----------------------------------------------------------------------------//
    use_local({
      'akinsho/flutter-tools.nvim',
      requires = { 'nvim-dap', 'plenary.nvim' },
      local_path = 'personal',
      config = conf('flutter-tools'),
    })

    use({
      'olexsmir/gopher.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    })

    use('nanotee/sqls.nvim')

    use({
      'iamcco/markdown-preview.nvim',
      run = function() vim.fn['mkdp#util#install']() end,
      ft = { 'markdown' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
    })

    use('mtdl9/vim-log-highlighting')
    use('fladson/vim-kitty')
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{1
    --------------------------------------------------------------------------------
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = conf('treesitter'),
      local_path = 'contributing',
      requires = {
        {
          'nvim-treesitter/playground',
          cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
          setup = function()
            as.nnoremap(
              '<leader>E',
              '<Cmd>TSHighlightCapturesUnderCursor<CR>',
              'treesitter: cursor highlight'
            )
          end,
        },
      },
    })

    use({ 'p00f/nvim-ts-rainbow' })
    use({ 'nvim-treesitter/nvim-treesitter-textobjects' })
    use({
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require('as.highlights').plugin('treesitter-context', {
          { ContextBorder = { link = 'Dim' } },
          { TreesitterContext = { inherit = 'Normal' } },
          { TreesitterContextLineNumber = { inherit = 'LineNr' } },
        })
        require('treesitter-context').setup({
          multiline_threshold = 4,
          separator = { '─', 'ContextBorder' }, -- alternatives: ▁ ─ ▄
          mode = 'topline',
        })
      end,
    })

    use({
      'm-demare/hlargs.nvim',
      config = function()
        require('as.highlights').plugin('hlargs', {
          theme = {
            ['*'] = { { Hlargs = { italic = true, foreground = '#A5D6FF' } } },
            ['horizon'] = { { Hlargs = { italic = true, foreground = { from = 'Normal' } } } },
          },
        })
        require('hlargs').setup({
          excluded_argnames = {
            declarations = { 'use', 'use_rocks', '_' },
            usages = {
              go = { '_' },
              lua = { 'self', 'use', 'use_rocks', '_' },
            },
          },
        })
      end,
    })

    use({
      'lewis6991/spellsitter.nvim',
      config = function() require('spellsitter').setup({ enable = true }) end,
    })

    use({ 'psliwka/vim-dirtytalk', run = ':DirtytalkUpdate' })
    use('melvio/medical-spell-files')
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{1
    --------------------------------------------------------------------------------
    use({
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = {
        { 'n', '<localleader>gu', 'gitlinker: copy to clipboard' },
        { 'n', '<localleader>go', 'gitlinker: open in browser' },
      },
      config = function()
        local linker = require('gitlinker')
        linker.setup({ mappings = '<localleader>gu' })
        as.nnoremap(
          '<localleader>go',
          function() linker.get_repo_url({ action_callback = require('gitlinker.actions').open_in_browser }) end,
          'gitlinker: open in browser'
        )
      end,
    })

    use({ 'lewis6991/gitsigns.nvim', event = 'BufRead', config = conf('gitsigns') })

    use({
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      requires = 'plenary.nvim',
      config = conf('neogit'),
    })

    use({
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      module = 'diffview',
      setup = function()
        as.nnoremap('<localleader>gd', '<Cmd>DiffviewOpen<CR>', 'diffview: open')
        as.nnoremap('<localleader>gh', '<Cmd>DiffviewFileHistory<CR>', 'diffview: file history')
        as.vnoremap('gh', [[:'<'>DiffviewFileHistory<CR>]], 'diffview: file history')
      end,
      config = function()
        require('diffview').setup({
          default_args = {
            DiffviewFileHistory = { '%' },
          },
          hooks = {
            diff_buf_read = function()
              vim.wo.wrap = false
              vim.wo.list = false
              vim.wo.colorcolumn = ''
            end,
          },
          enhanced_diff_hl = true,
          keymaps = {
            view = { q = '<Cmd>DiffviewClose<CR>' },
            file_panel = { q = '<Cmd>DiffviewClose<CR>' },
            file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
          },
        })
      end,
    })
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{1
    --------------------------------------------------------------------------------
    use({
      'AckslD/nvim-trevJ.lua',
      module = 'trevj',
      setup = function()
        as.nnoremap('gS', function() require('trevj').format_at_cursor() end, {
          desc = 'splitjoin: split',
        })
      end,
      config = function() require('trevj').setup() end,
    })

    use({ 'numToStr/Comment.nvim', config = function() require('Comment').setup() end })

    use({
      'gbprod/substitute.nvim',
      config = function()
        require('substitute').setup()
        as.nnoremap('S', function() require('substitute').operator() end)
        as.xnoremap('S', function() require('substitute').visual() end)
        as.nnoremap('X', function() require('substitute.exchange').operator() end)
        as.xnoremap('X', function() require('substitute.exchange').visual() end)
        as.nnoremap('Xc', function() require('substitute.exchange').cancel() end)
      end,
    })

    use('wellle/targets.vim')
    use({
      'kana/vim-textobj-user',
      requires = {
        'kana/vim-operator-user',
        {
          'glts/vim-textobj-comment',
          event = 'CursorHold',
          config = function()
            vim.g.textobj_comment_no_default_key_mappings = 1
            as.xmap('ax', '<Plug>(textobj-comment-a)')
            as.omap('ax', '<Plug>(textobj-comment-a)')
            as.xmap('ix', '<Plug>(textobj-comment-i)')
            as.omap('ix', '<Plug>(textobj-comment-i)')
          end,
        },
      },
    })

    use({
      'linty-org/readline.nvim',
      event = 'CmdlineEnter',
      config = function()
        local readline = require('readline')
        local map = vim.keymap.set
        map('!', '<M-f>', readline.forward_word)
        map('!', '<M-b>', readline.backward_word)
        map('!', '<C-a>', readline.beginning_of_line)
        map('!', '<C-e>', readline.end_of_line)
        map('!', '<M-d>', readline.kill_word)
        map('!', '<M-BS>', readline.backward_kill_word)
        map('!', '<C-w>', readline.unix_word_rubout)
        map('!', '<C-k>', readline.kill_line)
        map('!', '<C-u>', readline.backward_kill_line)
      end,
    })

    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{1
    --------------------------------------------------------------------------------
    use({
      'phaazon/hop.nvim',
      tag = 'v2.*', -- branch = 'fix-multi-window-floats',
      keys = { { 'n', 's' }, { 'n', 'f' }, { 'n', 'F' } },
      config = conf('hop'),
    })

    -- }}}
    --------------------------------------------------------------------------------
    -- Themes  {{{1
    --------------------------------------------------------------------------------
    use({ 'LunarVim/horizon.nvim' })
    use('EdenEast/nightfox.nvim')
    use({
      'NTBBloodbath/doom-one.nvim',
      config = function()
        vim.g.doom_one_pumblend_enable = true
        vim.g.doom_one_pumblend_transparency = 3
      end,
    })
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{1
    ---------------------------------------------------------------------------------
    use({ 'rafcamlet/nvim-luapad', cmd = 'Luapad' })
    -- }}}
    ---------------------------------------------------------------------------------
    -- Personal plugins {{{1
    -----------------------------------------------------------------------------//
    use_local({
      'akinsho/pubspec-assist.nvim',
      ft = { 'dart' },
      event = 'BufEnter pubspec.yaml',
      local_path = 'personal',
      rocks = {
        {
          'lyaml',
          server = 'http://rocks.moonscript.org',
          env = { YAML_DIR = '/opt/homebrew/Cellar/libyaml/0.2.5/' },
        },
      },
      config = function() require('pubspec-assist').setup() end,
    })

    use_local({
      'akinsho/org-bullets.nvim',
      local_path = 'personal',
      config = function() require('org-bullets').setup() end,
    })

    use_local({
      'akinsho/toggleterm.nvim',
      local_path = 'personal',
      config = conf('toggleterm'),
    })

    use_local({
      'akinsho/bufferline.nvim',
      config = conf('bufferline'),
      local_path = 'personal',
      requires = 'nvim-web-devicons',
    })

    use_local({
      'akinsho/git-conflict.nvim',
      local_path = 'personal',
      config = function()
        require('git-conflict').setup({
          disable_diagnostics = true,
        })
      end,
    })
    --}}}
    ---------------------------------------------------------------------------------
  end,
  log = { level = 'info' },
  config = {
    compile_path = PACKER_COMPILED_PATH,
    preview_updates = true,
    display = {
      prompt_border = as.style.current.border,
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
})

as.command('PackerCompiledEdit', function() vim.cmd.edit(PACKER_COMPILED_PATH) end)

as.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  vim.cmd.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

as.nnoremap('<leader>ps', '<Cmd>PackerSync<CR>', 'packer: sync')

local function reload()
  as.invalidate('as.plugins', true)
  packer.compile()
end

as.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/as/plugins/*.lua' },
    desc = 'Packer setup and reload',
    command = reload,
  },
  {
    event = 'User',
    pattern = { 'VimrcReloaded' },
    desc = 'Packer setup and reload',
    command = reload,
  },
  {
    event = 'User',
    pattern = 'PackerCompileDone',
    command = function() packer_notify('Compilation finished', 'info') end,
  },
})

-- vim:foldmethod=marker
