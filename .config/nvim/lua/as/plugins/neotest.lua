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
      require('neotest-go'),
    },
  })
  local function open()
    neotest.output.open({ enter = false })
  end
  local function run_file()
    neotest.run.run(vim.fn.expand('%'))
  end
  as.nnoremap('<localleader>ts', neotest.summary.toggle, 'neotest: run suite')
  as.nnoremap('<localleader>to', open, 'neotest: output')
  as.nnoremap('<localleader>tn', neotest.run.run, 'neotest: run')
  as.nnoremap('<localleader>tf', run_file, 'neotest: run file')
end
