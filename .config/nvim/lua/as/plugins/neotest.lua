local M = {}

function M.config()
  local function open() require('neotest').output.open({ enter = true, short = false }) end
  local function run_file() require('neotest').run.run(vim.fn.expand('%')) end
  local function run_file_sync()
    require('neotest').run.run({ vim.fn.expand('%'), concurrent = false })
  end
  local function nearest() require('neotest').run.run() end
  local function next_failed() require('neotest').jump.prev({ status = 'failed' }) end
  local function prev_failed() require('neotest').jump.next({ status = 'failed' }) end
  local function toggle_summary() require('neotest').summary.toggle() end
  local function cancel() require('neotest').run.stop({ interactive = true }) end

  as.nnoremap('<localleader>ts', toggle_summary, 'neotest: run suite')
  as.nnoremap('<localleader>to', open, 'neotest: output')
  as.nnoremap('<localleader>tn', nearest, 'neotest: run')
  as.nnoremap('<localleader>tf', run_file, 'neotest: run file')
  as.nnoremap('<localleader>tF', run_file_sync, 'neotest: run file synchronously')
  as.nnoremap('<localleader>ts', cancel, 'neotest: cancel')
  as.nnoremap('[n', next_failed, 'jump to next failed test')
  as.nnoremap(']n', prev_failed, 'jump to previous failed test')

  require('neotest').setup({
    discovery = {
      enabled = false,
    },
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
end

return M
