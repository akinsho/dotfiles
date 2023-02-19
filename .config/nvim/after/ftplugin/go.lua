local opt = vim.opt_local

opt.expandtab = false
opt.softtabstop = 0
opt.tabstop = 4
opt.shiftwidth = 4

if not as then return end

local with_desc = function(desc) return { buffer = 0, desc = desc } end

map('n', '<leader>gb', '<Cmd>GoBuild<CR>', with_desc('build'))
map('n', '<leader>gfs', '<Cmd>GoFillStruct<CR>', with_desc('fill struct'))
map('n', '<leader>gfp', '<Cmd>GoFixPlurals<CR>', with_desc('fix plurals'))
map('n', '<leader>gie', '<Cmd>GoIfErr<CR>', with_desc('if err'))
