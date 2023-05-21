if not as then return end
as.ftplugin_conf({
  ['nvim-surround'] = function(surround)
    surround.buffer_setup({
      surrounds = {
        i = {
          add = function() return { { '{#if condition}' }, { '{/if}' } } end,
        },
      },
    })
  end,
})
