execute 'source '. expand('<sfile>:p:h') . '/gitcommit.vim'

if v:lua.as.plugin_loaded('nvim-cmp')
lua << EOF
local cmp = require('cmp')
cmp.setup.filetype('NeogitCommitMessage', {
  sources = cmp.config.sources({
    { name = 'git' },
    { name = 'luasnip' },
    { name = 'dictionary' },
    { name = 'spell' },
  }, {
    { name = 'buffer' },
  }),
})
EOF
endif
