-- TODO: ask treesitter team what the correct way to do this is
-- disable syntax based highlighting for dart and use only treesitter
-- this still lets the syntax file be loaded for things like the LSP.
vim.bo.syntax = ''

if not as then return end

local function with_desc(desc) return { buffer = 0, desc = desc } end

as.nnoremap('<leader>cc', '<Cmd>Telescope flutter commands<CR>', with_desc('flutter: commands'))
as.nnoremap('<leader>dd', '<Cmd>FlutterDevices<CR>', with_desc('flutter: devices'))
as.nnoremap(
  '<leader>db',
  "<cmd>TermExec cmd='flutter pub run build_runner build --delete-conflicting-outputs'<CR>",
  'flutter: run code generation'
)
as.nnoremap('<leader>de', '<Cmd>FlutterEmulators<CR>', with_desc('flutter: emulators'))
as.nnoremap('<leader>do', '<Cmd>FlutterOutline<CR>', with_desc('flutter: outline'))
as.nnoremap('<leader>dq', '<Cmd>FlutterQuit<CR>', with_desc('flutter: quit'))
as.nnoremap('<leader>drn', '<Cmd>FlutterRun<CR>', with_desc('flutter: server run'))
as.nnoremap('<leader>drs', '<Cmd>FlutterRestart<CR>', with_desc('flutter: server restart'))
