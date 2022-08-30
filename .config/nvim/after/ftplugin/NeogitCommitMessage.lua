vim.wo.list = false
vim.wo.number = false
vim.wo.relativenumber = false
vim.bo.spelllang = 'en_gb'
--  Set color column at maximum commit summary length
vim.wo.colorcolumn = '50,72'

if not as then return end
as.ftplugin_conf(
  'cmp',
  function(cmp)
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
)
