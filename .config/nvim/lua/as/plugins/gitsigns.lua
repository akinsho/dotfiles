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
          s = { '<cmd>lua require"gitsigns".stage_hunk()<CR>', 'stage' },
          u = { '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', 'undo stage' },
          r = { '<cmd>lua require"gitsigns".reset_hunk()<CR>', 'reset hunk' },
          p = { '<cmd>lua require"gitsigns".preview_hunk()<CR>', 'preview current hunk' },
          b = 'blame current line',
        },
        ['<localleader>g'] = {
          name = '+git',
          w = { '<cmd>lua require"gitsigns".stage_buffer()<CR>', 'gitsigns: stage entire buffer' },
          r = {
            name = '+reset',
            e = { '<cmd>lua require"gitsigns".reset_buffer()<CR>', 'gitsigns: reset entire buffer' },
          },
          b = {
            name = '+blame',
            l = { '<cmd>lua require"gitsigns".blame_line()<CR>', 'gitsigns: blame current line' },
            d = { '<cmd>lua require"gitsigns".toggle_word_diff()<CR>', 'gitsigns: toggle word diff' },
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
          '<cmd>lua require"gitsigns".setqflist("all")<CR>',
          'gitsigns: list modified in quickfix',
        },
      }

      as.onoremap('ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>')
      as.xnoremap('ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>')
      -- Text objects
      as.vnoremap(
        '<leader>hs',
        '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>'
      )
      as.vnoremap(
        '<leader>hr',
        '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>'
      )
    end,
  }
end
