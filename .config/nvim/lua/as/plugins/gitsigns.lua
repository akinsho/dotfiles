return function()
  local gitsigns = require("gitsigns")

  as.nnoremap("<localleader>gbl", gitsigns.blame_line)
  as.nnoremap("<localleader>gre", "<cmd>Gitsigns reset_buffer<CR>")
  as.nnoremap("<localleader>gw", "<cmd>Gitsigns stage_buffer<CR>")

  gitsigns.setup {
    debug_mode = false,
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
