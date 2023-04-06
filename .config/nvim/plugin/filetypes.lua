if not as then return end
local settings, highlight = as.filetype_settings, as.highlight
local cmd, fn, api, env, keymap, opt_l = vim.cmd, vim.fn, vim.api, vim.env, vim.keymap, vim.opt_local

settings({
  checkhealth = {
    opt = { spell = false },
  },
  ['dap-repl'] = {
    opt = {
      buflisted = false,
      winfixheight = true,
      signcolumn = 'yes:2',
    },
  },
  dart = {
    bo = {
      syntax = '',
      textwidth = 100,
    },
    opt = { spell = true },
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
  fzf = {
    function(args)
      -- Remove the default terminal mappings
      keymap.del('t', '<esc>', { buffer = args.buf })
      keymap.del('t', 'jk', { buffer = args.buf })
    end,
  },
  [{ 'gitcommit', 'gitrebase' }] = {
    bo = { bufhidden = 'delete' },
    opt = {
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
    opt = { spell = true },
    mappings = {
      { 'n', '<leader>gb', '<Cmd>GoBuild<CR>', desc = 'build' },
      { 'n', '<leader>gfs', '<Cmd>GoFillStruct<CR>', desc = 'fill struct' },
      { 'n', '<leader>gfp', '<Cmd>GoFixPlurals<CR>', desc = 'fix plurals' },
      { 'n', '<leader>gie', '<Cmd>GoIfErr<CR>', desc = 'if err' },
    },
  },
  help = {
    opt = {
      list = false,
      wrap = false,
      spell = true,
      textwidth = 78,
    },
    plugins = {
      ['virt-column'] = function(col)
        if not vim.bo.readonly then col.setup_buffer({ virtcolumn = '+1' }) end
      end,
    },
    function(args)
      local opts = { buffer = args.buf }
      -- if this a vim help file create mappings to make navigation easier otherwise enable preferred editing settings
      if vim.startswith(fn.expand('%'), env.VIMRUNTIME) or vim.bo.readonly then
        opt_l.spell = false
        api.nvim_create_autocmd('BufWinEnter', { buffer = 0, command = 'wincmd L | vertical resize 80' })
        -- https://vim.fandom.com/wiki/Learn_to_use_help
        map('n', '<CR>', '<C-]>', opts)
        map('n', '<BS>', '<C-T>', opts)
      else
        map('n', '<leader>ml', 'maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a', opts)
      end
    end,
  },
  markdown = {
    opt = {
      spell = true,
    },
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
              add = function() return { { '[' }, { ('](%s)'):format(fn.getreg('*')) } } end,
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
    opt = {
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
          sources = {
            { name = 'neorg', group_index = 1 },
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
            l = { add = function() return { { '[' }, { ']{' .. vim.fn.getreg('*') .. '}' } } end },
          },
        })
      end,
    },
  },
  org = {
    opt = {
      spell = true,
      signcolumn = 'yes',
    },
    plugins = {
      ufo = function(ufo) ufo.detach() end,
      cmp = function(cmp)
        cmp.setup.filetype('org', {
          sources = {
            { name = 'orgmode', group_index = 1 },
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
              add = function() return { { '[[' .. fn.getreg('*') .. '][' }, { ']]' } } end,
            },
          },
        })
      end,
    },
  },
  javascript = {
    opt = { spell = true },
  },
  qf = {
    opt = {
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
    function() cmd.wincmd('H') end, -- open startup time to the left
  },
  [{ 'typescript', 'typescriptreact' }] = {
    bo = { textwidth = 100 },
    opt = { spell = true },
    mappings = {
      { 'n', 'gd', '<Cmd>TypescriptGoToSourceDefinition<CR>', desc = 'typescript: go to source definition' },
    },
  },
  vim = {
    opt = { spell = true },
    bo = { syntax = 'off' },
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
    function() -- TODO: if the syntax isn't delayed it still gets enabled
      vim.schedule(function() vim.bo.syntax = 'off' end)
    end,
  },
  [{ 'lua', 'python', 'rust' }] = { opt = { spell = true } },
})
