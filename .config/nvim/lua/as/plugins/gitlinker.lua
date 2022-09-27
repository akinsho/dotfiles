local M = {}

function M.setup()
  local function linker() return require('gitlinker') end
  local function browser_open()
    return { action_callback = require('gitlinker.actions').open_in_browser }
  end

  as.nnoremap(
    '<localleader>gu',
    function() linker().get_buf_range_url('n') end,
    'gitlinker: copy line to clipboard'
  )
  as.vnoremap(
    '<localleader>gu',
    function() linker().get_buf_range_url('v') end,
    'gitlinker: copy range to clipboard'
  )

  as.nnoremap(
    '<localleader>go',
    function() linker().get_repo_url(browser_open()) end,
    'gitlinker: open in browser'
  )
  as.nnoremap(
    '<localleader>go',
    function() linker().get_buf_range_url('n', browser_open()) end,
    'gitlinker: open current line in browser'
  )
  as.vnoremap(
    '<localleader>go',
    function() linker().get_buf_range_url('v', browser_open()) end,
    'gitlinker: open current selection in browser'
  )
end

function M.config() require('gitlinker').setup({ mappings = nil }) end

return M
