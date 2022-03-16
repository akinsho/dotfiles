return function()
  local api = vim.api
  local cmp = require 'cmp'
  local h = require 'as.highlights'
  local t = as.replace_termcodes

  local keyword_fg = h.get_hl('Keyword', 'fg')

  local lsp_hls = as.style.lsp.kind_highlights
  local kind_hls = vim.tbl_map(function(key)
    return { 'CmpItemKind' .. key, { foreground = h.get_hl(lsp_hls[key], 'fg') } }
  end, vim.tbl_keys(lsp_hls))

  h.plugin(
    'Cmp',
    { 'CmpItemAbbr', { foreground = 'fg', background = 'NONE', italic = false, bold = false } },
    { 'CmpItemMenu', { inherit = 'NonText', italic = false, bold = false } },
    { 'CmpItemAbbrMatch', { foreground = keyword_fg } },
    { 'CmpItemAbbrDeprecated', { strikethrough = true, inherit = 'Comment' } },
    { 'CmpItemAbbrMatchFuzzy', { italic = true, foreground = keyword_fg } },
    unpack(kind_hls)
  )

  local function feed(key, mode)
    api.nvim_feedkeys(t(key), mode or '', true)
  end

  local function tab(fallback)
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_next_item()
    elseif ok and luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif api.nvim_get_mode().mode == 'c' then
      fallback()
    else
      feed '<Plug>(Tabout)'
    end
  end

  local function shift_tab(fallback)
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_prev_item()
    elseif ok and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    elseif api.nvim_get_mode().mode == 'c' then
      fallback()
    else
      feed '<Plug>(Tabout)'
    end
  end

  cmp.setup {
    window = {
      completion = {
        -- TODO: consider 'shadow', and tweak the winhighlight
        border = 'rounded',
      },
      documentation = {
        border = 'rounded',
      },
    },
    experimental = {
      ghost_text = false, -- disable whilst using copilot
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<c-h>'] = cmp.mapping(function()
        vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](t '<Tab>'), 'n', true)
      end),
      ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-q>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    formatting = {
      deprecated = true,
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.kind = as.style.lsp.kinds[vim_item.kind]
        local name = entry.source.name
        local completion = entry.completion_item.data
        -- FIXME: automate this using a regex to normalise names
        local menu = ({
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
          cmp_git = '[Git]',
        })[name]

        if name == 'cmp_tabnine' then
          if completion and completion.detail then
            menu = completion.detail .. ' ' .. menu
          end
          vim_item.kind = ''
        end
        vim_item.menu = menu
        return vim_item
      end,
    },
    documentation = {
      border = 'rounded',
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'cmp_tabnine' },
      { name = 'spell' },
      { name = 'neorg' },
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.filetype('NeogitCommitMessage', {
    sources = cmp.config.sources({
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    }),
  })

  local search_sources = {
    sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.cmdline('/', search_sources)
  cmp.setup.cmdline('?', search_sources)
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources {
      { name = 'cmdline' },
    },
  })
end
