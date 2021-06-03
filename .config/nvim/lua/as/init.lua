require("as.globals")
require("as.settings")
require("as.highlights")
require("as.statusline")
require("as.numbers")
require("as.mappings")
require("as.folds")
require("as.whitespace")
require("as.dev").setup(false) -- disabled
require("as.localrc").setup()
require("as.plugins") -- source plugins after config but during startup
require("as.quickfix")
require("as.autocommands")
