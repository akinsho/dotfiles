local M = {}

function M.setup()
  vim.g.ultest_running_sign = ''
  vim.g.ultest_output_max_width = math.floor(vim.o.columns * 0.8)
  vim.g.ultest_output_max_height = math.floor(vim.o.lines * 0.3)
end

function M.config()
  vim.cmd('UpdateRemotePlugins')
  local pattern = { '*_test.*', '*_spec.*' }
  as.augroup('UltestTests', {
    { event = 'BufWritePost', pattern = pattern, command = 'UltestNearest' },
    {
      event = 'BufEnter',
      pattern = pattern,
      command = function(args)
        as.nmap(']t', '<Plug>(ultest-next-fail)', {
          desc = 'ultest: next failure',
          buffer = args.buf,
        })
        as.nmap('[t', '<Plug>(ultest-prev-fail)', {
          desc = 'ultest: previous failure',
          buffer = args.buf,
        })
        vim.schedule(function()
          vim.cmd('Ultest')
        end)
      end,
    },
  })
end

return M
