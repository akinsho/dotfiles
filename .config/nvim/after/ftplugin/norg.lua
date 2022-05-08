if as.plugin_loaded('which-key.nvim') then
  local wk = require('which-key')
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
    ['<localleader>t'] = {
      name = '+gtd',
      c = 'capture',
      v = 'views',
      e = 'edit',
    },
  })
end

if as.plugin_loaded('nvim-cmp') then
  local cmp = require('cmp')
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
