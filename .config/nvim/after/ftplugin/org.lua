vim.opt_local.signcolumn = 'yes'

if not as then return end

as.ftplugin_conf({
  ufo = function(ufo) ufo.detach() end,
  cmp = function(cmp)
    cmp.setup.filetype('org', {
      sources = cmp.config.sources({
        { name = 'orgmode' },
        { name = 'dictionary' },
        { name = 'spell' },
        { name = 'emoji' },
      }, {
        { name = 'buffer' },
      }),
    })
  end,
  ['nvim-surround'] = function(surround)
    surround.buffer_setup({
      surrounds = {
        l = {
          add = function()
            return {
              { '[[' .. vim.fn.getreg('*') .. '][' },
              { ']]' },
            }
          end,
        },
      },
    })
  end,
})
