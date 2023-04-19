local opt, fn = vim.opt_local, vim.fn
opt.spell = true
opt.syntax = 'off'

map('n', '<leader>so', function()
  vim.cmd.source('%')
  vim.notify('Sourced ' .. fn.expand('%'))
end)

-- TODO: if the syntax isn't delayed it still gets enabled
-- vim.schedule(function() opt.syntax = 'off' end)
