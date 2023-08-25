local highlight, ui, k = as.highlight, as.ui, as.replace_termcodes
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
      local ellipsis = ui.icons.misc.ellipsis
      local MIN_MENU_WIDTH, MAX_MENU_WIDTH = 25, math.min(50, math.floor(vim.o.columns * 0.5))

      highlight.plugin('Cmp', {
        { CmpItemKindVariable = { link = 'Variable' } },
        { CmpItemAbbrMatchFuzzy = { inherit = 'CmpItemAbbrMatch', italic = true } },
        { CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' } },
        { CmpItemMenu = { inherit = 'Comment', italic = true } },
      })

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

      local function copilot() api.nvim_feedkeys(fn['copilot#Accept'](k('<Tab>')), 'n', true) end

      cmp.setup({
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        window = {
          completion = cmp.config.window.bordered({
            scrollbar = false,
            border = 'shadow',
            winhighlight = 'NormalFloat:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder',
          }),
          documentation = cmp.config.window.bordered({
            border = border,
            winhighlight = 'FloatBorder:FloatBorder',
          }),
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
          fields = { 'kind', 'abbr', 'menu' },
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = MAX_MENU_WIDTH,
            ellipsis_char = ellipsis,
            before = function(_, vim_item)
              local label, length = vim_item.abbr, api.nvim_strwidth(vim_item.abbr)
              if length < MIN_MENU_WIDTH then vim_item.abbr = label .. string.rep(' ', MIN_MENU_WIDTH - length) end
              return vim_item
            end,
            menu = {
              nvim_lsp = '[LSP]',
              nvim_lua = '[LUA]',
              emoji = '[EMOJI]',
              path = '[PATH]',
              neorg = '[NEORG]',
              luasnip = '[SNIP]',
              dictionary = '[DIC]',
              buffer = '[BUF]',
              spell = '[SPELL]',
              orgmode = '[ORG]',
              norg = '[NORG]',
              rg = '[RG]',
              git = '[GIT]',
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
