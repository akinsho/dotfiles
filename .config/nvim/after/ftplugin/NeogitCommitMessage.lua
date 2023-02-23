local opt, highlight = vim.opt_local, as.highlight

opt.list = false
opt.spelllang = 'en_gb'

-- Schedule this call as highlights are not set correctly if there is not a delay
vim.schedule(
  function()
    highlight.set_winhl('gitcommit', 0, { { VirtColumn = { fg = { from = 'Variable' } } } })
  end
)

if not as then return end
as.ftplugin_conf({
  ['nvim-treesitter.parsers'] = function(parsers)
    -- make sure neogit commits use the treesitter parser
    -- awaiting https://github.com/nvim-treesitter/nvim-treesitter/pull/4296
    parsers.filetype_to_parsername['NeogitCommitMessage'] = 'gitcommit'
  end,
  cmp = function(cmp)
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
  end,
})
