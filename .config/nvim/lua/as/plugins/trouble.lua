local M = {}

function M.setup()
  require('which-key').register {
    ['<leader>l'] = {
      d = 'trouble: toggle',
      r = 'trouble: lsp references',
    },
    ['[d'] = 'trouble: next item',
    [']d'] = 'trouble: previous item',
  }
end

function M.config()
  local trouble = require 'trouble'
  as.nnoremap('<leader>ld', '<cmd>TroubleToggle workspace_diagnostics<CR>')
  as.nnoremap('<leader>lr', '<cmd>TroubleToggle lsp_references<CR>')
  as.nnoremap(']d', function()
    trouble.previous { skip_groups = true, jump = true }
  end)
  as.nnoremap('[d', function()
    trouble.next { skip_groups = true, jump = true }
  end)
  trouble.setup { auto_close = true, auto_preview = false }
end

return M
