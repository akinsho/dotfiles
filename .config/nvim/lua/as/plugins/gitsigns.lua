return function()
  require("gitsigns").setup {
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
      ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>'
    },
    status_formatter = function(status)
      local added = status.added and status.added > 0 and "  " .. status.added or ""
      local changed = status.changed and status.changed > 0 and "  " .. status.changed or ""
      local removed = status.removed and status.removed > 0 and "  " .. status.removed or ""
      return status.head .. added .. changed .. removed .. " "
    end
  }
end
