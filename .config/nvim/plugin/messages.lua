if not as or vim.g.vscode then return end

-----------------------------------------------------------------------------//
-- Core message and cmdline UI, see `:h ui2`
-----------------------------------------------------------------------------//
-- Messages go to an ephemeral floating window rather than the cmdline, which is
-- what makes a 'cmdheight' of 0 usable. Output that is worth scrolling or
-- yanking is sent to the pager instead, since that is a real buffer.
require('vim._core.ui2').enable({
  msg = {
    target = 'msg',
    targets = {
      lua_error = 'pager',
      rpc_error = 'pager',
      shell_out = 'pager',
      shell_err = 'pager',
      list_cmd = 'pager',
      verbose = 'pager',
    },
    msg = { timeout = 4000 },
  },
})
