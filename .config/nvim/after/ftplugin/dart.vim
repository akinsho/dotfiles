lua << EOF
-- Open flutter only commands in dart files
local success, wk = pcall(require, 'which-key')
if not success then return end
wk.register({
  cc = {"<Cmd>Telescope flutter commands<CR>", "flutter: commands"},
  d = {
    name = "+flutter",
    d = {"<Cmd>FlutterDevices<CR>", "flutter: devices"},
    e = {"<Cmd>FlutterEmulators<CR>", "flutter: emulators"},
    o = {"<Cmd>FlutterOutline<CR>", "flutter: outline"},
    q = {"<Cmd>FlutterQuit<CR>", "flutter: quit"},
    r = {
      name = "+dev-server",
      n = {"<Cmd>FlutterRun<CR>", "run"},
      s = {"<Cmd>FlutterRestart<CR>", "restart"}
      }
    }
}, {prefix = "<leader>"})
EOF
