local highlight, ui, fold, t, fmt = as.highlight, as.ui, as.fold, as.replace_termcodes, string.format
local api, fn = vim.api, vim.fn
local border = ui.current.border

return {
  { 'f3fora/cmp-spell', ft = { 'gitcommit', 'NeogitCommitMessage', 'markdown', 'norg', 'org' } },
  { 'rcarriga/cmp-dap' },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-emoji' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'lukas-reineke/cmp-rg' },
      { 'petertriho/cmp-git', opts = { filetypes = { 'gitcommit', 'NeogitCommitMessage' } } },
      { 'abecodes/tabout.nvim', opts = { ignore_beginning = false, completion = false } },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      local lsp_kinds, ellipsis = ui.lsp.highlights, ui.icons.misc.ellipsis

      local hl_defs = fold(
        function(accum, value, key)
          table.insert(accum, { [fmt('CmpItemKind%s', key)] = { fg = { from = value } } })
          return accum
        end,
        lsp_kinds,
        {
          { CmpItemAbbr = { fg = 'fg', bg = 'NONE', italic = false, bold = false } },
          { CmpItemAbbrMatch = { fg = { from = 'Keyword' } } },
          { CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' } },
          { CmpItemAbbrMatchFuzzy = { italic = true, fg = { from = 'Keyword' } } },
          { CmpItemMenu = { fg = { from = 'Pmenu', attr = 'bg', alter = 0.3 }, italic = true, bold = false } },
        }
      )

      highlight.plugin('Cmp', hl_defs)

      local cmp_window = {
        border = border,
        winhighlight = table.concat({
          'Normal:NormalFloat',
          'FloatBorder:FloatBorder',
          'CursorLine:Visual',
          'Search:None',
        }, ','),
      }

      local function shift_tab(fallback)
        if not cmp.visible() then return fallback() end
        if luasnip.jumpable(-1) then luasnip.jump(-1) end
      end

      local function tab(fallback) -- make TAB behave like Android Studio
        if not cmp.visible() then return fallback() end
        if not cmp.get_selected_entry() then return cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) end
        if luasnip.expand_or_jumpable() then return luasnip.expand_or_jump() end
        cmp.confirm()
      end

      local function copilot() api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true) end

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(cmp_window),
          documentation = cmp.config.window.bordered(cmp_window),
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-]>'] = cmp.mapping(copilot),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
          ['<C-space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<S-TAB>'] = cmp.mapping(shift_tab, { 'i', 's' }),
          ['<TAB>'] = cmp.mapping(tab, { 'i', 's' }),
        }),
        formatting = {
          deprecated = true,
          fields = { 'abbr', 'kind', 'menu' },
          format = lspkind.cmp_format({
            maxwidth = math.floor(vim.o.columns * 0.5),
            ellipsis_char = ellipsis,
            menu = {
              nvim_lsp = '[LSP]',
              nvim_lua = '[Lua]',
              emoji = '[E]',
              path = '[Path]',
              neorg = '[N]',
              luasnip = '[SN]',
              dictionary = '[D]',
              buffer = '[B]',
              spell = '[SP]',
              orgmode = '[Org]',
              norg = '[Norg]',
              rg = '[Rg]',
              git = '[Git]',
            },
          }),
        },
        sources = {
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'luasnip', group_index = 1 },
          { name = 'path', group_index = 1 },
          {
            name = 'rg',
            keyword_length = 4,
            max_item_count = 10,
            option = { additional_arguments = '--max-depth 8' },
            group_index = 1,
          },
          {
            name = 'buffer',
            options = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
            group_index = 2,
          },
          { name = 'spell', group_index = 2 },
        },
      })

      cmp.setup.filetype({ 'dap-repl', 'dapui_watches' }, { sources = { { name = 'dap' } } })
    end,
  },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp' },
    init = function() vim.g.copilot_no_tab_map = true end,
    config = function()
      local function accept_word()
        fn['copilot#Accept']('')
        local output = fn['copilot#TextQueuedForInsertion']()
        return fn.split(output, [[[ .]\zs]])[1]
      end

      local function accept_line()
        fn['copilot#Accept']('')
        local output = fn['copilot#TextQueuedForInsertion']()
        return fn.split(output, [[[\n]\zs]])[1]
      end
      map('i', '<Plug>(as-copilot-accept)', "copilot#Accept('<Tab>')", {
        expr = true,
        remap = true,
        silent = true,
      })
      map('i', '<M-]>', '<Plug>(copilot-next)', { desc = 'next suggestion' })
      map('i', '<M-[>', '<Plug>(copilot-previous)', { desc = 'previous suggestion' })
      map('i', '<C-\\>', '<Cmd>vertical Copilot panel<CR>', { desc = 'open copilot panel' })
      map('i', '<M-w>', accept_word, { expr = true, remap = false, desc = 'accept word' })
      map('i', '<M-l>', accept_line, { expr = true, remap = false, desc = 'accept line' })
      vim.g.copilot_filetypes = {
        ['*'] = true,
        gitcommit = false,
        NeogitCommitMessage = false,
        DressingInput = false,
        TelescopePrompt = false,
        ['neo-tree-popup'] = false,
        ['dap-repl'] = false,
      }
      highlight.plugin('copilot', { { CopilotSuggestion = { link = 'Comment' } } })
    end,
  },
}
