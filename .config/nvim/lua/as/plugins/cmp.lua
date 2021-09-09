return function()
  local fn = vim.fn
  local api = vim.api
  local t = as.replace_termcodes
  local fmt = string.format
  local cmp = require 'cmp'

  local function get_luasnip()
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if not ok then
      return nil
    end
    return luasnip
  end

  local function tab(fallback)
    local luasnip = get_luasnip()
    if fn.pumvisible() == 1 then
      return api.nvim_feedkeys(t '<C-n>', 'n', true)
    elseif luasnip and luasnip.expand_or_jumpable() then
      return api.nvim_feedkeys(t '<Plug>luasnip-expand-or-jump', '', true)
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    local luasnip = get_luasnip()
    if fn.pumvisible() == 1 then
      api.nvim_feedkeys(t '<C-p>', 'n', true)
    elseif luasnip and luasnip.jumpable(-1) then
      api.nvim_feedkeys(t '<Plug>luasnip-jump-prev', '', true)
    else
      fallback()
    end
  end

  cmp.setup {
    experimental = {
      ghost_text = false,
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's' }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = fmt('%s %s', as.style.lsp.kinds[vim_item.kind], vim_item.kind)
        -- FIXME: automate this using a regex to normalise names
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          emoji = '[Emoji]',
          path = '[Path]',
          calc = '[Calc]',
          neorg = '[Neorg]',
          orgmode = '[Org]',
          luasnip = '[Luasnip]',
          buffer = '[Buffer]',
          spell = '[Spell]',
        })[entry.source.name]
        return vim_item
      end,
    },
    documentation = {
      border = 'rounded',
    },
    sources = {
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'spell' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'neorg' },
      { name = 'orgmode' },
    },
  }

  as.augroup('CmpFiletypes', {
    {
      events = { 'Filetype' },
      targets = { 'lua' },
      command = function()
        cmp.setup.buffer {
          sources = {
            { name = 'nvim_lua' },
            { name = 'buffer' },
          },
        }
      end,
    },
  })
end
