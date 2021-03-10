require("as.globals")
require("as.settings")
require("as.plugins")
require("as.highlights")
require("as.statusline")
require("as.numbers")
require("as.mappings")
require("as.folds")
require("as.localrc").setup()

function _G.__as_setup_configs()
  require("as.whitespace").setup()
end
-- delay setting up of some configs like lsp till vim has started
vim.cmd [[autocmd! VimEnter * ++once lua __as_setup_configs()]]
