return function()
  -- as.nnoremap('<leader>Mc', ':lua require"gitsigns".dump_cache()<cr>')
  -- as.nnoremap('<leader>Mm', ':lua require"gitsigns".debug_messages()<cr>')
  require("gitsigns").setup {
    debug_mode = true,
    signs = {
      add = {hl = "GitGutterAdd", text = "▌"},
      change = {hl = "GitGutterChange", text = "▌"},
      delete = {hl = "GitGutterDelete", text = "▌"},
      topdelete = {hl = "GitGutterDelete", text = "▌"},
      changedelete = {hl = "GitGutterChange", text = "▌"}
    },
    numhl = false,
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,
      ["n [h"] = {
        expr = true,
        '&diff ? \']h\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''
      },
      ["n ]h"] = {
        expr = true,
        '&diff ? \'[h\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''
      },
      ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
      ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
      ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>'
    }
  }
end
