return function()
  as.nnoremap('<localleader>oc', '<Cmd>Neorg gtd capture<CR>')
  as.nnoremap('<localleader>ov', '<Cmd>Neorg gtd views<CR>')

  require('neorg').setup({
    configure_parsers = true,
    load = {
      ['external.kanban'] = {},
      ['core.defaults'] = {},
      ['core.integrations.telescope'] = {},
      ['core.keybinds'] = {
        config = {
          default_keybinds = true,
          neorg_leader = '<localleader>',
          hook = function(keybinds)
            keybinds.unmap('norg', 'n', '<C-s>')
            keybinds.map_event('norg', 'n', '<C-x>', 'core.integrations.telescope.find_linkable')
          end,
        },
      },
      ['core.norg.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.norg.concealer'] = {},
      ['core.norg.dirman'] = {
        config = {
          workspaces = {
            notes = vim.fn.expand('$SYNC_DIR/neorg/main/'),
            tasks = vim.fn.expand('$SYNC_DIR/neorg/tasks/'),
          },
        },
      },
      ['core.gtd.base'] = {
        config = {
          workspace = 'tasks',
        },
      },
    },
  })
end
