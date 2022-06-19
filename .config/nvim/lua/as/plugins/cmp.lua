return function()
  local cmp = require('cmp')
  local h = require('as.highlights')

  local fn = vim.fn
  local api = vim.api
  local fmt = string.format
  local t = as.replace_termcodes
  local border = as.style.current.border
  local lsp_hls = as.style.lsp.highlights
  local ellipsis = as.style.icons.misc.ellipsis

  -- Make the source information less prominent
  local faded = h.alter_color(h.get('Pmenu', 'bg'), 30)

  local kind_hls = as.fold(
    function(accum, value, key)
      accum['CmpItemKind' .. key] = { foreground = { from = value } }
      return accum
    end,
    lsp_hls,
    {
      CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = false },
      CmpItemMenu = { foreground = faded, italic = true, bold = false },
      CmpItemAbbrMatch = { foreground = { from = 'Keyword' } },
      CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' },
      CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = 'Keyword' } },
    }
  )

  h.plugin('Cmp', kind_hls)

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
      ['<Tab>'] = cmp.mapping(tab, { 'i', 's', 'c' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's', 'c' }),
      ['<c-h>'] = cmp.mapping(function()
        api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true)
      end),
      ['<C-q>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- If nothing is selected don't complete
    },
    formatting = {
      deprecated = true,
      fields = { 'abbr', 'kind', 'menu' },
      format = function(entry, vim_item)
        local MAX = math.floor(vim.o.columns / 0.4)
        vim_item.abbr = #vim_item.abbr >= MAX and string.sub(vim_item.abbr, 1, MAX) .. ellipsis
          or vim_item.abbr
        vim_item.kind = fmt('%s %s', as.style.current.lsp_icons[vim_item.kind], vim_item.kind)
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
    }, {
      {
        name = 'buffer',
        options = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(api.nvim_list_wins()) do
              bufs[api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      { name = 'spell' },
    }),
  })

  local search_sources = {
    view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
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
      { name = 'cmdline_history' },
      { name = 'path' },
    }),
  })
end
