local highlight = as.highlight

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    highlight.plugin('whichkey', {
      theme = {
        ['*'] = { { WhichkeyFloat = { link = 'NormalFloat' } } },
        horizon = { { WhichKeySeparator = { link = 'Todo' } } },
      },
    })

    local wk = require('which-key')
    wk.setup({
      plugins = { spelling = { enabled = true } },
      win = { border = as.ui.current.border },
      preset = 'modern',
    })

    wk.add({
      { ']', group = 'next' },
      { '[', group = 'prev' },
      { 'gc', group = 'comment' },
      { 'gb', group = 'bufferline' },
      { '<leader>a', group = 'projectionist' },
      { '<leader>c', group = 'code-action' },
      { '<leader>d', group = 'debugprint' },
      { '<leader>m', group = 'marks' },
      { '<leader>f', group = 'picker' },
      { '<leader>h', group = 'git-action' },
      { '<leader>n', group = 'new' },
      { '<leader>j', group = 'jump' },
      { '<leader>p', group = 'packages' },
      { '<leader>q', group = 'quit' },
      { '<leader>l', group = 'list' },
      { '<leader>i', group = 'iswap' },
      { '<leader>e', group = 'edit' },
      { '<leader>r', group = 'lsp-refactor' },
      { '<leader>o', group = 'only' },
      { '<leader>t', group = 'tab' },
      { '<leader>s', group = 'source/swap' },
      { '<leader>y', group = 'yank' },
      { '<leader>O', group = 'options' },
      { '<localleader>', group = 'local leader' },
      { '<localleader>d', group = 'dap' },
      { '<localleader>g', group = 'git' },
      { '<localleader>o', group = 'neorg' },
      { '<localleader>t', group = 'neotest' },
      { '<localleader>w', group = 'window' },
    })
  end,
}
