if not as then return end

local api, fn, cmd = vim.api, vim.fn, vim.cmd

as.augroup('UnusedBuffers', {
  event = 'BufRead',
  command = function(args)
    api.nvim_create_autocmd({ 'InsertEnter', 'BufModifiedSet' }, {
      buffer = args.buf,
      once = true,
      callback = function(a) vim.b[a.buf].bufpersist = true end,
    })
  end,
})

as.command('CloseUnusedBuffers', function()
  local curbuf = api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(
    function(buf) return vim.bo[buf].buflisted and buf ~= curbuf and not vim.b[buf].bufpersist end,
    api.nvim_list_bufs()
  )
  local names = vim.tbl_map(function(buf) return fn.expand(('#%s:.'):format(buf)) end, bufs)

  vim.ui.input({
    prompt = ('Close unused buffers? (y/n)\n - %s\n'):format(table.concat(names, '\n - ')),
  }, function(answer)
    if answer == 'y' then
      cmd.wall()
      as.foreach(function(buf) api.nvim_buf_delete(buf, { force = true }) end, bufs)
    end
  end)
end)

map('n', 'gbc', '<Cmd>CloseUnusedBuffers<CR>', { silent = true, desc = 'Close unused buffers' })
