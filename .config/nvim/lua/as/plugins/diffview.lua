local M = {}

function M.setup()
  as.nnoremap('<localleader>gd', '<Cmd>DiffviewOpen<CR>', 'diffview: open')
  as.nnoremap('<localleader>gh', '<Cmd>DiffviewFileHistory<CR>', 'diffview: file history')
  as.vnoremap('gh', [[:'<'>DiffviewFileHistory<CR>]], 'diffview: file history')
end

function M.config()
  require('as.highlights').plugin('diffview', {
    { DiffAddedChar = { bg = 'NONE', fg = { from = 'diffAdded', attr = 'bg', alter = 30 } } },
    { DiffChangedChar = { bg = 'NONE', fg = { from = 'diffChanged', attr = 'bg', alter = 30 } } },
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
end

return M
