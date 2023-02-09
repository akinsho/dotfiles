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
    config = function()
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
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<localleader>gd', '<Cmd>DiffviewOpen<CR>', desc = 'diffview: open', mode = 'n' },
      { 'gh', [[:'<'>DiffviewFileHistory<CR>]], desc = 'diffview: file history', mode = 'v' },
      {
        '<localleader>gh',
        '<Cmd>DiffviewFileHistory<CR>',
        desc = 'diffview: file history',
        mode = 'n',
      },
    },
    config = function()
      as.highlight.plugin('diffview', {
        { DiffAddedChar = { bg = 'NONE', fg = { from = 'diffAdded', attr = 'bg', alter = 30 } } },
        {
          DiffChangedChar = { bg = 'NONE', fg = { from = 'diffChanged', attr = 'bg', alter = 30 } },
        },
        { DiffviewStatusAdded = { link = 'DiffAddedChar' } },
        { DiffviewStatusModified = { link = 'DiffChangedChar' } },
        { DiffviewStatusRenamed = { link = 'DiffChangedChar' } },
        { DiffviewStatusUnmerged = { link = 'DiffChangedChar' } },
        { DiffviewStatusUntracked = { link = 'DiffAddedChar' } },
      })
      require('diffview').setup({
        default_args = {
          DiffviewFileHistory = { '%' },
        },
        hooks = {
          diff_buf_read = function()
            vim.wo.wrap = false
            vim.wo.list = false
            vim.wo.colorcolumn = ''
          end,
        },
        enhanced_diff_hl = true,
        keymaps = {
          view = { q = '<Cmd>DiffviewClose<CR>' },
          file_panel = { q = '<Cmd>DiffviewClose<CR>' },
          file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
        },
      })
    end,
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
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      local cwd = vim.fn.getcwd()
      local right_block = '🮉'
      require('gitsigns').setup({
        signs = {
          add = { hl = 'GitSignsAdd', text = right_block },
          change = { hl = 'GitSignsChange', text = right_block },
          delete = { hl = 'GitSignsDelete', text = right_block },
          topdelete = { hl = 'GitSignsDelete', text = right_block },
          changedelete = { hl = 'GitSignsChange', text = right_block },
        },
        _threaded_diff = true,
        _extmark_signs = false,
        _signs_staged_enable = true,
        word_diff = false,
        current_line_blame = not cwd:match('personal') and not cwd:match('dotfiles'),
        current_line_blame_formatter = ' <author>, <author_time> · <summary>',
        numhl = false,
        preview_config = { border = as.style.current.border },
        on_attach = function()
          local gs = package.loaded.gitsigns

          local function qf_list_modified() gs.setqflist('all') end

          as.nnoremap('<leader>hu', gs.undo_stage_hunk, 'undo stage')
          as.nnoremap('<leader>hp', gs.preview_hunk_inline, 'preview current hunk')
          as.nnoremap('<leader>hs', gs.stage_hunk, 'stage current hunk')
          as.nnoremap('<leader>hr', gs.reset_hunk, 'reset current hunk')
          as.nnoremap('<leader>hb', gs.toggle_current_line_blame, 'toggle current line blame')
          as.nnoremap('<leader>hd', gs.toggle_deleted, 'show deleted lines')
          as.nnoremap('<leader>hw', gs.toggle_word_diff, 'gitsigns: toggle word diff')
          as.nnoremap('<localleader>gw', gs.stage_buffer, 'gitsigns: stage entire buffer')
          as.nnoremap('<localleader>gre', gs.reset_buffer, 'gitsigns: reset entire buffer')
          as.nnoremap('<localleader>gbl', gs.blame_line, 'gitsigns: blame current line')
          as.nnoremap('<leader>lm', qf_list_modified, 'gitsigns: list modified in quickfix')

          -- Navigation
          as.nnoremap('[h', function()
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'go to next git hunk' })

          as.nnoremap(']h', function()
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, desc = 'go to previous git hunk' })

          as.vnoremap(
            '<leader>hs',
            function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
          )
          as.vnoremap(
            '<leader>hr',
            function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
          )

          vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end,
  },
}
