local M = {}

function M.setup()
  require('which-key').register {
    ['<localleader>g'] = {
      s = 'neogit: open status buffer',
      c = 'neogit: open commit buffer',
      l = 'neogit: open pull popup',
      p = 'neogit: open push popup',
    },
  }
end

function M.config()
  local neogit = require 'neogit'
  neogit.setup {
    disable_signs = false,
    disable_hint = true,
    disable_commit_confirmation = true,
    disable_builtin_notifications = true,
    disable_insert_on_commit = false,
    signs = {
      section = { '', '' }, -- "", ""
      item = { '▸', '▾' },
      hunk = { '樂', '' },
    },
    integrations = {
      diffview = true,
    },
  }
  as.nnoremap('<localleader>gs', function()
    neogit.open()
  end)
  as.nnoremap('<localleader>gc', function()
    neogit.open { 'commit' }
  end)
  as.nnoremap('<localleader>gl', neogit.popups.pull.create)
  as.nnoremap('<localleader>gp', neogit.popups.push.create)
end

return M
