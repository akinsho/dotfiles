local cwd = vim.fn.getcwd
local highlight = as.highlight
local border = as.style.current.border
local icons = as.style.icons.separators

local function linker() return require('gitlinker') end
local function neogit() return require('neogit') end
local function browser_open()
  return { action_callback = require('gitlinker.actions').open_in_browser }
end

return {
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<localleader>gs', function() neogit().open() end, 'open status buffer' },
      { '<localleader>gc', function() neogit().open({ 'commit' }) end, 'open commit buffer' },
      { '<localleader>gl', function() neogit().popups.pull.create() end, 'open pull popup' },
      { '<localleader>gp', function() neogit().popups.push.create() end, 'open push popup' },
    },
    opts = {
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
    },
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
      highlight.plugin('diffview', {
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
        default_args = { DiffviewFileHistory = { '%' } },
        enhanced_diff_hl = true,
        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.colorcolumn = ''
            vim.opt_local.relativenumber = false
          end,
        },
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
    opts = {
      signs = {
        add = { text = icons.right_block },
        change = { text = icons.right_block },
        delete = { text = icons.right_block },
        topdelete = { text = icons.right_block },
        changedelete = { text = icons.right_block },
        untracked = { text = icons.medium_shade_block },
      },
      numhl = false,
      word_diff = false,
      -- Experimental ------------------------------------------------------------------------------
      _threaded_diff = true,
      _extmark_signs = false,
      _signs_staged_enable = true,
      ----------------------------------------------------------------------------------------------
      current_line_blame = not cwd():match('personal') and not cwd():match('dotfiles'),
      current_line_blame_formatter = ' <author>, <author_time> · <summary>',
      preview_config = { border = border },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        as.nnoremap('<leader>hu', gs.undo_stage_hunk, 'undo stage')
        as.nnoremap('<leader>hp', gs.preview_hunk_inline, 'preview current hunk')
        as.nnoremap('<leader>hb', gs.toggle_current_line_blame, 'toggle current line blame')
        as.nnoremap('<leader>hd', gs.toggle_deleted, 'show deleted lines')
        as.nnoremap('<leader>hw', gs.toggle_word_diff, 'toggle word diff')
        as.nnoremap('<localleader>gw', gs.stage_buffer, 'stage entire buffer')
        as.nnoremap('<localleader>gre', gs.reset_buffer, 'reset entire buffer')
        as.nnoremap('<localleader>gbl', gs.blame_line, 'blame current line')
        as.nnoremap('<leader>lm', function() gs.setqflist('all') end, 'list modified in quickfix')
        map({ 'n', 'v' }, '<leader>hs', '<Cmd>Gitsigns stage_hunk<CR>', { desc = 'stage hunk' })
        map({ 'n', 'v' }, '<leader>hr', '<Cmd>Gitsigns reset_hunk<CR>', { desc = 'reset hunk' })
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select hunk' })

        as.nnoremap('[h', function()
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'go to next git hunk' })

        as.nnoremap(']h', function()
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = 'go to previous git hunk' })
      end,
    },
  },
}
