return function()
  require('octo').setup()
  require('which-key').register({
    O = {
      name = '+octo',
      l = {
        name = '+list',
        i = { '<Cmd>Octo issue list<CR>', 'issues' },
        p = { '<Cmd>Octo pr list<CR>', 'pull requests' },
      },
    },
  }, { prefix = '<leader>' })

  as.augroup('OctoFT', {
    {
      event = 'FileType',
      pattern = 'octo',
      command = function()
        require('as.highlights').clear_hl 'OctoEditable'
        as.nnoremap('q', '<Cmd>Bwipeout<CR>', { buffer = 0 })
      end,
    },
  })
end
