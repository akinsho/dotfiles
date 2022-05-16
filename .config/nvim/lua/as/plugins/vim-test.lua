local M = {}

function M.setup()
  require('which-key').register({
    ['<localleader>t'] = {
      name = '+vim-test',
      f = { '<cmd>TestFile<CR>', 'test: file' },
      n = { '<cmd>TestNearest<CR>', 'test: nearest' },
      s = { '<cmd>TestSuite<CR>', 'test: suite' },
    },
  })
end

function M.config()
  local t = require('toggleterm')
  local terms = require('toggleterm.terminal')

  vim.g['test#custom_strategies'] = {
    toggleterm = function(cmd)
      t.exec(cmd, nil, nil, nil, 'float')
    end,
    toggleterm_close = function(cmd)
      local term_id = 0
      t.exec(cmd, term_id)
      terms.get_or_create_term(term_id):close()
    end,
  }
end

return M
