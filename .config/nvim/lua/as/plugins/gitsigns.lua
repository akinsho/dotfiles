return function()
  local gitsigns = require 'gitsigns'

  gitsigns.setup {
    signs = {
      add = { hl = 'GitSignsAdd', text = '▌' },
      change = { hl = 'GitSignsChange', text = '▌' },
      delete = { hl = 'GitSignsDelete', text = '▌' },
      topdelete = { hl = 'GitSignsDelete', text = '▌' },
      changedelete = { hl = 'GitSignsChange', text = '▌' },
    },
    word_diff = false,
    numhl = false,
    on_attach = function()
      require('which-key').register {
        ['<leader>h'] = {
          name = '+gitsigns hunk',
          s = { gitsigns.stage_hunk, 'stage' },
          u = { gitsigns.undo_stage_hunk, 'undo stage' },
          r = { gitsigns.reset_hunk, 'reset hunk' },
          p = { gitsigns.preview_hunk, 'preview current hunk' },
          b = 'blame current line',
        },
        ['<localleader>g'] = {
          name = '+git',
          w = { gitsigns.stage_buffer, 'gitsigns: stage entire buffer' },
          r = {
            name = '+reset',
            e = { gitsigns.reset_buffer, 'gitsigns: reset entire buffer' },
          },
          b = {
            name = '+blame',
            l = { gitsigns.blame_line, 'gitsigns: blame current line' },
            d = { gitsigns.toggle_word_diff, 'gitsigns: toggle word diff' },
          },
        },
        ['[h'] = {
          "&diff ? ']h' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
          'go to next git hunk',
          expr = true,
        },
        [']h'] = {
          "&diff ? '[h' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
          'go to previous git hunk',
          expr = true,
        },
        ['<leader>lm'] = {
          function()
            gitsigns.setqflist 'all'
          end,
          'gitsigns: list modified in quickfix',
        },
      }

      as.onoremap('ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>')
      as.xnoremap('ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>')
      -- Text objects
      as.vnoremap('<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end)
      as.vnoremap('<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end)
    end,
  }
end
