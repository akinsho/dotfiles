local M = {}

function M.setup()
  vim.g.ultest_running_sign = ''
  vim.g.ultest_output_max_width = math.floor(vim.o.columns * 0.8)
  vim.g.ultest_output_max_height = math.floor(vim.o.lines * 0.3)
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
    desc = 'ultest: next failure',
    buffer = 0,
  })
  as.nmap('[t', '<Plug>(ultest-prev-fail)', {
    desc = 'ultest: previous failure',
    buffer = 0,
  })
end

return M
