local function init()
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

  as.nnoremap('<localleader>ts', toggle_summary, 'neotest: toggle summary')
  as.nnoremap('<localleader>to', open, 'neotest: output')
  as.nnoremap('<localleader>tn', nearest, 'neotest: run')
  as.nnoremap('<localleader>tf', run_file, 'neotest: run file')
  as.nnoremap('<localleader>tF', run_file_sync, 'neotest: run file synchronously')
  as.nnoremap('<localleader>tc', cancel, 'neotest: cancel')
  as.nnoremap('[n', next_failed, 'jump to next failed test')
  as.nnoremap(']n', prev_failed, 'jump to previous failed test')
end

local function config()
  local namespace = vim.api.nvim_create_namespace('neotest')
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        return diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      end,
    },
  }, namespace)

  require('neotest').setup({
    discovery = { enabled = true },
    diagnostic = {
      enabled = true,
    },
    floating = { border = as.style.current.border },
    adapters = {
      require('neotest-plenary'),
      require('neotest-dart')({
        command = 'flutter',
      }),
      require('neotest-go')({
        experimental = {
          test_table = true,
        },
      }),
    },
  })
end

return {
  {
    'nvim-neotest/neotest',
    init = init,
    config = config,
    dependencies = {
      { 'rcarriga/neotest-plenary' },
      { 'sidlatau/neotest-dart' },
      { 'neotest/neotest-go', dev = true },
    },
  },
}
