return function()
  local fn = vim.fn
  local t = as.replace_termcodes
  local fmt = string.format
  local cmp = require 'cmp'

  local check_back_space = function()
    local col = fn.col '.' - 1
    return col == 0 or fn.getline('.'):sub(col, col):match '%s' ~= nil
  end

  local function tab(fallback)
    local luasnip = require 'luasnip'
    if fn.pumvisible() == 1 then
      return fn.feedkeys(t '<C-n>', 'n')
    elseif luasnip and luasnip.expand_or_jumpable() then
      return fn.feedkeys(t '<Plug>luasnip-expand-or-jump', '')
    elseif check_back_space() then
      fn.feedkeys(t '<Tab>', 'n')
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    local luasnip = require 'luasnip'
    if fn.pumvisible() == 1 then
      fn.feedkeys(t '<C-p>', 'n')
    elseif luasnip and luasnip.jumpable(-1) then
      fn.feedkeys(t '<Plug>luasnip-jump-prev', '')
    else
      fallback()
    end
  end

  cmp.setup {
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
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          emoji = '[Emoji]',
          path = '[Path]',
          calc = '[Calc]',
          luasnip = '[Luasnip]',
          buffer = '[Buffer]',
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
      { name = 'nvim_lua' },
      { name = 'path' },
      { name = 'buffer' },
    },
  }
end
