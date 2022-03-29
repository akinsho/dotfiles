-- Override lspconfig's default border (or lack there of to use my own)
-- @reference: https://github.com/neovim/nvim-lspconfig/issues/1717
vim.api.nvim_win_set_config(0, { border = as.style.current.border })
