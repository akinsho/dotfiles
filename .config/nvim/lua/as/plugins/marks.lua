return function()
  require('as.highlights').plugin('marks', {
    { MarkSignHL = { link = 'Directory' } },
    { MarkSignNumHL = { link = 'Directory' } },
  })
  require('which-key').register({
    m = {
      name = '+marks',
      b = { '<Cmd>MarksListBuf<CR>', 'list buffer' },
      g = { '<Cmd>MarksQFListGlobal<CR>', 'list global' },
      ['0'] = { '<Cmd>BookmarksQFList 0<CR>', 'list bookmark' },
    },
  }, { prefix = '<leader>' })

  require('marks').setup({
    force_write_shada = false, -- This can cause data loss
    excluded_filetypes = { 'NeogitStatus', 'NeogitCommitMessage', 'toggleterm' },
    bookmark_0 = {
      sign = '⚑',
      virt_text = '',
    },
    mappings = {
      annotate = 'm?',
    },
  })
end
