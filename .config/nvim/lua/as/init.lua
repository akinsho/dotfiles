require("as.globals")
require("as.settings")
require("as.highlights")
require("as.statusline")
require("as.numbers")
require("as.mappings")
require("as.folds")
require("as.dev").setup(false) -- Disabled
require("as.whitespace").setup()
require("as.localrc").setup("VimEnter")
-- Source plugins after config but during startup
require("as.plugins")
