require("as.highlights")
require("as.statusline")
require("as.numbers")
require("as.mappings")
require("as.localrc").setup()

-- delay setting up the lsp till vim has started
vim.cmd [[autocmd! VimEnter * ++once lua require("as.lsp").setup()]]
