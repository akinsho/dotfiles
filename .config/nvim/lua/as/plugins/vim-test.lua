local M = {}

function M.setup()
  require('which-key').register {
    ['<localleader>t'] = {
      name = '+vim-test',
      f = { '<cmd>TestFile<CR>', 'test: file' },
      n = { '<cmd>TestNearest<CR>', 'test: nearest' },
      s = { '<cmd>TestSuite<CR>', 'test: suite' },
    },
  }
end

function M.config()
  vim.cmd [[
    function! ToggleTermStrategy(cmd) abort
      call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
    endfunction
    let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
    let g:test#strategy = 'toggleterm'
  ]]
end

return M
