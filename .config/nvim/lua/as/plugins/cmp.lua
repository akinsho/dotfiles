return function()
  local fn = vim.fn
  local api = vim.api
  local t = as.replace_termcodes
  local fmt = string.format
  local cmp = require 'cmp'

  local function has_words_before()
    if vim.bo.buftype == 'prompt' then
      return false
    end
    local line, col = unpack(api.nvim_win_get_cursor(0))
    return col ~= 0
      and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
  end

  local function feed(key, mode)
    mode = mode or ''
    api.nvim_feedkeys(t(key), mode, true)
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
    if fn.pumvisible() == 1 then
      feed('<C-n>', 'n')
    elseif luasnip and luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      feed '<Plug>(Tabout)'
    end
  end

  local function shift_tab(_)
    local luasnip = get_luasnip()
    if fn.pumvisible() == 1 then
      feed('<C-p>', 'n')
    elseif luasnip and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      feed '<Plug>(TaboutBack)'
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
  -- as.augroup('CmpFiletypes', {
  --   {
  --     events = { 'Filetype' },
  --     targets = { 'lua' },
  --     command = function()
  --       cmp.setup.buffer {
  --         sources = {
  --           { name = 'nvim_lua' },
  --           { name = 'buffer' },
  --         },
  --       }
  --     end,
  --   },
  -- })
end
