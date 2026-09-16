local cwd = vim.fn.getcwd
local highlight = as.highlight
local border = as.ui.current.border
local icons = as.ui.icons.separators

local gitlinker = as.reqidx('gitlinker')

local function browser_open() return { action_callback = require('gitlinker.actions').open_in_browser } end

return {
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
    opts = {
      default_args = { DiffviewFileHistory = { '%' } },
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function()
          local opt = vim.opt_local
          opt.wrap, opt.list, opt.relativenumber = false, false, false
          opt.colorcolumn = ''
        end,
      },
      keymaps = {
        view = { q = '<Cmd>DiffviewClose<CR>' },
        file_panel = { q = '<Cmd>DiffviewClose<CR>' },
        file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
      },
    },
    config = function(_, opts)
      highlight.plugin('diffview', {
        { DiffAddedChar = { bg = 'NONE', fg = { from = 'diffAdded', attr = 'bg', alter = 0.3 } } },
        { DiffChangedChar = { bg = 'NONE', fg = { from = 'diffChanged', attr = 'bg', alter = 0.3 } } },
        { DiffviewStatusAdded = { link = 'DiffAddedChar' } },
        { DiffviewStatusModified = { link = 'DiffChangedChar' } },
        { DiffviewStatusRenamed = { link = 'DiffChangedChar' } },
        { DiffviewStatusUnmerged = { link = 'DiffChangedChar' } },
        { DiffviewStatusUntracked = { link = 'DiffAddedChar' } },
      })
      require('diffview').setup(opts)
    end,
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<localleader>gu',
        function() gitlinker.get_buf_range_url('n') end,
        desc = 'gitlinker: copy line to clipboard',
        mode = 'n',
      },
      {
        '<localleader>gu',
        function() gitlinker.get_buf_range_url('v') end,
        desc = 'gitlinker: copy range to clipboard',
        mode = 'v',
      },
      {
        '<localleader>go',
        function() gitlinker.get_repo_url(browser_open()) end,
        desc = 'gitlinker: open in browser',
      },
      {
        '<localleader>go',
        function() gitlinker.get_buf_range_url('n', browser_open()) end,
        desc = 'gitlinker: open current line in browser',
      },
      {
        '<localleader>go',
        function() gitlinker.get_buf_range_url('v', browser_open()) end,
        desc = 'gitlinker: open current selection in browser',
        mode = 'v',
      },
    },
    opts = {
      mappings = nil,
      callbacks = {
        ['github-work'] = function(url_data) -- Resolve the host for work repositories
          url_data.host = 'github.com'
          return require('gitlinker.hosts').get_github_type_url(url_data)
        end,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = icons.right_block },
        change = { text = icons.right_block },
        delete = { text = icons.right_block },
        topdelete = { text = icons.right_block },
        changedelete = { text = icons.right_block },
        untracked = { text = icons.light_shade_block },
      },
      current_line_blame = not cwd():match('dotfiles'),
      current_line_blame_formatter = ' <author>, <author_time> · <summary>',
      preview_config = { border = border },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        --- Every mapping here belongs to the attached buffer. Using the global `map`
        --- leaked them into buffers gitsigns was never attached to.
        local function bmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          map(mode, l, r, opts)
        end

        bmap('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage' })
        bmap('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'preview current hunk' })
        bmap('n', '<leader>hb', gs.toggle_current_line_blame, { desc = 'toggle current line blame' })
        bmap('n', '<leader>hd', gs.toggle_deleted, { desc = 'show deleted lines' })
        bmap('n', '<leader>hw', gs.toggle_word_diff, { desc = 'toggle word diff' })
        bmap('n', '<localleader>gw', gs.stage_buffer, { desc = 'stage entire buffer' })
        bmap('n', '<localleader>gre', gs.reset_buffer, { desc = 'reset entire buffer' })
        bmap('n', '<localleader>gbl', gs.blame_line, { desc = 'blame current line' })
        bmap('n', '<leader>lm', function() gs.setqflist('all') end, { desc = 'list modified in quickfix' })
        bmap({ 'n', 'v' }, '<leader>hs', '<Cmd>Gitsigns stage_hunk<CR>', { desc = 'stage hunk' })
        bmap({ 'n', 'v' }, '<leader>hr', '<Cmd>Gitsigns reset_hunk<CR>', { desc = 'reset hunk' })
        bmap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select hunk' })

        bmap('n', ']h', function() gs.nav_hunk('next') end, { desc = 'go to next git hunk' })
        bmap('n', '[h', function() gs.nav_hunk('prev') end, { desc = 'go to previous git hunk' })
      end,
    },
  },
}
