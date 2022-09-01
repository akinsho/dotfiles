return function()
  local neogit = require('neogit')
  neogit.setup({
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
  })
  as.nnoremap('<localleader>gs', function() neogit.open() end, 'neogit: open status buffer')
  as.nnoremap('<localleader>gc', function() neogit.open({ 'commit' }) end,'neogit: open commit buffer')
  as.nnoremap('<localleader>gl', neogit.popups.pull.create, 'neogit: open pull popup')
  as.nnoremap('<localleader>gp', neogit.popups.push.create, 'neogit: open push popup')
end
