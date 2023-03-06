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
      window = { border = as.ui.current.border },
      layout = { align = 'center' },
    })

    wk.register({
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      g = {
        c = { name = '+comment' },
        b = { name = '+bufferline' },
      },
      ['<leader>'] = {
        a = { name = '+projectionist' },
        b = 'buffer management hydra',
        c = { name = '+code-action' },
        d = { name = '+debug/database', h = 'dap hydra' },
        f = { name = '+telescope' },
        h = { name = '+git-action' },
        z = 'window scroll hydra',
        n = { name = '+new' },
        j = { name = '+jump' },
        p = { name = '+packages' },
        q = { name = '+quit' },
        l = { name = '+list' },
        i = { name = '+iswap' },
        e = { name = '+edit' },
        r = { name = '+lsp-refactor' },
        o = { name = '+only' },
        t = { name = '+tab' },
        s = { name = '+source/swap' },
        y = { name = '+yank' },
      },
      ['<localleader>'] = {
        name = 'local leader',
        d = { name = '+dap' },
        g = { name = '+git' },
        G = 'Git hydra',
        o = { name = '+neorg' },
        t = { name = '+neotest' },
        w = { name = '+window' },
      },
    })
  end,
}
