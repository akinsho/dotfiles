local opt = vim.opt_local

opt.wrap = false
opt.number = false
opt.signcolumn = 'yes'
opt.buflisted = false
opt.winfixheight = true

map('n', 'dd', as.list.qf.delete, { desc = 'delete current quickfix entry' })
map('v', 'd', as.list.qf.delete, { desc = 'delete selected quickfix entry' })
map('n', 'H', ':colder<CR>')
map('n', 'L', ':cnewer<CR>')
-- force quickfix to open beneath all other splits
vim.cmd.wincmd('J')
as.adjust_split_height(3, 10)
