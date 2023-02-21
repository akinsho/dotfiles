-- TODO: ask treesitter team what the correct way to do this is
-- disable syntax based highlighting for dart and use only treesitter
-- this still lets the syntax file be loaded for things like the LSP.
vim.bo.syntax = ''
vim.bo.textwidth = 100

if not as then return end

local function with_desc(desc) return { buffer = 0, desc = desc } end

map('n', '<leader>cc', '<Cmd>Telescope flutter commands<CR>', with_desc('flutter: commands'))
map('n', '<leader>dd', '<Cmd>FlutterDevices<CR>', with_desc('flutter: devices'))
map('n', '<leader>de', '<Cmd>FlutterEmulators<CR>', with_desc('flutter: emulators'))
map('n', '<leader>do', '<Cmd>FlutterOutline<CR>', with_desc('flutter: outline'))
map('n', '<leader>dq', '<Cmd>FlutterQuit<CR>', with_desc('flutter: quit'))
map('n', '<leader>drn', '<Cmd>FlutterRun<CR>', with_desc('flutter: server run'))
map('n', '<leader>drs', '<Cmd>FlutterRestart<CR>', with_desc('flutter: server restart'))
map(
  'n',
  '<leader>db',
  "<cmd>TermExec cmd='flutter pub run build_runner build --delete-conflicting-outputs'<CR>",
  with_desc('flutter: run code generation')
)
