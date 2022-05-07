return function()
  local cmp = require('cmp')
  local h = require('as.highlights')

  local api = vim.api
  local t = as.replace_termcodes
  local border = as.style.current.border
  local lsp_hls = as.style.lsp.kind_highlights

  local kind_hls = {}
  for key, _ in pairs(lsp_hls) do
    kind_hls['CmpItemKind' .. key] = { foreground = { from = lsp_hls[key] } }
  end

  h.plugin(
    'Cmp',
    vim.tbl_extend('force', {
      CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = false },
      CmpItemMenu = { inherit = 'NonText', italic = false, bold = false },
      CmpItemAbbrMatch = { foreground = { from = 'Keyword' } },
      CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' },
      CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = 'Keyword' } },
    }, kind_hls)
  )

  local function tab(fallback)
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_next_item()
    elseif ok and luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_prev_item()
    elseif ok and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end

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
    preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered(cmp_window),
      documentation = cmp.config.window.bordered(cmp_window),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<c-h>'] = cmp.mapping(function()
        api.nvim_feedkeys(vim.fn['copilot#Accept'](t('<Tab>')), 'n', true)
      end),
      ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
      ['<C-q>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- If nothing is selected don't complete
    },
    formatting = {
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = as.style.lsp.kinds[vim_item.kind]
        local name = entry.source.name

        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          emoji = '[Emoji]',
          path = '[Path]',
          calc = '[Calc]',
          neorg = '[Neorg]',
          orgmode = '[Org]',
          cmp_tabnine = '[TN]',
          luasnip = '[Luasnip]',
          buffer = '[Buffer]',
          spell = '[Spell]',
          cmdline = '[Command]',
          rg = '[Rg]',
          git = '[Git]',
        })[name]

        return vim_item
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
      { name = 'spell' },
    }),
  })

  cmp.setup.filetype('norg', {
    sources = cmp.config.sources({
      { name = 'neorg' },
    }, {
      { name = 'buffer' },
    }),
  })

  cmp.setup.filetype('NeogitCommitMessage', {
    sources = cmp.config.sources({
      { name = 'git' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    }),
  })

  local search_sources = {
    view = {
      entries = { name = 'custom', direction = 'bottom_up' },
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.cmdline('/', search_sources)
  cmp.setup.cmdline('?', search_sources)
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = 'path' },
    }),
  })
end
