local highlight, t, fmt = as.highlight, as.replace_termcodes, string.format
local api, fn = vim.api, vim.fn
local border = as.ui.current.border

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-cmdline', enabled = not as.nightly() },
      { 'dmitmel/cmp-cmdline-history', enabled = not as.nightly() },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', enabled = not as.nightly() },
      {
        'f3fora/cmp-spell',
        ft = { 'gitcommit', 'NeogitCommitMessage', 'markdown', 'norg', 'org' },
      },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-emoji' },
      { 'rcarriga/cmp-dap' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'lukas-reineke/cmp-rg' },
      { 'petertriho/cmp-git', opts = { filetypes = { 'gitcommit', 'NeogitCommitMessage' } } },
      -- Use <Tab> to escape from pairs such as ""|''|() etc.
      { 'abecodes/tabout.nvim', opts = { ignore_beginning = false, completion = false } },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local kind_hls, ellipsis = as.ui.lsp.highlights, as.ui.icons.misc.ellipsis

      -- stylua: ignore
      --- @type HLArgs[]
      local menu_hls = {
        { CmpItemAbbr = { fg = 'fg', bg = 'NONE', italic = false, bold = false } },
        { CmpItemAbbrMatch = { fg = { from = 'Keyword' } } },
        { CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' } },
        { CmpItemAbbrMatchFuzzy = { italic = true, fg = { from = 'Keyword' } } },
        { CmpItemMenu = { fg = { from = 'Pmenu', attr = 'bg', alter = 0.3 }, italic = true, bold = false } }, -- Make the source information less prominent
      }

      -- stylua: ignore
      highlight.plugin('Cmp', as.fold(function(accum, value, key)
        table.insert(accum, { [fmt('CmpItemKind%s', key)] = { fg = { from = value } } })
        return accum
      end, kind_hls, menu_hls))

      local cmp_window = {
        border = border,
        winhighlight = table.concat({
          'Normal:NormalFloat',
          'FloatBorder:FloatBorder',
          'CursorLine:Visual',
          'Search:None',
        }, ','),
      }
      cmp.setup({
        experimental = { ghost_text = false },
        matching = { disallow_partial_fuzzy_matching = false },
        window = {
          completion = cmp.config.window.bordered(cmp_window),
          documentation = cmp.config.window.bordered(cmp_window),
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-]>'] = cmp.mapping(
            function(_) api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true) end
          ),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
          ['<C-space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<S-TAB>'] = cmp.mapping(function(fallback)
            if not cmp.visible() then return fallback() end
            if luasnip.jumpable(-1) then luasnip.jump(-1) end
          end, { 'i', 's' }),
          ['<TAB>'] = cmp.mapping(function(fallback) -- make TAB behave like Android Studio
            if not cmp.visible() then return fallback() end
            if not cmp.get_selected_entry() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                cmp.confirm()
              end
            end
          end, { 'i', 's' }),
        }),
        formatting = {
          deprecated = true,
          fields = { 'abbr', 'kind', 'menu' },
          format = function(entry, vim_item)
            local MAX = math.floor(vim.o.columns * 0.5)
            if #vim_item.abbr >= MAX then vim_item.abbr = vim_item.abbr:sub(1, MAX) .. ellipsis end
            vim_item.kind = fmt('%s %s', as.ui.current.lsp_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              nvim_lua = '[Lua]',
              emoji = '[E]',
              path = '[Path]',
              neorg = '[N]',
              luasnip = '[SN]',
              dictionary = '[D]',
              buffer = '[B]',
              spell = '[SP]',
              cmdline = '[Cmd]',
              cmdline_history = '[Hist]',
              orgmode = '[Org]',
              norg = '[Norg]',
              rg = '[Rg]',
              git = '[Git]',
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          {
            name = 'rg',
            keyword_length = 4,
            max_item_count = 10,
            option = { additional_arguments = '--max-depth 8' },
          },
        }, {
          {
            name = 'buffer',
            options = {
              get_bufnrs = function() return vim.api.nvim_list_bufs() end,
            },
          },
          { name = 'spell' },
        }),
      })

      if not as.nightly() then
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            sources = cmp.config.sources(
              { { name = 'nvim_lsp_document_symbol' } },
              { { name = 'buffer' } }
            ),
          },
        })

        cmp.setup.cmdline(':', {
          sources = cmp.config.sources({
            { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
            { name = 'path' },
            { name = 'cmdline_history', priority = 10, max_item_count = 5 },
          }),
        })
      end

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
        local bar = fn['copilot#TextQueuedForInsertion']()
        return fn.split(bar, [[[ .]\zs]])[1]
      end

      local function accept_line()
        fn['copilot#Accept']('')
        local bar = fn['copilot#TextQueuedForInsertion']()
        return fn.split(bar, [[[\n]\zs]])[1]
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
