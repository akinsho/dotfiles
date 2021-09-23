return function()
  local api = vim.api
  local t = as.replace_termcodes
  local cmp = require 'cmp'

  local function feed(key, mode)
    api.nvim_feedkeys(t(key), mode or '', true)
  end

  local function get_luasnip()
    local ok, luasnip = as.safe_require('luasnip', { silent = true })
    if not ok then
      return nil
    end
    return luasnip
  end

  local function tab(_)
    local luasnip = get_luasnip()
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip and luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      feed '<Plug>(Tabout)'
    end
  end

  local function shift_tab(_)
    local luasnip = get_luasnip()
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      feed '<Plug>(TaboutBack)'
    end
  end

  cmp.setup {
    experimental = {
      ghost_text = false,
      custom_menu = true,
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
      deprecated = true,
      format = function(entry, vim_item)
        vim_item.kind = as.style.lsp.kinds[vim_item.kind]
        -- FIXME: automate this using a regex to normalise names
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
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
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'spell' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'neorg' },
      { name = 'orgmode' },
    },
  }
end
