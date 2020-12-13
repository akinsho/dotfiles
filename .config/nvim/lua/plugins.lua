local map = vim.api.nvim_set_keymap
local gitsigns_loaded, gitsigns = pcall(require, "gitsigns")
if gitsigns_loaded then
  gitsigns.setup {
    signs = {
      add = {hl = "GitGutterAdd", text = "▌"},
      change = {hl = "GitGutterChange", text = "▌"},
      delete = {hl = "GitGutterDelete", text = "▌"},
      topdelete = {hl = "GitGutterDelete", text = "▌"},
      changedelete = {hl = "GitGutterChange", text = "▌"}
    },
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
      local added = status.added > 0 and "  " .. status.added or ""
      local changed = status.changed > 0 and "  " .. status.changed or ""
      local removed = status.removed > 0 and "  " .. status.removed or ""
      return status.head .. added .. changed .. removed .. " "
    end
  }
end

map(
  "i",
  "<c-l>",
  "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'",
  {expr = true}
)
map(
  "s",
  "<c-l>",
  "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<c-l>'",
  {expr = true}
)
map(
  "i",
  "<c-h>",
  "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'",
  {expr = true}
)
map(
  "s",
  "<c-h>",
  "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-prev)' : '<c-h>'",
  {expr = true}
)
map(
  "x",
  "<c-j>",
  [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
  {expr = true}
)
map(
  "i",
  "<c-j>",
  [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
  {expr = true}
)
map(
  "s",
  "<c-j>",
  [[vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>']],
  {expr = true}
)
