return function()
  local fn = vim.fn
  local t = as.replace_termcodes
  local cmp = require 'cmp'
  require('cmp_nvim_lsp').setup()

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
      vim.fn.feedkeys(t '<Tab>', 'n')
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
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = as.lsp.icons[vim_item.kind]
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
