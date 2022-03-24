return function()
  local dial = require 'dial.map'
  local augend = require 'dial.augend'
  local map = vim.keymap.set
  map('n', '<C-a>', dial.inc_normal(), { remap = false })
  map('n', '<C-x>', dial.dec_normal(), { remap = false })
  map('v', '<C-a>', dial.inc_visual(), { remap = false })
  map('v', '<C-x>', dial.dec_visual(), { remap = false })
  map('v', 'g<C-a>', dial.inc_gvisual(), { remap = false })
  map('v', 'g<C-x>', dial.dec_gvisual(), { remap = false })
  require('dial.config').augends:register_group {
    -- default augends used when no group name is specified
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.bool,
      augend.constant.new {
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      },
    },
    dep_files = {
      augend.semver.alias.semver,
    },
  }

  as.augroup('DialMaps', {
    {
      event = 'FileType',
      pattern = { 'yaml', 'toml' },
      command = function()
        map('n', '<C-a>', require('dial.map').inc_normal 'dep_files', { remap = true })
      end,
    },
  })
end
