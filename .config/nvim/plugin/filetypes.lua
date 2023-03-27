if not as then return end
local settings, cmd, fn = as.filetype_settings, vim.cmd, vim.fn

settings({
  checkhealth = {
    opt_local = { spell = false },
  },
  ['dap-repl'] = {
    opt_local = {
      buflisted = false,
      winfixheight = true,
      signcolumn = 'yes:2',
    },
    function()
      as.adjust_split_height(10, 15)
      require('dap.ext.autocompl').attach()
    end,
  },
  dart = {
    bo = {
      syntax = '',
      textwidth = 100,
    },
    opt_local = { spell = true },
    mappings = {
      { 'n', '<leader>cc', '<Cmd>Telescope flutter commands<CR>', desc = 'flutter: commands' },
      { 'n', '<leader>dd', '<Cmd>FlutterDevices<CR>', desc = 'flutter: devices' },
      { 'n', '<leader>de', '<Cmd>FlutterEmulators<CR>', desc = 'flutter: emulators' },
      { 'n', '<leader>do', '<Cmd>FlutterOutline<CR>', desc = 'flutter: outline' },
      { 'n', '<leader>dq', '<Cmd>FlutterQuit<CR>', desc = 'flutter: quit' },
      { 'n', '<leader>drn', '<Cmd>FlutterRun<CR>', desc = 'flutter: server run' },
      { 'n', '<leader>drs', '<Cmd>FlutterRestart<CR>', desc = 'flutter: server restart' },
      {
        'n',
        '<leader>db',
        "<Cmd>TermExec cmd='flutter pub run build_runner build --delete-conflicting-outputs'<CR>",
        desc = 'flutter: run code generation',
      },
    },
  },
  [{ 'gitcommit', 'gitrebase' }] = {
    bo = { bufhidden = 'delete' },
    opt_local = {
      list = false,
      spell = true,
      spelllang = 'en_gb',
    },
  },
  go = {
    bo = {
      expandtab = false,
      softtabstop = 0,
      tabstop = 4,
      shiftwidth = 4,
    },
    opt_local = { spell = true },
    mappings = {
      { 'n', '<leader>gb', '<Cmd>GoBuild<CR>', desc = 'build' },
      { 'n', '<leader>gfs', '<Cmd>GoFillStruct<CR>', desc = 'fill struct' },
      { 'n', '<leader>gfp', '<Cmd>GoFixPlurals<CR>', desc = 'fix plurals' },
      { 'n', '<leader>gie', '<Cmd>GoIfErr<CR>', desc = 'if err' },
    },
  },
  markdown = {
    plugins = {
      cmp = function(cmp)
        cmp.setup.filetype('markdown', {
          sources = {
            { name = 'dictionary', group_index = 1 },
            { name = 'spell', group_index = 1 },
            { name = 'emoji', group_index = 1 },
            { name = 'buffer', group_index = 2 },
          },
        })
      end,
      ['nvim-surround'] = function(surround)
        surround.buffer_setup({
          surrounds = {
            l = {
              add = function() return { { '[' }, { '](' .. vim.fn.getreg('*') .. ')' } } end,
            },
          },
        })
      end,
    },
    mappings = {
      { 'n', '<localleader>p', '<Plug>MarkdownPreviewToggle', desc = 'markdown preview' },
    },
    function() vim.b.formatting_disabled = not vim.startswith(fn.expand('%'), vim.env.PROJECTS_DIR .. '/personal') end,
  },
  NeogitCommitMessage = {
    opt_local = {
      spell = true,
      spelllang = 'en_gb',
      list = false,
    },
    plugins = {
      cmp = function(cmp)
        cmp.setup.filetype('NeogitCommitMessage', {
          sources = {
            { name = 'git', group_index = 1 },
            { name = 'luasnip', group_index = 1 },
            { name = 'dictionary', group_index = 1 },
            { name = 'spell', group_index = 1 },
            { name = 'buffer', group_index = 2 },
          },
        })
      end,
    },
    function()
      vim.schedule(function()
        -- Schedule this call as highlights are not set correctly if there is not a delay
        highlight.set_winhl('gitcommit', 0, { { VirtColumn = { fg = { from = 'Variable' } } } })
      end)
      vim.treesitter.language.register('gitcommit', 'NeogitCommitMessage')
    end,
  },
  netrw = {
    g = {
      netrw_liststyle = 3,
      netrw_banner = 0,
      netrw_browse_split = 0,
      netrw_winsize = 25,
      netrw_altv = 1,
      netrw_fastbrowse = 0,
    },
    bo = { bufhidden = 'wipe' },
    mappings = {
      { 'n', 'q', '<Cmd>q<CR>' },
      { 'n', 'l', '<CR>' },
      { 'n', 'h', '<CR>' },
      { 'n', 'o', '<CR>' },
    },
  },
  norg = {
    plugins = {
      cmp = function(cmp)
        cmp.setup.filetype('norg', {
          sources = cmp.config.sources({
            { name = 'neorg' },
            { name = 'dictionary' },
            { name = 'spell' },
            { name = 'emoji' },
          }, {
            { name = 'buffer' },
          }),
        })
      end,
      ['nvim-surround'] = function(surround)
        surround.buffer_setup({
          surrounds = {
            l = { add = function() return { { '[' }, { ']{' .. vim.fn.getreg('*') .. '}' } } end },
          },
        })
      end,
    },
  },
  org = {
    opt_local = { signcolumn = 'yes' },
    plugins = {
      ufo = function(ufo) ufo.detach() end,
      cmp = function(cmp)
        cmp.setup.filetype('org', {
          sources = cmp.config.sources({
            { name = 'orgmode' },
            { name = 'dictionary' },
            { name = 'spell' },
            { name = 'emoji' },
          }, {
            { name = 'buffer' },
          }),
        })
      end,
      ['nvim-surround'] = function(surround)
        surround.buffer_setup({
          surrounds = {
            l = {
              add = function() return { { '[[' .. fn.getreg('*') .. '][' }, { ']]' } } end,
            },
          },
        })
      end,
    },
  },
  javascript = {
    opt_local = { spell = true },
  },
  qf = {
    opt_local = {
      wrap = false,
      number = false,
      signcolumn = 'yes',
      buflisted = false,
      winfixheight = true,
    },
    mappings = {
      { 'n', 'dd', as.list.qf.delete, desc = 'delete current quickfix entry' },
      { 'v', 'd', as.list.qf.delete, desc = 'delete selected quickfix entry' },
      { 'n', 'H', ':colder<CR>' },
      { 'n', 'L', ':cnewer<CR>' },
    },
    function()
      -- force quickfix to open beneath all other splits
      cmd.wincmd('J')
      as.adjust_split_height(3, 10)
    end,
  },
  startuptime = {
    function()
      -- open startup time to the left
      cmd.wincmd('H')
    end,
  },
  [{ 'typescript', 'typescriptreact' }] = {
    bo = { textwidth = 100 },
    opt_local = { spell = true },
    mappings = {
      {
        'n',
        'gd',
        '<Cmd>TypescriptGoToSourceDefinition<CR>',
        desc = 'typescript: go to source definition',
      },
    },
  },
  vim = {
    opt_local = { spell = true },
    mappings = {
      {
        'n',
        '<leader>so',
        function()
          cmd.source('%')
          vim.notify('Sourced ' .. fn.expand('%'))
        end,
      },
    },
  },
  [{ 'lua', 'python', 'rust', 'org', 'markdown' }] = {
    opt_local = { spell = true },
  },
})
