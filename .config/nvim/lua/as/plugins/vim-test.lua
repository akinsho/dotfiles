return function()
  vim.cmd [[
    function! ToggleTermStrategy(cmd) abort
      call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
    endfunction
    let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
    let g:test#strategy = 'toggleterm'
  ]]
  require('which-key').register {
    ['<localleader>t'] = {
      name = '+vim-test',
      f = { 'test: file', '<cmd>TestFile<CR>' },
      n = { 'test: nearest', '<cmd>TestNearest<CR>' },
      s = { 'test: suite', '<cmd>TestSuite<CR>' },
    },
  }
end
