as.ftplugin_conf(
  'which-key',
  function(wk)
    wk.register({
      g = {
        name = '+todos',
        t = {
          name = '+status',
          u = 'task undone',
          p = 'task pending',
          d = 'task done',
          h = 'task on_hold',
          c = 'task cancelled',
          r = 'task recurring',
          i = 'task important',
        },
      },
      ['<localleader>t'] = { name = '+gtd', c = 'capture', v = 'views', e = 'edit' },
    })
  end
)

as.ftplugin_conf(
  { 'cmp', plugin = 'nvim-cmp' },
  function(cmp)
    cmp.setup.filetype('norg', {
      sources = cmp.config.sources({
        { name = 'neorg' },
        { name = 'dictionary' },
        { name = 'spell' },
        { name = 'emoji' },
      }, {
        { name = 'buffer' },
      }),
    })
  end
)
