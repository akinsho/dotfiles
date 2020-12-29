require("as.mappings")
require("as.statusline")
require("as.highlights")
require("as.numbers")

-- delay setting up the lsp till vim has started
vim.cmd [[autocmd! VimEnter * ++once lua require("as.lsp").setup()]]
