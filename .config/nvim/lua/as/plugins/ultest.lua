local M = {}

function M.setup()
  vim.g.ultest_running_sign = ''
end

function M.config()
  local pattern = { '*_test.*', '*_spec.*' }
  as.augroup('UltestTests', {
    { event = 'BufWritePost', pattern = pattern, command = 'UltestNearest' },
    {
      event = 'BufEnter',
      pattern = pattern,
      command = function()
        vim.schedule(function()
          vim.cmd('Ultest')
        end)
      end,
    },
  })
  as.nmap(']t', '<Plug>(ultest-next-fail)', {
    label = 'ultest: next failure',
    buffer = 0,
  })
  as.nmap('[t', '<Plug>(ultest-prev-fail)', {
    label = 'ultest: previous failure',
    buffer = 0,
  })
end

return M
