local opt = vim.opt_local
local cmd, fn, fmt = vim.cmd, vim.fn, string.format

-- Autosize quickfix to match its minimum content
-- https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
local function adjust_height(minheight, maxheight)
  cmd(fmt('%dwincmd _', math.max(math.min(fn.line('$'), maxheight), minheight)))
end

-- force quickfix to open beneath all other splits
cmd.wincmd('J')

opt.wrap = false
opt.number = false -- HACK: this is forcefully set by nvim-bqf intentionally to override my settings
opt.signcolumn = 'yes'
opt.buflisted = false -- quickfix buffers should not pop up when doing :bn or :bp

adjust_height(3, 10)
opt.winfixheight = true
----------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------
as.nnoremap('dd', as.qf.delete, { desc = 'delete current quickfix entry', buffer = 0 })
as.vnoremap('d', as.qf.delete, { desc = 'delete selected quickfix entry', buffer = 0 })
----------------------------------------------------------------------------------
-- Mappings
----------------------------------------------------------------------------------

as.nnoremap('H', ':colder<CR>', { buffer = 0 })
as.nnoremap('L', ':cnewer<CR>', { buffer = 0 })

-- Resources and inspiration
-- 2. https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22
