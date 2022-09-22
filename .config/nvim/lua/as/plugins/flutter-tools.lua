return function()
  require('flutter-tools').setup({
    ui = { border = as.style.current.border },
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
    dev_log = { enabled = false, open_cmd = 'tabedit' },
    lsp = {
      color = {
        enabled = true,
        background = true,
        virtual_text = false,
      },
      settings = {
        showTodos = false,
        renameFilesWithClasses = 'prompt',
        updateImportsOnRename = true,
        completeFunctionCalls = true,
        lineLength = 100,
      },
    },
  })
end
