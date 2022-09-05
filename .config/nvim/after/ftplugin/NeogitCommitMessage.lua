vim.opt_local.list = false
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.bo.spelllang = 'en_gb'
--  Set color column at maximum commit summary length
vim.opt_local.colorcolumn = '50,72'

-- Schedule this call as highlights are not set correctly if there is not a delay
vim.schedule(
  function()
    require('as.highlights').win_hl.set('gitcommit', 0, {
      { VirtColumn = { fg = { from = 'Variable' } } },
    })
  end
)

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
