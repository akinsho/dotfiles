vim.bo.syntax = ''
vim.bo.textwidth = 100
vim.opt_local.spell = true

map('n', '<leader>cc', '<Cmd>Telescope flutter commands<CR>', { desc = 'flutter: commands' })
map('n', '<leader>dd', '<Cmd>FlutterDevices<CR>', { desc = 'flutter: devices' })
map('n', '<leader>de', '<Cmd>FlutterEmulators<CR>', { desc = 'flutter: emulators' })
map('n', '<leader>do', '<Cmd>FlutterOutline<CR>', { desc = 'flutter: outline' })
map('n', '<leader>dq', '<Cmd>FlutterQuit<CR>', { desc = 'flutter: quit' })
map('n', '<leader>drn', '<Cmd>FlutterRun<CR>', { desc = 'flutter: server run' })
map('n', '<leader>drs', '<Cmd>FlutterRestart<CR>', { desc = 'flutter: server restart' })
map('n', '<leader>rn', '<Cmd>FlutterRename<CR>', { desc = 'flutter: rename class (& file)' })
map('n', '<leader>db', "<Cmd>TermExec cmd='flutter pub run build_runner watch'<CR>", {
  desc = 'flutter: run code generation',
})
