local opt = vim.opt_local

opt.wrap = false
opt.number = false
opt.signcolumn = 'yes'
opt.buflisted = false
opt.winfixheight = true

map('n', 'dd', as.list.qf.delete, { desc = 'delete current quickfix entry', buffer = 0 })
map('v', 'd', as.list.qf.delete, { desc = 'delete selected quickfix entry', buffer = 0 })
map('n', 'H', ':colder<CR>', { buffer = 0 })
map('n', 'L', ':cnewer<CR>', { buffer = 0 })
-- force quickfix to open beneath all other splits
vim.cmd.wincmd('J')
as.adjust_split_height(3, 10)
