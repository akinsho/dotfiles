-- TODO: ask treesitter team what the correct way to do this is
-- disable syntax based highlighting for dart and use only treesitter
-- this still lets the syntax file be loaded for things like the LSP.
vim.bo.syntax = ''

if not as then return end
as.ftplugin_conf(
  'which-key',
  function(wk)
    wk.register({
      cc = { '<Cmd>Telescope flutter commands<CR>', 'flutter: commands' },
      d = {
        name = '+flutter',
        d = { '<Cmd>FlutterDevices<CR>', 'flutter: devices' },
        b = {
          "<cmd>TermExec cmd='flutter pub run build_runner build --delete-conflicting-outputs'<CR>",
          'flutter: run code generation',
        },
        e = { '<Cmd>FlutterEmulators<CR>', 'flutter: emulators' },
        o = { '<Cmd>FlutterOutline<CR>', 'flutter: outline' },
        q = { '<Cmd>FlutterQuit<CR>', 'flutter: quit' },
        r = {
          name = '+dev-server',
          n = { '<Cmd>FlutterRun<CR>', 'run' },
          s = { '<Cmd>FlutterRestart<CR>', 'restart' },
        },
      },
    }, {
      prefix = '<leader>',
      buffer = vim.api.nvim_get_current_buf(),
    })
  end
)
