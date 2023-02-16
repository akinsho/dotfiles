vim.opt_local.iskeyword:append(':,#')

as.nnoremap('<leader>so', function()
  vim.cmd.source('%')
  vim.notify('Sourced ' .. vim.fn.expand('%'))
end, { buffer = 0 })
