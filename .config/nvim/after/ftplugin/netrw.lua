vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_fastbrowse = 0

vim.opt_local.bufhidden = 'wipe'

map('n', 'q', '<Cmd>q<CR>', { buffer = 0 })
map('n', 'l', '<CR>', { buffer = 0 })
map('n', 'h', '<CR>', { buffer = 0 })
map('n', 'o', '<CR>', { buffer = 0 })
