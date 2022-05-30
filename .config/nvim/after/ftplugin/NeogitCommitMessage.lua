vim.opt_local.list = false
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_gb'
--  Set color column at maximum commit summary length
vim.opt_local.colorcolumn = '50,72'

if as.plugin_loaded('nvim-cmp') then
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
end
