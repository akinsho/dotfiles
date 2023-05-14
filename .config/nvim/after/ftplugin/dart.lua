vim.bo.syntax = ''
vim.bo.textwidth = 100
vim.opt_local.spell = true

map('n', '<leader>dd', '<Cmd>FlutterDevices<CR>', { desc = 'flutter: devices', buffer = 0 })
map('n', '<leader>de', '<Cmd>FlutterEmulators<CR>', { desc = 'flutter: emulators', buffer = 0 })
map('n', '<leader>do', '<Cmd>FlutterOutline<CR>', { desc = 'flutter: outline', buffer = 0 })
map('n', '<leader>dq', '<Cmd>FlutterQuit<CR>', { desc = 'flutter: quit', buffer = 0 })
map('n', '<leader>drn', '<Cmd>FlutterRun<CR>', { desc = 'flutter: server run', buffer = 0 })
map('n', '<leader>drs', '<Cmd>FlutterRestart<CR>', { desc = 'flutter: server restart', buffer = 0 })
map('n', '<leader>rn', '<Cmd>FlutterRename<CR>', { desc = 'flutter: rename class (& file)', buffer = 0 })
map('n', '<leader>db', "<Cmd>TermExec cmd='flutter pub run build_runner watch'<CR>", {
  desc = 'flutter: run code generation',
  buffer = 0,
})
