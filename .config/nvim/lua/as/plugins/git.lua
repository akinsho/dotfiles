


local function neogit_config()
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
  as.nnoremap(
    '<localleader>gc',
    function() neogit.open({ 'commit' }) end,
    'neogit: open commit buffer'
  )
  as.nnoremap('<localleader>gl', neogit.popups.pull.create, 'neogit: open pull popup')
  as.nnoremap('<localleader>gp', neogit.popups.push.create, 'neogit: open push popup')
end

local function linker() return require('gitlinker') end
local function browser_open()
  return { action_callback = require('gitlinker.actions').open_in_browser }
end

return {
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = neogit_config,
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<localleader>gu',
        function() linker().get_buf_range_url('n') end,
        desc = 'gitlinker: copy line to clipboard',
      },
      {
        '<localleader>gu',
        function() linker().get_buf_range_url('v') end,
        desc = 'gitlinker: copy range to clipboard',
      },

      {
        '<localleader>go',
        function() linker().get_repo_url(browser_open()) end,
        desc = 'gitlinker: open in browser',
      },
      {
        '<localleader>go',
        function() linker().get_buf_range_url('n', browser_open()) end,
        desc = 'gitlinker: open current line in browser',
      },
      {
        '<localleader>go',
        function() linker().get_buf_range_url('v', browser_open()) end,
        desc = 'gitlinker: open current selection in browser',
      },
    },
    opts = { mappings = nil },
  },
}
