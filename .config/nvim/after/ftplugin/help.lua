local opt, fn, api = vim.opt, vim.fn, vim.api

local opts = { buffer = 0, silent = true }

vim.opt_local.list = false

-- if this a vim help file create mappings to make navigation easier
-- otherwise enable preferred editing settings
if vim.startswith(fn.expand('%'), vim.env.VIMRUNTIME) or vim.bo.readonly then
  api.nvim_create_autocmd('BufWinEnter', {
    buffer = 0,
    command = 'wincmd L | vertical resize 80',
  })
  -- https://vim.fandom.com/wiki/Learn_to_use_help
  map('n', '<CR>', '<C-]>', opts)
  map('n', '<BS>', '<C-T>', opts)
  -- search forwards and backwards for 'options'
  map('n', 'o', [[/'\l\{2,\}'<CR>]], opts)
  map('n', 'O', [[?'\l\{2,\}'<CR>]], opts)
  -- search forwards and backwards for |subject|
  map('n', 's', [[/\|\zs\S+\ze\|<CR>]], opts)
  map('n', 'S', [[?\|\zs\S+\ze\|<CR>]], opts)
else
  opt.spell, opt.spelllang = true, 'en_gb'
  opt.textwidth = 78
  as.ftplugin_conf({
    ['virt-column'] = function(col) col.setup_buffer({ virtcolumn = '+1' }) end,
  })
  map('n', '<leader>ml', 'maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a', opts)
end
