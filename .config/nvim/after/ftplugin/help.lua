local opt, fn, api = vim.opt_local, vim.fn, vim.api

opt.list = false
opt.wrap = false
opt.spell = true
opt.textwidth = 78

as.ftplugin_conf({
  ['virt-column'] = function(col)
    if vim.bo.modifiable then col.setup_buffer({ virtcolumn = '+1' }) end
  end,
})

local opts = { buffer = 0 }

-- if this a vim help file create mappings to make navigation easier otherwise enable preferred editing settings
if vim.startswith(fn.expand('%'), vim.env.VIMRUNTIME) or vim.bo.readonly then
  opt.spell = false
  api.nvim_create_autocmd('BufWinEnter', { buffer = 0, command = 'wincmd L | vertical resize 80' })
  -- https://vim.fandom.com/wiki/Learn_to_use_help
  map('n', '<CR>', '<C-]>', opts)
  map('n', '<BS>', '<C-T>', opts)
else
  map('n', '<leader>ml', 'maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a', opts)
end
