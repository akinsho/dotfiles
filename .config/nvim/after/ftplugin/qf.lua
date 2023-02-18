local opt = vim.opt_local
local cmd = vim.cmd

cmd.wincmd('J') -- force quickfix to open beneath all other splits

opt.wrap = false
opt.number = false -- HACK: this is forcefully set by nvim-bqf intentionally to override my settings
opt.signcolumn = 'yes'
opt.buflisted = false -- quickfix buffers should not pop up when doing :bn or :bp

as.adjust_split_height(3, 10)
opt.winfixheight = true
----------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------
map('n', 'dd', as.qf.delete, { desc = 'delete current quickfix entry', buffer = 0 })
map('v', 'd', as.qf.delete, { desc = 'delete selected quickfix entry', buffer = 0 })
----------------------------------------------------------------------------------
-- Mappings
----------------------------------------------------------------------------------
map('n', 'H', ':colder<CR>', { buffer = 0 })
map('n', 'L', ':cnewer<CR>', { buffer = 0 })

-- Resources and inspiration
-- 2. https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22
