return function()
  local neotest = require('neotest')
  neotest.setup({
    diagnostic = {
      enabled = false,
    },
    icons = {
      running = as.style.icons.misc.clock,
    },
    floating = {
      border = as.style.current.border,
    },
    adapters = {
      require('neotest-plenary'),
      require('neotest-go')({
        experimental = {
          test_table = true,
        },
      }),
    },
  })
  local function open()
    neotest.output.open({ enter = true, short = false })
  end
  local function run_file()
    neotest.run.run(vim.fn.expand('%'))
  end
  as.nnoremap('<localleader>ts', neotest.summary.toggle, 'neotest: run suite')
  as.nnoremap('<localleader>to', open, 'neotest: output')
  as.nnoremap('<localleader>tn', neotest.run.run, 'neotest: run')
  as.nnoremap('<localleader>tf', run_file, 'neotest: run file')
  as.nnoremap('[n', function()
    neotest.jump.prev({ status = 'failed' })
  end, 'jump to next failed test')
  as.nnoremap(']n', function()
    neotest.jump.next({ status = 'failed' })
  end, 'jump to previous failed test')
end
