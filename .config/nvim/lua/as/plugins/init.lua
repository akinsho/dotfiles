local opt, cmd, api, fn, fmt = vim.opt, vim.cmd, vim.api, vim.fn, string.format
local highlights = require('as.highlights')
---Require a plugin config
---@param name string
---@return any
local function conf(name) return require(fmt('as.plugins.%s', name)) end

-----------------------------------------------------------------------------//
-- Bootstrap Lazy {{{3
-----------------------------------------------------------------------------//
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
opt.runtimepath:prepend(lazypath)
----------------------------------------------------------------------------- }}}1
require('lazy').setup(
  {
    -----------------------------------------------------------------------------//
    -- Core {{{3
    -----------------------------------------------------------------------------//
    -- THE LIBRARY
    'nvim-lua/plenary.nvim',
    {
      'ahmedkhalf/project.nvim',
      opts = {
        detection_methods = { 'pattern', 'lsp' },
        ignore_lsp = { 'null-ls' },
        patterns = { '.git' },
      },
    },
    {
      'github/copilot.vim',
      event = 'InsertEnter',
      dependencies = { 'nvim-cmp' },
      init = function() vim.g.copilot_no_tab_map = true end,
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
        highlights.plugin('copilot', { { CopilotSuggestion = { link = 'Comment' } } })
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      branch = 'master', -- '0.1.x',
      config = conf('telescope').config,
      event = 'CursorHold',
      dependencies = {
        {
          'natecraddock/telescope-zf-native.nvim',
          config = function() require('telescope').load_extension('zf-native') end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          dependencies = { { 'kkharji/sqlite.lua' } },
          config = function() require('telescope').load_extension('smart_history') end,
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          dependencies = { { 'kkharji/sqlite.lua' } },
          config = function() require('telescope').load_extension('frecency') end,
        },
        {
          'benfowler/telescope-luasnip.nvim',
          config = function() require('telescope').load_extension('luasnip') end,
        },
        {
          'nvim-telescope/telescope-live-grep-args.nvim',
          config = function() require('telescope').load_extension('live_grep_args') end,
        },
      },
    },
    'nvim-tree/nvim-web-devicons',
    { 'folke/which-key.nvim', config = conf('whichkey') },
    {
      'mg979/vim-visual-multi',
      init = function()
        vim.g.VM_highlight_matches = 'underline'
        vim.g.VM_theme = 'codedark'
        vim.g.VM_maps = {
          ['Find Word'] = '<C-E>',
          ['Find Under'] = '<C-E>',
          ['Find Subword Under'] = '<C-E>',
          ['Select Cursor Down'] = '\\j',
          ['Select Cursor Up'] = '\\k',
        }
      end,
    },

    { 'anuvyklack/hydra.nvim', config = conf('hydra') },
    {
      'rmagatti/auto-session',
      lazy = false,
      config = function()
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
          },
          auto_session_use_git_branch = false, -- This cause inconsistent results
        })
      end,
    },
    {
      'knubie/vim-kitty-navigator',
      event = 'VeryLazy',
      build = 'cp ./*.py ~/.config/kitty/',
      cond = function() return not vim.env.TMUX end,
    },
    { 'goolord/alpha-nvim', config = conf('alpha') },
    { 'lukas-reineke/indent-blankline.nvim', event = 'VeryLazy', config = conf('indentline') },
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = conf('neo-tree'),
      keys = { { '<C-N>', '<Cmd>Neotree toggle<CR>', desc = 'NeoTree' } },
      dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        { 'mrbjarksen/neo-tree-diagnostics.nvim' },
        { 's1n7ax/nvim-window-picker', version = '*', config = conf('window-picker') },
      },
    },
    -- }}}
    -----------------------------------------------------------------------------//
    -- LSP,Completion & Debugger {{{1
    -----------------------------------------------------------------------------//
    {
      {
        'williamboman/mason.nvim',
        event = 'VeryLazy',
        dependencies = {
          'neovim/nvim-lspconfig',
          'williamboman/mason-lspconfig.nvim',
        },
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
      },
      {
        'jayp0521/mason-null-ls.nvim',
        event = 'VeryLazy',
        dependencies = {
          'williamboman/mason.nvim',
          'jose-elias-alvarez/null-ls.nvim',
        },
        opts = {
          automatic_installation = true,
        },
      },
    },
    {
      'neovim/nvim-lspconfig',
      config = function()
        highlights.plugin('lspconfig', {
          { LspInfoBorder = { link = 'FloatBorder' } },
        })
        require('lspconfig.ui.windows').default_options.border = as.style.current.border
        require('lspconfig').ccls.setup(require('as.servers')('ccls'))
      end,
    },
    {
      'DNLHC/glance.nvim',
      keys = {
        { 'gD', '<Cmd>Glance definitions<CR>', desc = 'lsp: glance definitions' },
        { 'gR', '<Cmd>Glance references<CR>', desc = 'lsp: glance references' },
        { 'gY', '<CMD>Glance type_definitions<CR>' },
        { 'gM', '<CMD>Glance implementations<CR>' },
      },
    },
    {
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup({ hl_group = 'Visual' })
        as.nnoremap('<leader>ri', function() return ':IncRename ' .. vim.fn.expand('<cword>') end, {
          expr = true,
          silent = false,
          desc = 'lsp: incremental rename',
        })
      end,
    },
    { 'andrewferrier/textobj-diagnostic.nvim', config = true },
    {
      'zbirenbaum/neodim',
      opts = {
        blend_color = require('as.highlights').get('Normal', 'bg'),
        alpha = 0.45,
        hide = {
          underline = false,
        },
      },
    },
    {
      'kosayoda/nvim-lightbulb',
      config = function()
        highlights.plugin('Lightbulb', {
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
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = conf('null-ls'),
    },
    {
      'lvimuser/lsp-inlayhints.nvim',
      opts = {
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
      },
    },
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      config = conf('cmp'),
      dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-cmdline', enabled = not as.nightly() },
        { 'dmitmel/cmp-cmdline-history', enabled = not as.nightly() },
        { 'hrsh7th/cmp-nvim-lsp-document-symbol', enabled = not as.nightly() },
        { 'f3fora/cmp-spell' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-emoji' },
        { 'rcarriga/cmp-dap' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'lukas-reineke/cmp-rg' },
        {
          'petertriho/cmp-git',
          opts = { filetypes = { 'gitcommit', 'NeogitCommitMessage' } },
        },
        -- Use <Tab> to escape from pairs such as ""|''|() etc.
        { 'abecodes/tabout.nvim', opts = { ignore_beginning = false, completion = false } },
      },
    },
    -- }}}
    -----------------------------------------------------------------------------//
    -- Testing and Debugging {{{1
    -----------------------------------------------------------------------------//
    {
      'nvim-neotest/neotest',
      init = conf('neotest').setup,
      config = conf('neotest').config,
      dependencies = {
        { 'rcarriga/neotest-plenary' },
        { 'sidlatau/neotest-dart' },
        {
          'neotest/neotest-go',
          dev = true,
          module = 'neotest-go',
          local_path = 'personal',
        },
      },
    },
    {
      'mfussenegger/nvim-dap',
      init = conf('dap').setup,
      config = conf('dap').config,
      dependencies = {
        {
          'rcarriga/nvim-dap-ui',
          config = conf('dapui'),
        },
        { 'theHamsta/nvim-dap-virtual-text', opts = { all_frames = true } },
      },
    },
    --}}}
    -----------------------------------------------------------------------------//
    -- UI {{{1
    -----------------------------------------------------------------------------//
    { 'levouh/tint.nvim', event = 'VeryLazy', config = conf('tint') },
    {
      'uga-rosa/ccc.nvim',
      opts = {
        win_opts = { border = as.style.current.border },
        highlighter = {
          auto_enable = true,
          excludes = { 'dart' },
        },
      },
    },
    {
      'folke/todo-comments.nvim',
      event = 'VeryLazy',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('todo-comments').setup()
        as.command('TodoDots', ('TodoQuickFix cwd=%s keywords=TODO,FIXME'):format(vim.g.vim_dir))
      end,
    },
    {
      'lukas-reineke/virt-column.nvim',
      event = 'VeryLazy',
      config = function()
        highlights.plugin('virt_column', {
          { VirtColumn = { bg = 'None', fg = { from = 'Comment', alter = 10 } } },
        })
        require('virt-column').setup({ char = '▕' })
      end,
    },
    { 'stevearc/dressing.nvim', event = 'VeryLazy', config = conf('dressing') },
    {
      'SmiteshP/nvim-navic',
      dependencies = { 'neovim/nvim-lspconfig' },
      config = conf('navic'),
    },
    {
      'kevinhwang91/nvim-ufo',
      event = 'VeryLazy',
      dependencies = { 'kevinhwang91/promise-async' },
      config = conf('ufo'),
    },
    -- }}}
    --------------------------------------------------------------------------------
    -- Utilities {{{1
    --------------------------------------------------------------------------------
    'ii14/emmylua-nvim',
    {
      'folke/noice.nvim',
      event = 'VeryLazy',
      enabled = as.nightly(),
      dependencies = { 'MunifTanjim/nui.nvim' },
      config = conf('noice'),
    },
    {
      'chaoren/vim-wordmotion',
      init = function()
        vim.g.wordmotion_prefix = '<leader>'
        vim.g.wordmotion_spaces = { '-', '_', '\\/', '\\.' }
      end,
    },
    {
      'kylechui/nvim-surround',
      opts = {
        move_cursor = true,
        keymaps = { visual = 's' },
      },
    },
    -- FIXME: https://github.com/L3MON4D3/LuaSnip/issues/129
    -- causes formatting bugs on save when update events are TextChanged{I}
    {
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      module = 'luasnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = conf('luasnip'),
      build = 'make install_jsregexp',
    },
    {
      'andrewferrier/debugprint.nvim',
      keys = { '<leader>dp' },
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
    },
    {
      'gbprod/yanky.nvim',
      keys = { 'p', 'P', '<localleader>p' },
      dependencies = { 'kkharji/sqlite.lua' },
      config = conf('yanky'),
    },
    {
      'klen/nvim-config-local',
      config = function()
        require('config-local').setup({
          config_files = { '.localrc.lua', '.vimrc', '.vimrc.lua' },
        })
      end,
    },
    -- prevent select and visual mode from overwriting the clipboard
    {
      'kevinhwang91/nvim-hclipboard',
      event = 'InsertCharPre',
      config = function() require('hclipboard').start() end,
    },
    { 'chentoast/marks.nvim', config = conf('marks') },
    { 'monaqa/dial.nvim', config = conf('dial') },
    {
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup()
        as.nnoremap('<BS>', function() require('fold-cycle').open() end)
      end,
    },
    -- Diff arbitrary blocks of text with each other
    { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
    {
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
    },
    {
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
    },
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      dependencies = { 'hrsh7th/nvim-cmp' },
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
    },
    {
      'karb94/neoscroll.nvim', -- NOTE: alternative: 'declancm/cinnamon.nvim'
      event = 'VeryLazy',
      opts = {
        mappings = {
          '<C-u>',
          '<C-d>',
          '<C-b>',
          '<C-f>',
          '<C-y>',
          'zt',
          'zz',
          'zb',
        },
        hide_cursor = true,
      },
    },
    {
      'itchyny/vim-highlighturl',
      config = function() vim.g.highlighturl_guifg = highlights.get('URL', 'fg') end,
    },
    {
      'danymat/neogen',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      module = 'neogen',
      init = function()
        as.nnoremap('<localleader>nc', require('neogen').generate, 'comment: generate')
      end,
      opts = { snippet_engine = 'luasnip' },
    },
    {
      'mizlan/iswap.nvim',
      cmd = { 'ISwap', 'ISwapWith' },
      config = true,
      init = function()
        as.nnoremap('<leader>iw', '<Cmd>ISwapWith<CR>', 'ISwap: swap with')
        as.nnoremap('<leader>ia', '<Cmd>ISwap<CR>', 'ISwap: swap any')
      end,
    },
    { 'rcarriga/nvim-notify', config = conf('notify') },
    {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
      init = function() as.nnoremap('<leader>u', '<cmd>UndotreeToggle<CR>', 'undotree: toggle') end,
      config = function()
        vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
        vim.g.undotree_SetFocusWhenToggle = 1
      end,
    },
    {
      'moll/vim-bbye',
      event = 'VeryLazy',
      config = function() as.nnoremap('<leader>qq', '<Cmd>Bwipeout<CR>', 'bbye: quit') end,
    },
    { 'nacro90/numb.nvim', event = 'CmdlineEnter', config = true },
    -----------------------------------------------------------------------------//
    -- Quickfix
    -----------------------------------------------------------------------------//
    {
      url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        highlights.plugin('pqf', {
          theme = {
            ['doom-one'] = { { qfPosition = { link = 'Todo' } } },
            ['horizon'] = { { qfPosition = { link = 'String' } } },
          },
        })
        require('pqf').setup()
      end,
    },
    {
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        highlights.plugin('bqf', {
          { BqfPreviewBorder = { fg = { from = 'Comment' } } },
        })
      end,
    },
    -- }}}
    --------------------------------------------------------------------------------
    -- Knowledge and task management {{{1
    --------------------------------------------------------------------------------
    {
      'vhyrro/neorg',
      ft = 'norg',
      config = conf('neorg'),
      dependencies = { 'vhyrro/neorg-telescope' },
    },
    { 'nvim-orgmode/orgmode', config = conf('orgmode') },
    {
      'lukas-reineke/headlines.nvim',
      ft = { 'org', 'norg', 'markdown', 'yaml' },
      init = conf('headlines').setup,
      config = conf('headlines').config,
    },
    -- }}}
    --------------------------------------------------------------------------------
    -- Profiling & Startup {{{1
    --------------------------------------------------------------------------------
    {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { '+let g:auto_session_enabled = 0' }
      end,
    },
    -- }}}
    --------------------------------------------------------------------------------
    -- TPOPE {{{1
    --------------------------------------------------------------------------------
    {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = 'tpope/vim-dadbod',
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        as.nnoremap('<leader>db', '<cmd>DBUIToggle<CR>', 'dadbod: toggle')
      end,
    },
    'tpope/vim-eunuch',
    'tpope/vim-sleuth',
    'tpope/vim-repeat',
    {
      'tpope/vim-abolish',
      config = function()
        as.nnoremap('<localleader>[', ':S/<C-R><C-W>//<LEFT>', { silent = false })
        as.nnoremap('<localleader>]', ':%S/<C-r><C-w>//c<left><left>', { silent = false })
        as.xnoremap('<localleader>[', [["zy:'<'>S/<C-r><C-o>"//c<left><left>]], { silent = false })
      end,
    },
    -- sets searchable path for filetypes like go so 'gf' works
    'tpope/vim-apathy',
    { 'tpope/vim-projectionist', config = conf('vim-projectionist') },
    -- }}}
    -----------------------------------------------------------------------------//
    -- Filetype Plugins {{{1
    -----------------------------------------------------------------------------//
    {
      'akinsho/flutter-tools.nvim',
      dev = true,
      config = conf('flutter-tools'),
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    'RobertBrunhage/flutter-riverpod-snippets',
    {
      'olexsmir/gopher.nvim',
      dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    },
    'nanotee/sqls.nvim',
    {
      'iamcco/markdown-preview.nvim',
      build = function() vim.fn['mkdp#util#install']() end,
      ft = { 'markdown' },
      config = function()
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
      end,
    },
    'mtdl9/vim-log-highlighting',
    'fladson/vim-kitty',
    -- }}}
    --------------------------------------------------------------------------------
    -- Syntax {{{1
    --------------------------------------------------------------------------------
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = conf('treesitter'),
      dependencies = {
        {
          'nvim-treesitter/playground',
          cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
        },
      },
    },
    { 'p00f/nvim-ts-rainbow' },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        highlights.plugin('treesitter-context', {
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
    },
    {
      'm-demare/hlargs.nvim',
      config = function()
        highlights.plugin('hlargs', {
          theme = {
            ['*'] = { { Hlargs = { italic = true, foreground = '#A5D6FF' } } },
            ['horizon'] = { { Hlargs = { italic = true, foreground = { from = 'Normal' } } } },
          },
        })
        require('hlargs').setup({
          excluded_argnames = {
            declarations = { 'use', '_' },
            usages = {
              go = { '_' },
              lua = { 'self', 'use', '_' },
            },
          },
        })
      end,
    },
    {
      'psliwka/vim-dirtytalk',
      build = ':DirtytalkUpdate',
      config = function()
        opt.spelllang:append('programming')
        opt.rtp:append(fn.stdpath('data') .. '/site') -- Line of interest
      end,
    },
    'melvio/medical-spell-files',
    ---}}}
    --------------------------------------------------------------------------------
    -- Git {{{1
    --------------------------------------------------------------------------------
    {
      'ruifm/gitlinker.nvim',
      module = 'gitlinker',
      dependencies = { 'nvim-lua/plenary.nvim' },
      init = conf('gitlinker').setup,
      config = conf('gitlinker').config,
    },
    { 'lewis6991/gitsigns.nvim', event = 'VeryLazy', config = conf('gitsigns') },
    {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = conf('neogit'),
    },
    {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      module = 'diffview',
      init = conf('diffview').setup,
      config = conf('diffview').config,
    },
    ---}}}
    --------------------------------------------------------------------------------
    -- Text Objects {{{1
    --------------------------------------------------------------------------------
    {
      'Wansmer/treesj',
      dependencies = { 'nvim-treesitter' },
      keys = { 'gS', 'gJ' },
      config = function()
        require('treesj').setup({
          use_default_keymaps = false,
        })
        as.nnoremap('gS', '<Cmd>TSJSplit<CR>', 'split expression to multiple lines')
        as.nnoremap('gJ', '<Cmd>TSJJoin<CR>', 'join expression to single line')
      end,
    },
    {
      'Wansmer/sibling-swap.nvim',
      dependencies = { 'nvim-treesitter' },
      opts = {
        use_default_keymaps = false,
        keymaps = {
          [']w'] = 'swap_with_right',
          ['[w'] = 'swap_with_left',
        },
      },
    },
    { 'numToStr/Comment.nvim', config = true },
    {
      'gbprod/substitute.nvim',
      keys = {
        { 'S', mode = { 'n', 'x' } },
        { 'X', mode = { 'n', 'x' } },
        { 'Xc', mode = { 'n', 'x' } },
      },
      config = function()
        require('substitute').setup()
        as.nnoremap('S', function() require('substitute').operator() end)
        as.xnoremap('S', function() require('substitute').visual() end)
        as.nnoremap('X', function() require('substitute.exchange').operator() end)
        as.xnoremap('X', function() require('substitute.exchange').visual() end)
        as.nnoremap('Xc', function() require('substitute.exchange').cancel() end)
      end,
    },
    'wellle/targets.vim',
    {
      'kana/vim-textobj-user',
      lazy = false,
      dependencies = {
        { 'kana/vim-operator-user' },
        {
          'glts/vim-textobj-comment',
          init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
          config = function()
            as.xmap('ax', '<Plug>(textobj-comment-a)')
            as.omap('ax', '<Plug>(textobj-comment-a)')
            as.xmap('ix', '<Plug>(textobj-comment-i)')
            as.omap('ix', '<Plug>(textobj-comment-i)')
          end,
        },
      },
    },
    {
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
    },
    -- }}}
    --------------------------------------------------------------------------------
    -- Search Tools {{{1
    --------------------------------------------------------------------------------
    {
      'ggandor/leap.nvim',
      keys = { 's' },
      config = function()
        highlights.plugin('leap', {
          theme = {
            ['*'] = {
              { LeapBackdrop = { fg = '#707070' } },
            },
            horizon = {
              { LeapLabelPrimary = { bg = 'NONE', fg = '#ccff88', italic = true } },
              { LeapLabelSecondary = { bg = 'NONE', fg = '#99ccff' } },
              { LeapLabelSelected = { bg = 'NONE', fg = 'Magenta' } },
            },
          },
        })
        require('leap').setup({
          equivalence_classes = { ' \t\r\n', '([{', ')]}', '`"\'' },
        })
        as.nnoremap('s', function()
          require('leap').leap({
            target_windows = vim.tbl_filter(
              function(win) return as.empty(vim.fn.win_gettype(win)) end,
              api.nvim_tabpage_list_wins(0)
            ),
          })
        end)
      end,
    },
    {
      'ggandor/flit.nvim',
      keys = { 'f' },
      dependencies = { 'ggandor/leap.nvim' },
      opts = {
        labeled_modes = 'nvo',
        multiline = false,
      },
    },
    -- }}}
    --------------------------------------------------------------------------------
    -- Themes  {{{1
    --------------------------------------------------------------------------------
    { 'LunarVim/horizon.nvim', lazy = false, priority = 1000 },
    {
      'NTBBloodbath/doom-one.nvim',
      config = function()
        vim.g.doom_one_pumblend_enable = true
        vim.g.doom_one_pumblend_transparency = 3
      end,
    },
    -- }}}
    ---------------------------------------------------------------------------------
    -- Dev plugins  {{{1
    ---------------------------------------------------------------------------------
    { 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
    -- }}}
    ---------------------------------------------------------------------------------
    -- Personal plugins {{{1
    -----------------------------------------------------------------------------//
    {
      'akinsho/pubspec-assist.nvim',
      ft = { 'dart' },
      event = 'BufEnter pubspec.yaml',
      dev = true,
      config = true,
    },
    {
      'akinsho/org-bullets.nvim',
      dev = true,
      config = true,
    },
    {
      'akinsho/toggleterm.nvim',
      event = 'VeryLazy',
      dev = true,
      config = conf('toggleterm'),
    },
    {
      'akinsho/bufferline.nvim',
      event = 'VeryLazy',
      config = conf('bufferline'),
      dev = true,
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
      'akinsho/git-conflict.nvim',
      event = 'VeryLazy',
      dev = true,
      opts = {
        disable_diagnostics = true,
      },
    },
  },
  --}}}
  ---------------------------------------------------------------------------------
  {
    defaults = {
      lazy = true,
    },
    rtp = {
      paths = { fn.stdpath('data') .. '/site' },
      disabled_plugins = {
        'netrw',
        'netrwPlugin',
        'tarPlugin',
        'tutor',
        'tohtml',
        'logipat',
      },
    },
    ui = {
      border = as.style.current.border,
    },
    dev = {
      path = '~/projects/personal/',
      patterns = { 'akinsho' },
    },
    install = {
      colorscheme = { 'horizon' },
    },
  }
)

-- cfilter plugin allows filtering down an existing quickfix list
cmd.packadd('cfilter')
-- vim:foldmethod=marker nospell
