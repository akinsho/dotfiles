local opt = vim.opt_local

opt.expandtab = false
opt.textwidth = 0 -- Go doesn't specify a max line length so don't force one
opt.softtabstop = 0
opt.tabstop = 4
opt.shiftwidth = 4

if not as then return end

local with_desc = function(desc) return { buffer = 0, desc = desc } end

as.nnoremap('<leader>gb', '<Cmd>GoBuild<CR>', with_desc('build'))
as.nnoremap('<leader>gfs', '<Cmd>GoFillStruct<CR>', with_desc('fill struct'))
as.nnoremap('<leader>gfp', '<Cmd>GoFixPlurals<CR>', with_desc('fix plurals'))
as.nnoremap('<leader>gie', '<Cmd>GoIfErr<CR>', with_desc('if err'))
