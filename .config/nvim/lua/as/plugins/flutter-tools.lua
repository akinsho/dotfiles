local function config()
  local is_nightly = as.nightly()
  require('flutter-tools').setup({
    ui = { border = as.ui.current.border },
    debugger = {
      enabled = is_nightly,
      run_via_dap = is_nightly,
      exception_breakpoints = {},
    },
    outline = { auto_open = false },
    decorations = {
      statusline = { device = true, app_version = true },
    },
    widget_guides = { enabled = true, debug = false },
    dev_log = { enabled = not is_nightly, open_cmd = 'tabedit' },
    lsp = {
      color = {
        enabled = true,
        background = true,
        virtual_text = false,
      },
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
    dev = true,
    config = config,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'RobertBrunhage/flutter-riverpod-snippets', lazy = false },
    },
  },
}
