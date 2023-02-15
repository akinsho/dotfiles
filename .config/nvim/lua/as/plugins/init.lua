local opt, fn, fmt = vim.opt, vim.fn, string.format
local border, highlight = as.ui.current.border, as.highlight

local data = fn.stdpath('data')

return {
  -----------------------------------------------------------------------------//
  -- Core {{{3
  -----------------------------------------------------------------------------//
  'nvim-lua/plenary.nvim', -- THE LIBRARY
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        detection_methods = { 'pattern', 'lsp' },
        ignore_lsp = { 'null-ls' },
        patterns = { '.git' },
      })
    end,
  },
  'nvim-tree/nvim-web-devicons',
  {
    'mg979/vim-visual-multi',
    event = 'VeryLazy',
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
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
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
    },
  },
  {
    'knubie/vim-kitty-navigator',
    event = 'VeryLazy',
    build = 'cp ./*.py ~/.config/kitty/',
    cond = function() return not vim.env.TMUX end,
  },
  -- }}}
  -----------------------------------------------------------------------------//
  -- LSP,Completion & Debugger {{{1
  -----------------------------------------------------------------------------//
  {
    {
      'williamboman/mason.nvim',
      cmd = 'Mason',
      opts = { ui = { border = border, height = 0.8 } },
    },
    {
      'williamboman/mason-lspconfig.nvim',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
        'mason.nvim',
        {
          'neovim/nvim-lspconfig',
          dependencies = { 'mason-lspconfig.nvim' },
          config = function()
            highlight.plugin('lspconfig', { { LspInfoBorder = { link = 'FloatBorder' } } })
            require('lspconfig.ui.windows').default_options.border = border
            require('lspconfig').ccls.setup(require('as.servers')('ccls'))
          end,
        },
      },
      config = function()
        require('mason-lspconfig').setup({ automatic_installation = true })
        require('mason-lspconfig').setup_handlers({
          function(name)
            local config = require('as.servers')(name)
            if config then require('lspconfig')[name].setup(config) end
          end,
        })
      end,
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
      { 'gY', '<Cmd>Glance type_definitions<CR>' },
      { 'gM', '<Cmd>Glance implementations<CR>' },
    },
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      bind = true,
      fix_pos = false,
      auto_close_after = 15, -- close after 15 seconds
      hint_enable = false,
      handler_opts = { border = as.ui.current.border },
      toggle_key = '<C-K>',
      select_signature_key = '<M-N>',
    },
  },
  {
    'smjonas/inc-rename.nvim',
    opts = { hl_group = 'Visual' },
    keys = {
      {
        '<leader>rn',
        function() return ':IncRename ' .. fn.expand('<cword>') end,
        expr = true,
        silent = false,
        desc = 'lsp: incremental rename',
      },
    },
  },
  { 'andrewferrier/textobj-diagnostic.nvim', config = true },
  {
    'zbirenbaum/neodim',
    config = function()
      require('neodim').setup({
        blend_color = highlight.get('Normal', 'bg'),
        alpha = 0.45,
        hide = { underline = false },
      })
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      highlight.plugin('Lightbulb', {
        { LightBulbFloatWin = { foreground = { from = 'Type' } } },
        { LightBulbVirtualText = { foreground = { from = 'Type' } } },
      })
      local icon = as.ui.icons.misc.lightbulb
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
    'lvimuser/lsp-inlayhints.nvim',
    opts = {
      inlay_hints = {
        highlight = 'Comment',
        labels_separator = ' ⏐ ',
        parameter_hints = { prefix = '' },
        type_hints = { prefix = '=> ', remove_colon_start = true },
      },
    },
  },
  -- }}}
  -----------------------------------------------------------------------------//
  -- UI {{{1
  -----------------------------------------------------------------------------//
  {
    'uga-rosa/ccc.nvim',
    event = 'VeryLazy',
    opts = {
      win_opts = { border = border },
      highlighter = { auto_enable = true, excludes = { 'dart' } },
    },
  },
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      vim.g.navic_silence = true
      local s = as.ui
      local misc = s.icons.misc

      highlight.plugin('navic', {
        { NavicText = { bold = true } },
        { NavicSeparator = { link = 'Directory' } },
      })
      local icons = as.map(function(icon, key)
        highlight.set(fmt('NavicIcons%s', key), { link = s.lsp.highlights[key] })
        return icon .. ' '
      end, s.current.lsp_icons)

      require('nvim-navic').setup({
        icons = icons,
        highlight = true,
        depth_limit_indicator = misc.ellipsis,
        separator = (' %s '):format(misc.arrow_right),
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
  {
    'lukas-reineke/virt-column.nvim',
    lazy = false,
    config = function()
      highlight.plugin('virt_column', {
        { VirtColumn = { bg = 'None', fg = { from = 'Comment', alter = 10 } } },
      })
      require('virt-column').setup({ char = '▕' })
    end,
  },
  -- }}}
  --------------------------------------------------------------------------------
  -- Utilities {{{1
  --------------------------------------------------------------------------------
  'ii14/emmylua-nvim',
  {
    'chaoren/vim-wordmotion',
    init = function()
      vim.g.wordmotion_prefix = '<leader>'
      vim.g.wordmotion_spaces = { '-', '_', '\\/', '\\.' }
    end,
  },
  {
    'kylechui/nvim-surround',
    keys = { '<C-g>s', '<C-g>S', 'ys', 'yss', 'yS', 'cs', 'ds', 'gS' },
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
    'klen/nvim-config-local', -- TODO: remove once 0.9 is stable
    enabled = as.nightly(),
    config = function()
      require('config-local').setup({
        config_files = { '.localrc.lua', '.vimrc', '.nvim.lua' },
      })
    end,
  },
  -- prevent select and visual mode from overwriting the clipboard
  {
    'kevinhwang91/nvim-hclipboard',
    event = 'InsertCharPre',
    config = function() require('hclipboard').start() end,
  },
  {
    'jghauser/fold-cycle.nvim',
    config = true,
    keys = {
      { '<BS>', function() require('fold-cycle').open() end, desc = 'fold-cycle: toggle' },
    },
  },
  -- Diff arbitrary blocks of text with each other
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  {
    'rainbowhxch/beacon.nvim',
    event = 'VeryLazy',
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
    keys = {
      {
        'u',
        function() require('tsht').nodes() end,
        desc = 'treehopper: toggle',
        mode = 'o',
        noremap = false,
        silent = true,
      },
      {
        'u',
        ":lua require('tsht').nodes()<CR>",
        desc = 'treehopper: toggle',
        mode = 'x',
        silent = true,
      },
    },
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
    opts = {
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', 'zt', 'zz', 'zb' },
      hide_cursor = true,
    },
  },
  {
    'itchyny/vim-highlighturl',
    config = function() vim.g.highlighturl_guifg = highlight.get('URL', 'fg') end,
  },
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = { snippet_engine = 'luasnip' },
    keys = {
      {
        '<localleader>nc',
        function() require('neogen').generate() end,
        desc = 'comment: generate',
      },
    },
  },
  {
    'mizlan/iswap.nvim',
    config = true,
    cmd = { 'ISwap', 'ISwapWith' },
    keys = {
      { '<leader>iw', '<Cmd>ISwapWith<CR>', desc = 'ISwap: swap with' },
      { '<leader>ia', '<Cmd>ISwap<CR>', desc = 'ISwap: swap any' },
    },
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
  {
    'moll/vim-bbye',
    cmd = 'Bwipeout',
    keys = { { '<leader>qq', '<Cmd>Bwipeout<CR>', desc = 'bbye: quit' } },
  },
  { 'nacro90/numb.nvim', event = 'CmdlineEnter', config = true },
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
    config = function()
      highlight.plugin('bqf', { { BqfPreviewBorder = { fg = { from = 'Comment' } } } })
    end,
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
  { 'tpope/vim-eunuch', cmd = { 'Move', 'Rename', 'Remove', 'Delete', 'Mkdir' } },
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  -- sets searchable path for filetypes like go so 'gf' works
  { 'tpope/vim-apathy', event = 'VeryLazy' },
  {
    'tpope/vim-abolish',
    event = 'CmdlineEnter',
    keys = {
      { '<localleader>[', ':S/<C-R><C-W>//<LEFT>', mode = 'n', silent = false },
      { '<localleader>]', ':%S/<C-r><C-w>//c<left><left>', mode = 'n', silent = false },
      { '<localleader>[', [["zy:'<'>S/<C-r><C-o>"//c<left><left>]], mode = 'x', silent = false },
    },
  },
  -- }}}
  -----------------------------------------------------------------------------//
  -- Filetype Plugins {{{1
  -----------------------------------------------------------------------------//
  {
    'olexsmir/gopher.nvim',
    ft = 'go',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  },
  'nanotee/sqls.nvim',
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
    'jose-elias-alvarez/typescript.nvim',
    ft = { 'typescript', 'typescriptreact' },
    config = function() require('typescript').setup({ server = require('as.servers')('tsserver') }) end,
  },
  { 'fladson/vim-kitty', lazy = false },
  { 'mtdl9/vim-log-highlighting', lazy = false },
  -- }}}
  --------------------------------------------------------------------------------
  -- Syntax {{{1
  --------------------------------------------------------------------------------
  {
    'm-demare/hlargs.nvim',
    config = function()
      highlight.plugin('hlargs', {
        theme = {
          ['*'] = { { Hlargs = { italic = true, foreground = '#A5D6FF' } } },
          ['horizon'] = { { Hlargs = { italic = true, foreground = { from = 'Normal' } } } },
        },
      })
      require('hlargs').setup({
        excluded_argnames = {
          declarations = { 'use', '_' },
          usages = { go = { '_' }, lua = { 'self', 'use', '_' } },
        },
      })
    end,
  },
  {
    'psliwka/vim-dirtytalk',
    lazy = false,
    build = ':DirtytalkUpdate',
    config = function() opt.spelllang:append('programming') end,
  },
  'melvio/medical-spell-files',
  ---}}}
  --------------------------------------------------------------------------------
  -- Text Objects {{{1
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
      keymaps = {
        [']w'] = 'swap_with_left',
        ['[w'] = 'swap_with_right',
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    opts = function(_, opts)
      opts.pre_hook =
        require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    end,
  },
  {
    'gbprod/substitute.nvim',
    config = true,
    keys = {
      { 'S', function() require('substitute').visual() end, mode = 'x' },
      { 'S', function() require('substitute').operator() end, mode = 'n' },
      { 'X', function() require('substitute.exchange').operator() end, mode = 'n' },
      { 'X', function() require('substitute.exchange').visual() end, mode = 'x' },
      { 'Xc', function() require('substitute.exchange').cancel() end, mode = { 'n', 'x' } },
    },
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    config = function()
      require('mini.ai').setup({ mappings = { around_last = '', inside_last = '' } })
    end,
  },
  {
    'kana/vim-textobj-user',
    lazy = false,
    dependencies = {
      { 'kana/vim-operator-user' },
      {
        'glts/vim-textobj-comment',
        init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
        keys = {
          { 'ax', '<Plug>(textobj-comment-a)', mode = { 'x', 'o' } },
          { 'ix', '<Plug>(textobj-comment-i)', mode = { 'x', 'o' } },
        },
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
  -- Themes  {{{1
  --------------------------------------------------------------------------------
  { 'LunarVim/horizon.nvim', lazy = false, priority = 1000 },
  { 'catppuccin/nvim', name = 'catppuccin' },
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
    lazy = false,
    dev = true,
    config = true,
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
