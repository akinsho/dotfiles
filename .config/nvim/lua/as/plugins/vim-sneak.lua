return function ()
  vim.g["sneak#prompt"]     = '🔎 '
  vim.g["sneak#label"]      = 1
  vim.g["sneak#s_next"]     = 0
  vim.g["sneak#use_ic_scs"] = 1

  local map = as_utils.map
  local opts = { silent = true }
  -- 1-character enhanced 'f'
  map("n", "f", "<Plug>Sneak_f", opts)
  map("n", "F", "<Plug>Sneak_F", opts)
  -- visual-mode
  map("x", "f", "<Plug>Sneak_f", opts)
  map("x", "F", "<Plug>Sneak_F", opts)
  -- operator-pending-mode
  map("o", "f", "<Plug>Sneak_f", opts)
  map("o", "F", "<Plug>Sneak_F", opts)

  -- 1-character enhanced 't'
  map("n", "t", "<Plug>Sneak_t", opts)
  map("n", "T", "<Plug>Sneak_T", opts)
  -- visual-mode
  map("x", "t", "<Plug>Sneak_t", opts)
  map("x", "T", "<Plug>Sneak_T", opts)
  -- operator-pending-mode
  map("o", "t", "<Plug>Sneak_t", opts)
  map("o", "T", "<Plug>Sneak_T", opts)
end
