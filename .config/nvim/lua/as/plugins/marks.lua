return function()
  require('as.highlights').plugin('marks', { MarkSignHL = { foreground = 'Red' } })
  require('which-key').register({
    m = {
      name = '+marks',
      b = { '<Cmd>MarksListBuf<CR>', 'list buffer' },
      g = { '<Cmd>MarksQFListGlobal<CR>', 'list global' },
      ['0'] = { '<Cmd>BookmarksQFList 0<CR>', 'list bookmark' },
    },
  }, { prefix = '<leader>' })
  require('marks').setup {
    force_write_shada = true,
    excluded_filetypes = { 'NeogitStatus', 'NeogitCommitMessage', 'toggleterm' },
    bookmark_0 = {
      sign = '⚑',
      virt_text = 'bookmarks',
    },
  }
end
