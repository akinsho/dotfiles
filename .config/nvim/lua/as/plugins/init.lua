local opt, api, fn, cmd, fmt = vim.opt, vim.api, vim.fn, vim.cmd, string.format
local border, highlight, icons = as.ui.current.border, as.highlight, as.ui.icons

return {
  -----------------------------------------------------------------------------//
  -- Core {{{3
  -----------------------------------------------------------------------------//
  'nvim-lua/plenary.nvim', -- THE LIBRARY
  'nvim-tree/nvim-web-devicons',
  {
    'olimorris/persisted.nvim',
    lazy = false,
    init = function()
      as.augroup('PersistedEvents', {
        event = 'User',
        pattern = 'PersistedSavePre',
        -- Arguments are always persisted in a session and can't be removed using 'sessionoptions'
        -- so remove them when saving a session
        command = function() cmd('%argdelete') end,
      })
    end,
    opts = {
      autoload = true,
      use_git_branch = true,
      allowed_dirs = { vim.g.dotfiles, vim.g.work_dir, vim.g.projects_dir .. '/personal' },
      ignored_dirs = { fn.stdpath('data') },
    },
  },
  {
    'mrjones2014/smart-splits.nvim',
    opts = {},
    build = './kitty/install-kittens.bash',
    keys = {
      { '<A-h>', function() require('smart-splits').resize_left() end },
      { '<A-l>', function() require('smart-splits').resize_right() end },
      -- moving between splits
      { '<C-h>', function() require('smart-splits').move_cursor_left() end },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end },
      -- swapping buffers between windows
      { '<leader><leader>h', function() require('smart-splits').swap_buf_left() end, desc = 'swap left' },
      { '<leader><leader>j', function() require('smart-splits').swap_buf_down() end, desc = 'swap down' },
      { '<leader><leader>k', function() require('smart-splits').swap_buf_up() end, desc = 'swap up' },
      { '<leader><leader>l', function() require('smart-splits').swap_buf_right() end, desc = 'swap right' },
    },
  },
  -- }}}
  -----------------------------------------------------------------------------//
  -- LSP,Completion & Debugger {{{1
  -----------------------------------------------------------------------------//
  'onsails/lspkind.nvim',
  'b0o/schemastore.nvim',
  {
    'kosayoda/nvim-lightbulb',
    event = 'LspAttach',
    opts = {
      autocmd = { enabled = true },
      sign = { enabled = false },
      float = { text = icons.misc.lightbulb, enabled = true, win_opts = { border = 'none' } },
    },
  },
  {
    {
      'williamboman/mason.nvim',
      cmd = 'Mason',
      build = ':MasonUpdate',
      opts = { ui = { border = border, height = 0.8 } },
    },
    {
      'williamboman/mason-lspconfig.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
        'mason.nvim',
        {
          'neovim/nvim-lspconfig',
          dependencies = {
            {
              'folke/neodev.nvim',
              ft = 'lua',
              opts = { library = { plugins = { 'nvim-dap-ui' } } },
            },
            {
              'folke/neoconf.nvim',
              cmd = { 'Neoconf' },
              opts = { local_settings = '.nvim.json', global_settings = 'nvim.json' },
            },
          },
          config = function()
            highlight.plugin('lspconfig', { { LspInfoBorder = { link = 'FloatBorder' } } })
            require('lspconfig.ui.windows').default_options.border = border
            require('lspconfig').ccls.setup(require('as.servers')('ccls'))
          end,
        },
      },
      opts = {
        automatic_installation = true,
        handlers = {
          function(name)
            local config = require('as.servers')(name)
            if config then require('lspconfig')[name].setup(config) end
          end,
        },
      },
    },
  },
  {
    'DNLHC/glance.nvim',
    opts = {
      preview_win_opts = { relativenumber = false },
      theme = { enable = true, mode = 'darken' },
    },
    keys = {
      { 'gD', '<Cmd>Glance definitions<CR>', desc = 'lsp: glance definitions' },
      { 'gR', '<Cmd>Glance references<CR>', desc = 'lsp: glance references' },
      { 'gY', '<Cmd>Glance type_definitions<CR>', desc = 'lsp: glance type definitions' },
      { 'gM', '<Cmd>Glance implementations<CR>', desc = 'lsp: glance implementations' },
    },
  },
  {
    'smjonas/inc-rename.nvim',
    opts = { hl_group = 'Visual', preview_empty_name = true },
    keys = {
      {
        '<leader>rn',
        function() return fmt(':IncRename %s', fn.expand('<cword>')) end,
        expr = true,
        silent = false,
        desc = 'lsp: incremental rename',
      },
    },
  },
  {
    'lvimuser/lsp-inlayhints.nvim',
    init = function()
      as.augroup('InlayHintsSetup', {
        event = 'LspAttach',
        command = function(args)
          local id = vim.tbl_get(args, 'data', 'client_id') --[[@as lsp.Client]]
          if not id then return end
          local client = vim.lsp.get_client_by_id(id)
          require('lsp-inlayhints').on_attach(client, args.buf)
        end,
      })
    end,
    opts = {
      inlay_hints = {
        highlight = 'Comment',
        labels_separator = ' ⏐ ',
        parameter_hints = { prefix = '󰊕' },
        type_hints = { prefix = '=> ', remove_colon_start = true },
      },
    },
  },
  { 'simrat39/rust-tools.nvim', dependencies = { 'nvim-lspconfig' } },
  -- }}}
  -----------------------------------------------------------------------------//
  -- UI {{{1
  -----------------------------------------------------------------------------//
  {
    'uga-rosa/ccc.nvim',
    ft = { 'lua', 'vim', 'typescript', 'typescriptreact', 'javascriptreact', 'svelte' },
    cmd = { 'CccHighlighterToggle' },
    opts = function()
      local ccc = require('ccc')
      local p = ccc.picker
      p.hex.pattern = {
        [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)>]=],
        [=[\v%(^|[^[:keyword:]])\zs#(\x\x)(\x\x)(\x\x)(\x\x)>]=],
      }
      ccc.setup({
        win_opts = { border = border },
        pickers = { p.hex, p.css_rgb, p.css_hsl, p.css_hwb, p.css_lab, p.css_lch, p.css_oklab, p.css_oklch },
        highlighter = {
          auto_enable = true,
          excludes = { 'dart', 'lazy', 'orgagenda', 'org', 'NeogitStatus', 'toggleterm' },
        },
      })
    end,
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
  -- }}}
  --------------------------------------------------------------------------------
  -- Utilities {{{1
  --------------------------------------------------------------------------------
  { 'famiu/bufdelete.nvim', keys = { { '<leader>qq', '<Cmd>Bdelete<CR>', desc = 'buffer delete' } } },
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'smoka7/hydra.nvim' },
    opts = {
      hint_config = { border = border },
    },
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        '<M-e>',
        '<cmd>MCstart<cr>',
        mode = { 'v', 'n' },
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
  {
    'folke/flash.nvim',
    opts = {
      modes = {
        char = {
          keys = { 'f', 'F', 't', 'T', ';' }, -- remove "," from keys
        },
      },
    },
    keys = {
      { 's', function() require('flash').jump() end, mode = { 'n', 'x', 'o' } },
      { 'S', function() require('flash').treesitter() end, mode = { 'o', 'x' } },
      { 'r', function() require('flash').remote() end, mode = 'o', desc = 'Remote Flash' },
      { '<c-s>', function() require('flash').toggle() end, mode = { 'c' }, desc = 'Toggle Flash Search' },
      {
        'R',
        function() require('flash').treesitter_search() end,
        mode = { 'o', 'x' },
        desc = 'Flash Treesitter Search',
      },
    },
  },
  {
    'chaoren/vim-wordmotion',
    lazy = false,
    init = function() vim.g.wordmotion_spaces = { '-', '_', '\\/', '\\.' } end,
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    keys = { { 's', mode = 'v' }, '<C-g>s', '<C-g>S', 'ys', 'yss', 'yS', 'cs', 'ds' },
    opts = { move_cursor = true, keymaps = { visual = 's' } },
  },
  {
    'andrewferrier/debugprint.nvim',
    opts = { create_keymaps = false },
    keys = {
      {
        '<leader>dp',
        function() return require('debugprint').debugprint({ variable = true }) end,
        desc = 'debugprint: cursor',
        expr = true,
      },
      {
        '<leader>do',
        function() return require('debugprint').debugprint({ motion = true }) end,
        desc = 'debugprint: operator',
        expr = true,
      },
      { '<leader>dC', '<Cmd>DeleteDebugPrints<CR>', desc = 'debugprint: clear all' },
    },
  },
  {
    'chrisgrieser/nvim-origami',
    event = 'BufReadPost',
    keys = { { '<BS>', function() require('origami').h() end, desc = 'toggle fold' } },
    opts = {},
  },
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  {
    'rainbowhxch/beacon.nvim',
    event = 'VeryLazy',
    opts = {
      minimal_jump = 20,
      ignore_buffers = { 'terminal', 'nofile', 'neorg://Quick Actions' },
      ignore_filetypes = {
        'qf',
        'dap_watches',
        'dap_scopes',
        'neo-tree',
        'NeogitCommitMessage',
        'NeogitPopup',
        'NeogitStatus',
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      local autopairs = require('nvim-autopairs')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
      autopairs.setup({
        close_triple_quotes = true,
        disable_filetype = { 'neo-tree-popup' },
        check_ts = true,
        fast_wrap = { map = '<c-e>' },
        ts_config = {
          lua = { 'string' },
          dart = { 'string' },
          javascript = { 'template_string' },
        },
      })
    end,
  },
  {
    'karb94/neoscroll.nvim', -- NOTE: alternative: 'declancm/cinnamon.nvim'
    event = 'VeryLazy',
    opts = { hide_cursor = true, mappings = { '<C-d>', '<C-u>', 'zt', 'zz', 'zb' } },
  },
  {
    'itchyny/vim-highlighturl',
    event = 'ColorScheme',
    config = function() vim.g.highlighturl_guifg = highlight.get('@keyword', 'fg') end,
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', '<Cmd>UndotreeToggle<CR>', desc = 'undotree: toggle' } },
    config = function()
      vim.g.undotree_TreeNodeShape = '◦' -- Alternative: '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', opts = {} },
  {
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1001,
    config = {
      window = { open = 'alternate' },
      callbacks = {
        block_end = function() require('toggleterm').toggle() end,
        post_open = function(_, winnr, _, is_blocking)
          if is_blocking then
            require('toggleterm').toggle()
          else
            api.nvim_set_current_win(winnr)
          end
        end,
      },
    },
  },
  -----------------------------------------------------------------------------//
  -- Quickfix
  -----------------------------------------------------------------------------//
  {
    url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    config = function()
      highlight.plugin('pqf', {
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
    config = function() highlight.plugin('bqf', { { BqfPreviewBorder = { fg = { from = 'Comment' } } } }) end,
  },
  -- }}}
  --------------------------------------------------------------------------------
  -- Profiling & Startup {{{1
  --------------------------------------------------------------------------------
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function() vim.g.startuptime_tries = 15 end,
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
      map('n', '<leader>db', '<cmd>DBUIToggle<CR>', { desc = 'dadbod: toggle' })
    end,
  },
  { 'tpope/vim-eunuch', cmd = { 'Move', 'Rename', 'Remove', 'Delete', 'Mkdir' } },
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  {
    'tpope/vim-abolish',
    event = 'CmdlineEnter',
    keys = {
      {
        '<localleader>[',
        ':S/<C-R><C-W>//<LEFT>',
        mode = 'n',
        silent = false,
        desc = 'abolish: replace word under the cursor (line)',
      },
      {
        '<localleader>]',
        ':%S/<C-r><C-w>//c<left><left>',
        mode = 'n',
        silent = false,
        desc = 'abolish: replace word under the cursor (file)',
      },
      {
        '<localleader>[',
        [["zy:'<'>S/<C-r><C-o>"//c<left><left>]],
        mode = 'x',
        silent = false,
        desc = 'abolish: replace word under the cursor (visual)',
      },
    },
  },
  -- }}}
  -----------------------------------------------------------------------------//
  -- Filetype Plugins {{{1
  -----------------------------------------------------------------------------//
  { 'lifepillar/pgsql.vim', lazy = false },
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() fn['mkdp#util#install']() end,
    ft = { 'markdown' },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,
  },
  {
    'vuki656/package-info.nvim',
    event = 'BufRead package.json',
    requires = 'MunifTanjim/nui.nvim',
    opts = {},
    init = function()
      highlight.plugin('packageInfo', {
        { PackageInfoOutdatedVersion = { fg = '#d19a66' } },
        { PackageInfoUpToDateVersion = { fg = '#3C4048' } },
      })
    end,
  },
  {
    'saecki/crates.nvim',
    version = '*',
    event = 'BufRead Cargo.toml',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      popup = { border = border },
      null_ls = { enabled = true },
    },
    config = function(_, opts)
      as.augroup('CmpSourceCargo', {
        event = 'BufRead',
        pattern = 'Cargo.toml',
        command = function() require('cmp').setup.buffer({ sources = { { name = 'crates' } } }) end,
      })
      require('crates').setup(opts)
    end,
  },
  { 'dmmulroy/tsc.nvim', cmd = 'TSC', opts = {}, ft = { 'typescript', 'typescriptreact' } },
  {
    'pmizio/typescript-tools.nvim',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'literal',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
  { 'fladson/vim-kitty', lazy = false },
  { 'mtdl9/vim-log-highlighting', lazy = false },
  -- }}}
  --------------------------------------------------------------------------------
  -- Syntax {{{1
  --------------------------------------------------------------------------------
  {
    'psliwka/vim-dirtytalk',
    lazy = false,
    build = ':DirtytalkUpdate',
    config = function() opt.spelllang:append('programming') end,
  },
  ---}}}
  --------------------------------------------------------------------------------
  -- Editing {{{1
  --------------------------------------------------------------------------------
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    opts = { use_default_keymaps = false },
    keys = {
      { 'gS', '<Cmd>TSJSplit<CR>', desc = 'split expression to multiple lines' },
      { 'gJ', '<Cmd>TSJJoin<CR>', desc = 'join expression to single line' },
    },
  },
  {
    'Wansmer/sibling-swap.nvim',
    keys = { ']w', '[w' },
    dependencies = { 'nvim-treesitter' },
    opts = {
      use_default_keymaps = true,
      highlight_node_at_cursor = true,
      keymaps = {
        [']w'] = 'swap_with_left',
        ['[w'] = 'swap_with_right',
      },
    },
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'VeryLazy',
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    keys = { 'gcc', { 'gc', mode = { 'x', 'n', 'o' } } },
    opts = function(_, opts)
      local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if ok then opts.pre_hook = integration.create_pre_hook() end
    end,
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function() require('mini.ai').setup({ mappings = { around_last = '', inside_last = '' } }) end,
  },
  {
    'glts/vim-textobj-comment',
    dependencies = { { 'kana/vim-textobj-user', dependencies = { 'kana/vim-operator-user' } } },
    init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
    keys = {
      { 'ax', '<Plug>(textobj-comment-a)', mode = { 'x', 'o' } },
      { 'ix', '<Plug>(textobj-comment-i)', mode = { 'x', 'o' } },
    },
  },
  {
    'linty-org/readline.nvim',
    keys = {
      { '<M-f>', function() require('readline').forward_word() end, mode = '!' },
      { '<M-b>', function() require('readline').backward_word() end, mode = '!' },
      { '<C-a>', function() require('readline').beginning_of_line() end, mode = '!' },
      { '<C-e>', function() require('readline').end_of_line() end, mode = '!' },
      { '<M-d>', function() require('readline').kill_word() end, mode = '!' },
      { '<M-BS>', function() require('readline').backward_kill_word() end, mode = '!' },
      { '<C-w>', function() require('readline').unix_word_rubout() end, mode = '!' },
      { '<C-k>', function() require('readline').kill_line() end, mode = '!' },
      { '<C-u>', function() require('readline').backward_kill_line() end, mode = '!' },
    },
  },
  -- }}}
  ---------------------------------------------------------------------------------
  -- Dev plugins  {{{1
  ---------------------------------------------------------------------------------
  { 'tweekmonster/helpful.vim', cmd = 'HelpfulVersion', ft = 'help' },
  { 'rafcamlet/nvim-luapad', cmd = 'Luapad' },
  -- }}}
  ---------------------------------------------------------------------------------
  -- Personal plugins {{{1
  ---------------------------------------------------------------------------------
  {
    'akinsho/pubspec-assist.nvim',
    ft = { 'dart' },
    event = 'BufEnter pubspec.yaml',
    dev = true,
    opts = {},
  },
  {
    'akinsho/git-conflict.nvim',
    event = 'VeryLazy',
    dev = true,
    opts = { disable_diagnostics = true },
  },
}
--}}}
---------------------------------------------------------------------------------
-- vim:foldmethod=marker nospell
