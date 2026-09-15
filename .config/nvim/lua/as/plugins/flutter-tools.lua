local function config()
  require('flutter-tools').setup({
    ui = { border = as.ui.current.border },
    debugger = {
      enabled = true,
      run_via_dap = true,
      exception_breakpoints = {},
    },
    outline = { auto_open = false },
    decorations = {
      statusline = { device = true, app_version = true },
    },
    widget_guides = { enabled = true, debug = false },
    -- The debugger supersedes the dev log, so only one of the two is enabled.
    dev_log = { enabled = false, open_cmd = 'tabedit' },
    -- Document colours are deliberately not configured here; `vim.lsp.document_color`
    -- is enabled on attach for any server advertising the capability.
    lsp = {
      settings = {
        showTodos = false,
        renameFilesWithClasses = 'always',
        updateImportsOnRename = true,
        completeFunctionCalls = true,
        lineLength = 100,
      },
    },
  })
end

return {
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    enable = false,
    dev = false,
    config = config,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'RobertBrunhage/flutter-riverpod-snippets', lazy = false },
    },
  },
}
