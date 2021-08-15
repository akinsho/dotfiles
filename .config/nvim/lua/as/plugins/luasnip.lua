return function()
  local ls = require 'luasnip'
  local snippet = ls.snippet
  local text = ls.text_node
  local insert = ls.insert_node
  local types = require 'luasnip.util.types'

  ls.config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { 'choiceNode', 'Comment' } },
        },
      },
    },
    enable_autosnippets = true,
  }
  local opts = { expr = true }
  as.imap('<c-j>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-j>'", opts)
  as.imap('<c-k>', "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev': '<c-k>'", opts)
  as.snoremap('<c-j>', function()
    ls.jump(1)
  end)
  as.snoremap('<c-k>', function()
    ls.jump(-1)
  end)

  ls.snippets = {
    lua = {
      snippet({
        trig = 'use',
        name = 'packer use',
        dscr = {
          'packer use plugin block',
          'e.g.',
          "use {'author/plugin'}",
        },
      }, {
        text "use { '",
        insert(1, 'author/plugin'),
        text "' ",
        insert(2, {
          ', config = function()',
          '',
          'end',
        }),
        text '}',
      }),
    },
  }

  -- NOTE: load external snippets last so they are not overruled by ls.snippets
  require('luasnip.loaders.from_vscode').load { paths = './snippets/textmate' }
end
