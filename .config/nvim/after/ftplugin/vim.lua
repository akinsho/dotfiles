local opt, fn = vim.opt_local, vim.fn
opt.spell = true

map('n', '<leader>so', function()
  vim.cmd.source('%')
  vim.notify('Sourced ' .. fn.expand('%'))
end)

vim.schedule(function() opt.syntax = 'off' end) -- FIXME: if the syntax isn't delayed it still gets enabled
